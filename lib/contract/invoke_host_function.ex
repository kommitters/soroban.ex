defmodule Soroban.Contract.InvokeHostFunction do
  @moduledoc """
  `InvokeHostFunction` implementation to invoke authorized and not authorized contract functions.
  """

  alias Soroban.Contract.RPCCalls
  alias Soroban.RPC.SendTransactionResponse

  alias Stellar.Horizon.Accounts

  alias Stellar.TxBuild.{
    Account,
    HostFunction,
    InvokeHostFunction,
    SCVal,
    SequenceNumber,
    Signature
  }

  @type account :: Account.t()
  @type function_args :: list(struct())
  @type auth_accounts :: list(binary())
  @type invoke_host_function :: InvokeHostFunction.t()
  @type function_name :: String.t()
  @type contract_id :: binary()
  @type source_secret_key :: binary()
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
    with {public_key, _secret} = keypair <- Stellar.KeyPair.from_secret_seed(source_secret_key),
         {:ok, seq_num} <- Accounts.fetch_next_sequence_number(public_key),
         {:ok, function_args} <- convert_to_sc_val(function_args),
         signature <- Signature.new(keypair),
         source_account <- Account.new(public_key),
         sequence_number <- SequenceNumber.new(seq_num),
         auth_account <- Enum.at(auth_accounts, 0) do
      invoke_host_function_op = create_host_function_op(contract_id, function_name, function_args)

      invoke_host_function_op
      |> RPCCalls.simulate(source_account, sequence_number)
      |> RPCCalls.send_transaction(
        source_account,
        sequence_number,
        signature,
        invoke_host_function_op,
        auth_account
      )
    end
  end

  @spec create_host_function_op(
          contract_id :: contract_id(),
          function_name :: function_name(),
          function_args :: function_args()
        ) :: invoke_host_function()
  defp create_host_function_op(contract_id, function_name, function_args) do
    function =
      HostFunction.new(
        type: :invoke,
        contract_id: contract_id,
        function_name: function_name,
        args: function_args
      )

    InvokeHostFunction.new(function: function)
  end

  @spec convert_to_sc_val(function_args :: function_args()) :: {:ok, sc_val_list()}
  defp convert_to_sc_val(function_args) do
    sc_vals = Enum.map(function_args, fn %{__struct__: struct} = arg -> struct.to_sc_val(arg) end)
    {:ok, sc_vals}
  end
end
