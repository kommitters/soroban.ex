defmodule Soroban.Contract.RPCCalls do
  @moduledoc """
  Exposes the functions to execute the simulate and send_transaction endpoints
  """
  alias Soroban.RPC

  alias Soroban.RPC.{
    GetLatestLedgerResponse,
    SendTransactionResponse,
    Server,
    SimulateTransactionResponse
  }

  alias Stellar.TxBuild
  alias Stellar.TxBuild.{ExtendFootprintTTL, RestoreFootprint}
  alias Stellar.TxBuild.SorobanTransactionData, as: TxSorobanTransactionData

  alias Stellar.TxBuild.{
    Account,
    BaseFee,
    InvokeHostFunction,
    SequenceNumber,
    Signature,
    SorobanAuthorizationEntry
  }

  @type server :: Server.t()
  @type network_passphrase :: String.t()
  @type validation :: {:ok, any()}
  @type account :: Account.t()
  @type auths :: list(String.t()) | nil
  @type auth_secret_key :: String.t() | list() | nil
  @type envelope_xdr :: String.t()
  @type footprint_operations :: ExtendFootprintTTL.t() | RestoreFootprint.t()
  @type operation :: InvokeHostFunction.t() | footprint_operations()
  @type simulate_response :: {:ok, SimulateTransactionResponse.t()}
  @type send_response :: {:ok, SendTransactionResponse.t()}
  @type signature :: Signature.t()
  @type sequence_number :: SequenceNumber.t()

  @spec simulate(
          operation :: operation(),
          server :: server(),
          network_passphrase :: network_passphrase(),
          source_account :: account(),
          sequence_number :: sequence_number()
        ) :: simulate_response()
  def simulate(
        _operation,
        _server,
        _network_passphrase,
        _source_account,
        _sequence_number,
        addl_resources \\ [],
        soroban_data \\ nil
      )

  def simulate(
        operation,
        server,
        network_passphrase,
        source_account,
        sequence_number,
        addl_resources,
        nil
      ) do
    {:ok, envelope_xdr} =
      source_account
      |> TxBuild.new()
      |> TxBuild.set_network_passphrase(network_passphrase)
      |> TxBuild.set_sequence_number(sequence_number)
      |> TxBuild.add_operation(operation)
      |> TxBuild.envelope()

    RPC.simulate_transaction(server, envelope_xdr, addl_resources)
  end

  def simulate(
        operation,
        server,
        network_passphrase,
        source_account,
        sequence_number,
        addl_resources,
        soroban_data
      ) do
    soroban_data = TxSorobanTransactionData.to_xdr(soroban_data)

    {:ok, envelope_xdr} =
      source_account
      |> TxBuild.new()
      |> TxBuild.set_network_passphrase(network_passphrase)
      |> TxBuild.set_sequence_number(sequence_number)
      |> TxBuild.add_operation(operation)
      |> TxBuild.set_soroban_data(soroban_data)
      |> TxBuild.envelope()

    RPC.simulate_transaction(server, envelope_xdr, addl_resources)
  end

  @spec send_transaction(
          simulate_response :: simulate_response(),
          server :: server(),
          network_passphrase :: network_passphrase(),
          source_account :: account(),
          sequence_number :: sequence_number(),
          signature :: signature(),
          operation :: operation(),
          auth_secret_key :: auth_secret_key()
        ) :: send_response() | simulate_response()
  def send_transaction(
        _simulate_transaction,
        _server,
        _network_passphrase,
        _source_account,
        _sequence_number,
        _signature,
        _invoke_host_function_op,
        auth_secret_key \\ nil
      )

  def send_transaction(
        {:ok,
         %SimulateTransactionResponse{
           transaction_data: transaction_data,
           min_resource_fee: min_resource_fee,
           results: [%{auth: auth}]
         }},
        server,
        network_passphrase,
        source_account,
        sequence_number,
        signature,
        %InvokeHostFunction{} = operation,
        auth_secret_keys
      ) do
    with %InvokeHostFunction{} = invoke_host_function_op <-
           set_host_function_auth(server, network_passphrase, operation, auth, auth_secret_keys) do
      %BaseFee{fee: base_fee} = BaseFee.new()
      fee = BaseFee.new(base_fee + min_resource_fee)

      {:ok, envelope_xdr} =
        source_account
        |> TxBuild.new()
        |> TxBuild.set_network_passphrase(network_passphrase)
        |> TxBuild.set_sequence_number(sequence_number)
        |> TxBuild.add_operation(invoke_host_function_op)
        |> TxBuild.set_base_fee(fee)
        |> TxBuild.set_soroban_data(transaction_data)
        |> TxBuild.sign(signature)
        |> TxBuild.envelope()

      RPC.send_transaction(server, envelope_xdr)
    end
  end

  def send_transaction(
        {:ok,
         %SimulateTransactionResponse{
           transaction_data: transaction_data,
           min_resource_fee: min_resource_fee,
           results: results
         }},
        server,
        network_passphrase,
        source_account,
        sequence_number,
        signature,
        operation,
        _auth_secret_keys
      )
      when is_nil(results) and is_binary(transaction_data) do
    with {:ok, operation} <- validate_operation(operation) do
      %BaseFee{fee: base_fee} = BaseFee.new()
      fee = BaseFee.new(base_fee + min_resource_fee)

      {:ok, envelope_xdr} =
        source_account
        |> TxBuild.new()
        |> TxBuild.set_network_passphrase(network_passphrase)
        |> TxBuild.set_sequence_number(sequence_number)
        |> TxBuild.add_operation(operation)
        |> TxBuild.set_base_fee(fee)
        |> TxBuild.set_soroban_data(transaction_data)
        |> TxBuild.sign(signature)
        |> TxBuild.envelope()

      RPC.send_transaction(server, envelope_xdr)
    end
  end

  def send_transaction(
        {:ok, %SimulateTransactionResponse{}} = response,
        _server,
        _network_passphrase,
        _source_account,
        _sequence_number,
        _signature,
        _invoke_host_function_op,
        _auth_secret_key
      ),
      do: response

  @spec retrieve_unsigned_xdr(
          simulate_response :: simulate_response(),
          server :: server(),
          network_passphrase :: network_passphrase(),
          source_account :: account(),
          sequence_number :: sequence_number(),
          invoke_host_function_op :: operation()
        ) :: envelope_xdr() | simulate_response()
  def retrieve_unsigned_xdr(
        _simulate_response,
        _server,
        _network_passphrase,
        _source_account,
        _sequence_number,
        _invoke_host_function_op
      )

  def retrieve_unsigned_xdr(
        {:ok,
         %SimulateTransactionResponse{
           transaction_data: transaction_data,
           min_resource_fee: min_resource_fee,
           results: [%{auth: auth}]
         }},
        server,
        network_passphrase,
        source_account,
        sequence_number,
        invoke_host_function_op
      ) do
    invoke_host_function_op =
      set_host_function_auth(server, network_passphrase, invoke_host_function_op, auth, [])

    %BaseFee{fee: base_fee} = BaseFee.new()
    fee = BaseFee.new(base_fee + min_resource_fee)

    {:ok, envelope_xdr} =
      source_account
      |> TxBuild.new()
      |> TxBuild.set_network_passphrase(network_passphrase)
      |> TxBuild.set_sequence_number(sequence_number)
      |> TxBuild.add_operation(invoke_host_function_op)
      |> TxBuild.set_base_fee(fee)
      |> TxBuild.set_soroban_data(transaction_data)
      |> TxBuild.envelope()

    envelope_xdr
  end

  def retrieve_unsigned_xdr(
        {:ok, %SimulateTransactionResponse{}} = response,
        _server,
        _network_passphrase,
        _source_account,
        _sequence_number,
        _invoke_host_function_op
      ),
      do: response

  @spec set_host_function_auth(
          server :: server(),
          network_passphrase :: network_passphrase(),
          invoke_host_function :: operation(),
          auths :: auths(),
          auth_secret_key :: auth_secret_key()
        ) :: operation() | {:error, atom()}
  defp set_host_function_auth(
         _server,
         _network_passphrase,
         invoke_host_function_op,
         nil,
         _auth_secret_key
       ),
       do: invoke_host_function_op

  defp set_host_function_auth(
         _server,
         _network_passphrase,
         %InvokeHostFunction{} = invoke_host_function_op,
         auths,
         []
       ),
       do: InvokeHostFunction.set_auth(invoke_host_function_op, auths)

  defp set_host_function_auth(
         _server,
         _network_passphrase,
         %InvokeHostFunction{} = invoke_host_function_op,
         auths,
         nil
       ),
       do: InvokeHostFunction.set_auth(invoke_host_function_op, auths)

  defp set_host_function_auth(
         server,
         network_passphrase,
         %InvokeHostFunction{} = invoke_host_function_op,
         auths,
         auth_secret_keys
       )
       when length(auths) == length(auth_secret_keys) do
    {:ok, %GetLatestLedgerResponse{sequence: latest_ledger}} = RPC.get_latest_ledger(server)

    authorizations =
      auth_secret_keys
      |> Enum.zip(auths)
      |> Enum.map(fn {auth_secret_key, auth} ->
        SorobanAuthorizationEntry.sign_xdr(
          auth,
          auth_secret_key,
          latest_ledger,
          network_passphrase
        )
      end)

    InvokeHostFunction.set_auth(invoke_host_function_op, authorizations)
  end

  defp set_host_function_auth(
         _server,
         _network_passphrase,
         _invoke_host_function_op,
         _auths,
         _auth_secret_keys
       ),
       do: {:error, :invalid_auth_secret_keys_length}

  @spec validate_operation(operation :: footprint_operations()) :: validation()
  defp validate_operation(%ExtendFootprintTTL{} = operation), do: {:ok, operation}
  defp validate_operation(%RestoreFootprint{} = operation), do: {:ok, operation}
end
