defmodule Soroban.Contract.UploadContractCode do
  @moduledoc """
  `UploadContractCode` implementation to upload contract from a wasm file.
  """
  alias Soroban.RPC.{GetTransactionResponse, SendTransactionResponse}
  alias Stellar.Horizon.Accounts

  alias Stellar.TxBuild.{
    Account,
    HostFunction,
    HostFunctionArgs,
    InvokeHostFunction,
    SequenceNumber,
    Signature
  }

  alias Soroban.Contract.RPCCalls
  alias StellarBase.XDR.TransactionResult

  @type wasm :: binary()
  @type envelope_xdr :: String.t()
  @type invoke_host_function :: InvokeHostFunction.t()
  @type account :: Account.t()
  @type get_response :: {:ok, GetTransactionResponse.t()}
  @type send_response :: {:ok, SendTransactionResponse.t()}
  @type sequence_number :: SequenceNumber.t()
  @type signature :: Signature.t()

  @spec upload(wasm :: wasm(), secret_key :: binary()) :: send_response()
  def upload(wasm, secret_key) do
    with {public_key, _secret} = keypair <- Stellar.KeyPair.from_secret_seed(secret_key),
         {:ok, seq_num} <- Accounts.fetch_next_sequence_number(public_key),
         %Account{} = source_account <- Account.new(public_key),
         %SequenceNumber{} = sequence_number <- SequenceNumber.new(seq_num),
         %Signature{} = signature <- Signature.new(keypair),
         %InvokeHostFunction{} = invoke_host_function_op <- create_host_function_upload_op(wasm) do
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

  @spec retrieve_unsigned_xdr_to_upload(
          wasm :: wasm(),
          source_public_key :: binary()
        ) :: envelope_xdr()
  def retrieve_unsigned_xdr_to_upload(wasm, source_public_key) do
    with {:ok, seq_num} <- Accounts.fetch_next_sequence_number(source_public_key),
         %Account{} = source_account <- Account.new(source_public_key),
         %SequenceNumber{} = sequence_number <- SequenceNumber.new(seq_num),
         %InvokeHostFunction{} = invoke_host_function_op <- create_host_function_upload_op(wasm) do
      invoke_host_function_op
      |> RPCCalls.simulate(source_account, sequence_number)
      |> RPCCalls.retrieve_unsigned_xdr(source_account, sequence_number, invoke_host_function_op)
    end
  end

  @spec get_wasm_id(get_response()) :: binary()
  def get_wasm_id({:ok, %GetTransactionResponse{result_xdr: result_xdr}}) do
    {%{
       result: %{
         value: %{
           operations: [%{result: %{result: %{value: %{items: [%{value: %{value: value}}]}}}}]
         }
       }
     }, ""} = result_xdr |> Base.decode64!() |> TransactionResult.decode_xdr!()

    value
  end

  @spec create_host_function_upload_op(code :: wasm()) :: invoke_host_function()
  defp create_host_function_upload_op(code) do
    function_args =
      HostFunctionArgs.new(
        type: :upload,
        code: code
      )

    function = HostFunction.new(args: function_args)

    InvokeHostFunction.new(functions: [function])
  end
end
