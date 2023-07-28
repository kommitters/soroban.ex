defmodule Soroban.Contract.RPCCalls do
  @moduledoc """
  Exposes the functions to execute the simulate and send_transaction endpoints
  """
  alias Soroban.RPC
  alias Soroban.RPC.{SendTransactionResponse, SimulateTransactionResponse}
  alias Stellar.TxBuild
  alias StellarBase.XDR.{SorobanTransactionData, UInt32}

  alias Stellar.TxBuild.{
    Account,
    BaseFee,
    InvokeHostFunction,
    SequenceNumber,
    Signature
  }

  @type account :: Account.t()
  @type auth :: list(String.t()) | nil
  @type auth_secret_key :: String.t() | nil
  @type envelope_xdr :: String.t()
  @type invoke_host_function :: InvokeHostFunction.t()
  @type simulate_response :: {:ok, SimulateTransactionResponse.t()}
  @type send_response :: {:ok, SendTransactionResponse.t()}
  @type signature :: Signature.t()
  @type sequence_number :: SequenceNumber.t()

  @spec simulate(
          invoke_host_function_op :: invoke_host_function(),
          source_account :: account(),
          sequence_number :: sequence_number()
        ) :: simulate_response()
  def simulate(
        invoke_host_function_op,
        source_account,
        sequence_number
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
          invoke_host_function_op :: invoke_host_function()
        ) :: send_response() | simulate_response()
  def send_transaction(
        _simulate_transaction,
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
        source_account,
        sequence_number,
        signature,
        invoke_host_function_op,
        auth_secret_key
      ) do
    invoke_host_function_op =
      set_host_function_auth(invoke_host_function_op, auth, auth_secret_key)

    {transaction_data, min_resource_fee} =
      process_transaction_response(
        transaction_data,
        String.to_integer(min_resource_fee),
        auth_secret_key
      )

    %BaseFee{fee: base_fee} = BaseFee.new()
    fee = BaseFee.new(base_fee + min_resource_fee)

    {:ok, envelope_xdr} =
      source_account
      |> TxBuild.new(sequence_number: sequence_number)
      |> TxBuild.add_operation(invoke_host_function_op)
      |> Stellar.TxBuild.set_base_fee(fee)
      |> Stellar.TxBuild.set_soroban_data(transaction_data)
      |> TxBuild.sign(signature)
      |> TxBuild.envelope()

    RPC.send_transaction(envelope_xdr)
  end

  def send_transaction(
        {:ok, %SimulateTransactionResponse{}} = response,
        _source_account,
        _sequence_number,
        _signature,
        _invoke_host_function_op,
        _auth_secret_key
      ),
      do: response

  @spec retrieve_unsigned_xdr(
          simulate_response :: simulate_response(),
          source_account :: account(),
          sequence_number :: sequence_number(),
          invoke_host_function_op :: invoke_host_function()
        ) :: envelope_xdr() | simulate_response()
  def retrieve_unsigned_xdr(
        {:ok,
         %SimulateTransactionResponse{
           transaction_data: transaction_data,
           min_resource_fee: min_resource_fee,
           results: [%{auth: auth}]
         }},
        source_account,
        sequence_number,
        invoke_host_function_op
      ) do
    invoke_host_function_op = set_host_function_auth(invoke_host_function_op, auth, nil)

    {transaction_data, min_resource_fee} =
      process_transaction_response(
        transaction_data,
        String.to_integer(min_resource_fee),
        nil
      )

    %BaseFee{fee: base_fee} = BaseFee.new()
    fee = BaseFee.new(base_fee + min_resource_fee + round(min_resource_fee * 0.01))

    {:ok, envelope_xdr} =
      source_account
      |> TxBuild.new(sequence_number: sequence_number)
      |> TxBuild.add_operation(invoke_host_function_op)
      |> Stellar.TxBuild.set_base_fee(fee)
      |> Stellar.TxBuild.set_soroban_data(transaction_data)
      |> TxBuild.envelope()

    envelope_xdr
  end

  def retrieve_unsigned_xdr(
        {:ok, %SimulateTransactionResponse{}} = response,
        _source_account,
        _sequence_number,
        _invoke_host_function_op
      ),
      do: response

  @spec set_host_function_auth(
          invoke_host_function :: invoke_host_function(),
          auth :: auth(),
          auth_secret_key :: auth_secret_key()
        ) :: invoke_host_function() | {:error, atom()}
  defp set_host_function_auth(
         invoke_host_function_op,
         nil,
         _auth_secret_key
       ),
       do: invoke_host_function_op

  defp set_host_function_auth(
         %InvokeHostFunction{} = invoke_host_function_op,
         auth,
         nil
       ),
       do: InvokeHostFunction.set_auth(invoke_host_function_op, auth)

  # This function is needed since when the function invoker is not the function authorizer
  # the transaction data returns min_resource_fee and instructions with wrong values.
  # More info: https://discord.com/channels/897514728459468821/1112853306881081354
  @spec process_transaction_response(
          transaction_data :: String.t(),
          min_resource_fee :: non_neg_integer(),
          auth_secret_key :: auth_secret_key()
        ) :: {SorobanTransactionData.t(), non_neg_integer()}
  defp process_transaction_response(transaction_data, min_resource_fee, nil),
    do: {transaction_data, min_resource_fee}

  defp process_transaction_response(transaction_data, min_resource_fee, _auth_secret_key) do
    {%{
       resources: %{instructions: %{datum: datum}} = resources
     } = soroban_data,
     ""} =
      transaction_data
      |> Base.decode64!()
      |> SorobanTransactionData.decode_xdr!()

    new_instructions = UInt32.new(datum + round(datum * 0.25))
    new_resources = %{resources | instructions: new_instructions}
    soroban_data = %{soroban_data | resources: new_resources}
    min_resource_fee = min_resource_fee + round(min_resource_fee * 0.1)
    {soroban_data, min_resource_fee}
  end
end
