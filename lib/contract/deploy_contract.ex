defmodule Soroban.Contract.DeployContract do
  @moduledoc """
  `DeployContract` implementation to deploy contract from a wasm file.
  """
  alias Soroban.RPC.{GetTransactionResponse, SendTransactionResponse}
  alias Stellar.Horizon.Accounts

  alias Stellar.TxBuild.{
    Account,
    HostFunction,
    InvokeHostFunction,
    SequenceNumber,
    Signature
  }

  alias Soroban.Contract.RPCCalls
  alias StellarBase.XDR.TransactionResult

  @type wasm_id :: binary()
  @type invoke_host_function :: InvokeHostFunction.t()
  @type account :: Account.t()
  @type get_response :: {:ok, GetTransactionResponse.t()}
  @type send_response :: {:ok, SendTransactionResponse.t()}
  @type signature :: Signature.t()
  @type sequence_number :: SequenceNumber.t()

  @spec deploy(wasm_id :: wasm_id(), secret_key :: binary()) :: send_response()
  def deploy(wasm_id, secret_key) do
    with {public_key, _secret} = keypair <- Stellar.KeyPair.from_secret_seed(secret_key),
         source_account <- Account.new(public_key),
         {:ok, seq_num} <- Accounts.fetch_next_sequence_number(public_key),
         sequence_number <- SequenceNumber.new(seq_num),
         signature <- Signature.new(keypair),
         invoke_host_function_op <- create_host_function_deploy_op(wasm_id) do
      invoke_host_function_op
      |> RPCCalls.simulate(source_account, sequence_number)
      |> RPCCalls.send_transaction(
        source_account,
        sequence_number,
        signature,
        invoke_host_function_op
      )
    end
  end

  @spec get_contract_id(get_response()) :: binary()
  def get_contract_id({:ok, %GetTransactionResponse{result_xdr: result_xdr}}) do
    {%{
       result: %{
         result: %{
           operations: [%{result: %{result: %{value: %{value: %{value: value}}}}}]
         }
       }
     }, ""} = result_xdr |> Base.decode64!() |> TransactionResult.decode_xdr!()

    Base.encode16(value, case: :lower)
  end

  @spec create_host_function_deploy_op(wasm_id :: wasm_id()) :: invoke_host_function()
  defp create_host_function_deploy_op(wasm_id) do
    function =
      HostFunction.new(
        type: :create,
        wasm_id: wasm_id
      )

    InvokeHostFunction.new(function: function)
  end
end
