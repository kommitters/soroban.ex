defmodule Soroban.Contract.InvokeContractFunction do
  @moduledoc """
  `InvokeContractFunction` implementation to invoke authorized and not authorized contract functions.
  """

  alias Soroban.Contract.RPCCalls
  alias Soroban.RPC.{SendTransactionResponse, SimulateTransactionResponse}

  alias Stellar.Horizon.Accounts

  alias Stellar.TxBuild.{
    Account,
    HostFunction,
    InvokeContractArgs,
    InvokeHostFunction,
    SCAddress,
    SCVal,
    SequenceNumber,
    Signature
  }

  @type account :: Account.t()
  @type function_args :: list(struct())
  @type auth_secret_keys :: list(String.t())
  @type invoke_host_function :: InvokeHostFunction.t()
  @type envelope_xdr :: String.t()
  @type function_name :: String.t()
  @type contract_address :: String.t()
  @type source_secret_key :: String.t()
  @type source_public_key :: String.t()
  @type simulate_response :: {:ok, SimulateTransactionResponse.t()}
  @type send_response :: {:ok, SendTransactionResponse.t()}
  @type signature :: Signature.t()
  @type sequence_number :: SequenceNumber.t()
  @type sc_val_list :: list(SCVal.t())
  @type addl_resources :: keyword()

  @spec invoke(
          contract_address :: contract_address(),
          source_secret_key :: source_secret_key(),
          function_name :: function_name(),
          function_args :: function_args(),
          extra_fee_rate :: float(),
          auth_secret_keys :: auth_secret_keys(),
          addl_resources :: addl_resources()
        ) :: send_response()
  def invoke(
        contract_address,
        source_secret_key,
        function_name,
        function_args,
        extra_fee_rate \\ 0.0,
        auth_secret_keys \\ [],
        addl_resources \\ []
      ) do
    with {public_key, _secret} = keypair <- Stellar.KeyPair.from_secret_seed(source_secret_key),
         {:ok, seq_num} <- Accounts.fetch_next_sequence_number(public_key),
         {:ok, function_args} <- convert_to_sc_val(function_args),
         %Signature{} = signature <- Signature.new(keypair),
         %Account{} = source_account <- Account.new(public_key),
         %SequenceNumber{} = sequence_number <- SequenceNumber.new(seq_num),
         %InvokeHostFunction{} = invoke_host_function_op <-
           create_host_function_op(contract_address, function_name, function_args, public_key) do
      invoke_host_function_op
      |> RPCCalls.simulate(source_account, sequence_number, addl_resources)
      |> RPCCalls.send_transaction(
        source_account,
        sequence_number,
        signature,
        invoke_host_function_op,
        auth_secret_keys,
        extra_fee_rate
      )
    end
  end

  @spec retrieve_unsigned_xdr_to_invoke(
          contract_address :: contract_address(),
          source_public_key :: source_public_key(),
          function_name :: function_name(),
          function_args :: function_args(),
          extra_fee_rate :: float(),
          addl_resources :: addl_resources()
        ) :: envelope_xdr()
  def retrieve_unsigned_xdr_to_invoke(
        contract_address,
        source_public_key,
        function_name,
        function_args,
        extra_fee_rate \\ 0.0,
        addl_resources \\ []
      ) do
    with {:ok, seq_num} <- Accounts.fetch_next_sequence_number(source_public_key),
         {:ok, function_args} <- convert_to_sc_val(function_args),
         %Account{} = source_account <- Account.new(source_public_key),
         %SequenceNumber{} = sequence_number <- SequenceNumber.new(seq_num),
         %InvokeHostFunction{} = invoke_host_function_op <-
           create_host_function_op(
             contract_address,
             function_name,
             function_args,
             source_public_key
           ) do
      invoke_host_function_op
      |> RPCCalls.simulate(source_account, sequence_number, addl_resources)
      |> RPCCalls.retrieve_unsigned_xdr(
        source_account,
        sequence_number,
        invoke_host_function_op,
        extra_fee_rate
      )
    end
  end

  @spec simulate_invoke(
          contract_address :: contract_address(),
          source_public_key :: source_public_key(),
          function_name :: function_name(),
          function_args :: function_args(),
          addl_resources :: addl_resources()
        ) :: simulate_response()
  def simulate_invoke(
        contract_address,
        source_public_key,
        function_name,
        function_args,
        addl_resources \\ []
      ) do
    with {:ok, seq_num} <- Accounts.fetch_next_sequence_number(source_public_key),
         {:ok, function_args} <- convert_to_sc_val(function_args),
         %Account{} = source_account <- Account.new(source_public_key),
         %SequenceNumber{} = sequence_number <- SequenceNumber.new(seq_num),
         %InvokeHostFunction{} = invoke_host_function_op <-
           create_host_function_op(
             contract_address,
             function_name,
             function_args,
             source_public_key
           ) do
      RPCCalls.simulate(invoke_host_function_op, source_account, sequence_number, addl_resources)
    end
  end

  @spec create_host_function_op(
          contract_address :: contract_address(),
          function_name :: function_name(),
          function_args :: function_args(),
          source_public_key :: source_public_key()
        ) :: invoke_host_function()
  defp create_host_function_op(contract_address, function_name, function_args, source_public_key) do
    function_args =
      InvokeContractArgs.new(
        contract_address: SCAddress.new(contract_address),
        function_name: function_name,
        args: function_args
      )

    host_function = HostFunction.new(invoke_contract: function_args)
    InvokeHostFunction.new(host_function: host_function, source_account: source_public_key)
  end

  @spec convert_to_sc_val(function_args :: function_args()) :: {:ok, sc_val_list()}
  defp convert_to_sc_val(function_args) do
    sc_vals = Enum.map(function_args, fn %{__struct__: struct} = arg -> struct.to_sc_val(arg) end)
    {:ok, sc_vals}
  end
end
