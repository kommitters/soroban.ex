defmodule Soroban.Contract.InvokeHostFunction do
  @moduledoc """
  `InvokeHostFunction` implementation to invoke authorized and not authorized contract functions.
  """

  alias Soroban.RPC
  alias Soroban.RPC.{SendTransactionResponse, SimulateTransactionResponse}
  alias Stellar.{Horizon.Accounts, TxBuild}

  alias Stellar.TxBuild.{
    Account,
    ContractAuth,
    HostFunction,
    InvokeHostFunction,
    SCVal,
    SequenceNumber,
    Signature
  }

  @type account :: Account.t()
  @type function_args :: list(struct())
  @type auth :: String.t() | nil
  @type auth_account :: String.t() | nil
  @type auth_accounts :: list(binary())
  @type invoke_host_function :: InvokeHostFunction.t()
  @type function_name :: String.t()
  @type contract_id :: binary()
  @type source_secret_key :: binary()
  @type simulate_response :: {:ok, SimulateTransactionResponse.t()}
  @type send_response :: {:ok, SendTransactionResponse.t()}
  @type signature :: Signature.t()
  @type sequence_number :: SequenceNumber.t()
  @type sc_val_list :: list(SCVal.t())

  @spec invoke(
          contract_id :: contract_id(),
          source_secret_key :: source_secret_key(),
          function_name :: function_name(),
          function_args :: function_args(),
          auth_accounts :: auth_accounts()
        ) :: send_response()
  def invoke(
        contract_id,
        source_secret_key,
        function_name,
        function_args,
        auth_accounts \\ []
      ) do
    function_args = covert_to_sc_val(function_args)
    keypair = {public_key, _secret} = Stellar.KeyPair.from_secret_seed(source_secret_key)
    signature = Signature.new(keypair)
    source_account = Account.new(public_key)
    {:ok, seq_num} = Accounts.fetch_next_sequence_number(public_key)
    sequence_number = SequenceNumber.new(seq_num)

    function =
      HostFunction.new(
        type: :invoke,
        contract_id: contract_id,
        function_name: function_name,
        args: function_args
      )

    invoke_host_function_op = InvokeHostFunction.new(function: function)
    auth_account = Enum.at(auth_accounts, 0)

    source_account
    |> simulate(sequence_number, invoke_host_function_op)
    |> send_transaction(
      source_account,
      sequence_number,
      signature,
      auth_account,
      invoke_host_function_op
    )
  end

  @spec simulate(
          source_account :: account(),
          sequence_number :: sequence_number(),
          invoke_host_function_op :: invoke_host_function()
        ) :: simulate_response()
  defp simulate(
         source_account,
         sequence_number,
         invoke_host_function_op
       ) do
    {:ok, envelop_xdr} =
      source_account
      |> TxBuild.new(sequence_number: sequence_number)
      |> TxBuild.add_operation(invoke_host_function_op)
      |> TxBuild.envelope()

    RPC.simulate_transaction(envelop_xdr)
  end

  @spec send_transaction(
          simulate_response :: simulate_response(),
          source_account :: account(),
          sequence_number :: sequence_number(),
          signature :: signature(),
          auth_account :: auth_account(),
          invoke_host_function_op :: invoke_host_function()
        ) :: send_response() | simulate_response()
  defp send_transaction(
         {:ok, %SimulateTransactionResponse{results: [%{footprint: footprint, auth: auth}]}},
         source_account,
         sequence_number,
         signature,
         auth_account,
         invoke_host_function_op
       ) do
    invoke_host_function_op =
      set_invoke_host_function_params(invoke_host_function_op, footprint, auth, auth_account)

    {:ok, envelope_xdr} =
      source_account
      |> TxBuild.new(sequence_number: sequence_number)
      |> TxBuild.add_operation(invoke_host_function_op)
      |> TxBuild.sign(signature)
      |> TxBuild.envelope()

    RPC.send_transaction(envelope_xdr)
  end

  defp send_transaction(
         {:ok, %SimulateTransactionResponse{}} = response,
         _source_account,
         _sequence_number,
         _signature,
         _auth_account,
         _invoke_host_function_op
       ),
       do: response

  @spec set_invoke_host_function_params(
          invoke_host_function :: invoke_host_function(),
          footprint :: String.t(),
          auth :: auth(),
          auth_account :: auth_account()
        ) :: invoke_host_function() | {:error, :required_auth}
  defp set_invoke_host_function_params(invoke_host_function_op, footprint, [auth], nil) do
    invoke_host_function_op
    |> InvokeHostFunction.set_footprint(footprint)
    |> InvokeHostFunction.set_contract_auth(auth)
  end

  defp set_invoke_host_function_params(invoke_host_function_op, footprint, [auth], auth_account) do
    authorization = ContractAuth.sign_xdr(auth, auth_account)

    invoke_host_function_op
    |> InvokeHostFunction.set_footprint(footprint)
    |> InvokeHostFunction.set_contract_auth(authorization)
  end

  defp set_invoke_host_function_params(invoke_host_function_op, footprint, nil, _auth_account),
    do: InvokeHostFunction.set_footprint(invoke_host_function_op, footprint)

  @spec covert_to_sc_val(function_args :: function_args()) :: sc_val_list()
  defp covert_to_sc_val(function_args),
    do: Enum.map(function_args, fn %{__struct__: struct} = arg -> struct.to_sc_val(arg) end)
end
