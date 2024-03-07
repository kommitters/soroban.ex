defmodule Soroban.Contract.UploadContractCode do
  @moduledoc """
  `UploadContractCode` implementation to upload contract from a wasm file.
  """

  alias Soroban.RPC
  alias Soroban.RPC.{SendTransactionResponse, Server}

  alias Stellar.TxBuild.{
    Account,
    HostFunction,
    InvokeHostFunction,
    SequenceNumber,
    Signature
  }

  alias Soroban.Contract.RPCCalls

  @type server :: Server.t()
  @type network_passphrase :: String.t()
  @type wasm :: binary()
  @type envelope_xdr :: String.t()
  @type invoke_host_function :: InvokeHostFunction.t()
  @type account :: Account.t()
  @type send_response :: {:ok, SendTransactionResponse.t()}
  @type sequence_number :: SequenceNumber.t()
  @type signature :: Signature.t()
  @type addl_resources :: keyword()

  @spec upload(
          server :: server(),
          network_passphrase :: network_passphrase(),
          wasm :: wasm(),
          secret_key :: binary(),
          addl_resources :: addl_resources()
        ) :: send_response()
  def upload(%Server{} = server, network_passphrase, wasm, secret_key, addl_resources \\ []) do
    with {public_key, _secret} = keypair <- Stellar.KeyPair.from_secret_seed(secret_key),
         {:ok, seq_num} <- RPC.fetch_next_sequence_number(server, public_key),
         %Account{} = source_account <- Account.new(public_key),
         %SequenceNumber{} = sequence_number <- SequenceNumber.new(seq_num),
         %Signature{} = signature <- Signature.new(keypair),
         %InvokeHostFunction{} = invoke_host_function_op <- create_host_function_upload_op(wasm) do
      invoke_host_function_op
      |> RPCCalls.simulate(
        server,
        network_passphrase,
        source_account,
        sequence_number,
        addl_resources
      )
      |> RPCCalls.send_transaction(
        server,
        network_passphrase,
        source_account,
        sequence_number,
        signature,
        invoke_host_function_op
      )
    end
  end

  @spec retrieve_unsigned_xdr_to_upload(
          server :: server(),
          network_passphrase :: network_passphrase(),
          wasm :: wasm(),
          source_public_key :: binary(),
          addl_resources :: addl_resources()
        ) :: envelope_xdr()
  def retrieve_unsigned_xdr_to_upload(
        %Server{} = server,
        network_passphrase,
        wasm,
        source_public_key,
        addl_resources \\ []
      ) do
    with {:ok, seq_num} <- RPC.fetch_next_sequence_number(server, source_public_key),
         %Account{} = source_account <- Account.new(source_public_key),
         %SequenceNumber{} = sequence_number <- SequenceNumber.new(seq_num),
         %InvokeHostFunction{} = invoke_host_function_op <- create_host_function_upload_op(wasm) do
      invoke_host_function_op
      |> RPCCalls.simulate(
        server,
        network_passphrase,
        source_account,
        sequence_number,
        addl_resources
      )
      |> RPCCalls.retrieve_unsigned_xdr(
        server,
        network_passphrase,
        source_account,
        sequence_number,
        invoke_host_function_op
      )
    end
  end

  @spec create_host_function_upload_op(code :: wasm()) :: invoke_host_function()
  defp create_host_function_upload_op(code) do
    host_function = HostFunction.new(upload_contract_wasm: code)
    InvokeHostFunction.new(host_function: host_function)
  end
end
