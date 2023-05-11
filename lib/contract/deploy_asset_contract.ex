defmodule Soroban.Contract.DeployAssetContract do
  @moduledoc """
  `DeployAssetContract` implementation to deploy contract from an Asset.
  """
  alias Soroban.RPC.{GetTransactionResponse, SendTransactionResponse}
  alias Stellar.Horizon.Accounts

  alias Stellar.TxBuild.{
    Account,
    Asset,
    HostFunction,
    InvokeHostFunction,
    SequenceNumber,
    Signature
  }

  alias Soroban.Contract.RPCCalls
  alias StellarBase.XDR.TransactionResult

  @type asset :: Asset.t()
  @type code :: atom()
  @type invoke_host_function :: InvokeHostFunction.t()
  @type secret_key :: binary()
  @type send_response :: {:ok, SendTransactionResponse.t()}
  @type transaction_response :: {:ok, GetTransactionResponse.t()}

  @spec deploy(code :: code(), secret_key :: secret_key()) :: send_response()
  def deploy(code, secret_key) do
    with {public_key, _secret} = keypair <- Stellar.KeyPair.from_secret_seed(secret_key),
         source_account <- Account.new(public_key),
         {:ok, seq_num} <- Accounts.fetch_next_sequence_number(public_key),
         sequence_number <- SequenceNumber.new(seq_num),
         signature <- Signature.new(keypair),
         asset <- Asset.new(code: code, issuer: public_key),
         invoke_host_function_op <- create_host_function_deploy_op(asset) do
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

  @spec get_contract_id(transaction_response :: transaction_response()) :: binary()
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

  @spec create_host_function_deploy_op(asset :: asset()) :: invoke_host_function()
  defp create_host_function_deploy_op(asset) do
    function =
      HostFunction.new(
        type: :create,
        asset: asset
      )

    InvokeHostFunction.new(function: function)
  end
end
