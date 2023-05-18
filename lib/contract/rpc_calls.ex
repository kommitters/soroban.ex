defmodule Soroban.Contract.RPCCalls do
  @moduledoc """
  Exposes the functions to execute the simulate and send_transaction endpoints
  """

  alias Soroban.RPC
  alias Soroban.RPC.{SendTransactionResponse, SimulateTransactionResponse}
  alias Stellar.TxBuild

  alias Stellar.TxBuild.{
    Account,
    ContractAuth,
    InvokeHostFunction,
    SequenceNumber,
    Signature
  }

  @type account :: Account.t()
  @type auth :: String.t() | nil
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
        {:ok, %SimulateTransactionResponse{results: [%{footprint: footprint, auth: auth}]}},
        source_account,
        sequence_number,
        signature,
        invoke_host_function_op,
        auth_secret_key
      ) do
    invoke_host_function_op =
      set_invoke_host_function_params(invoke_host_function_op, footprint, auth, auth_secret_key)

    {:ok, envelope_xdr} =
      source_account
      |> TxBuild.new(sequence_number: sequence_number)
      |> TxBuild.add_operation(invoke_host_function_op)
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
        {:ok, %SimulateTransactionResponse{results: [%{footprint: footprint, auth: auth}]}},
        source_account,
        sequence_number,
        invoke_host_function_op
      ) do
    invoke_host_function_op =
      set_invoke_host_function_params(invoke_host_function_op, footprint, auth, nil)

    {:ok, envelope_xdr} =
      source_account
      |> TxBuild.new(sequence_number: sequence_number)
      |> TxBuild.add_operation(invoke_host_function_op)
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

  @spec set_invoke_host_function_params(
          invoke_host_function :: invoke_host_function(),
          footprint :: String.t(),
          auth :: auth(),
          auth_secret_key :: auth_secret_key()
        ) :: invoke_host_function() | {:error, :required_auth}
  defp set_invoke_host_function_params(invoke_host_function_op, footprint, [auth], nil) do
    invoke_host_function_op
    |> InvokeHostFunction.set_footprint(footprint)
    |> InvokeHostFunction.set_contract_auth(auth)
  end

  defp set_invoke_host_function_params(
         invoke_host_function_op,
         footprint,
         [auth],
         auth_secret_key
       ) do
    authorization = ContractAuth.sign_xdr(auth, auth_secret_key)

    invoke_host_function_op
    |> InvokeHostFunction.set_footprint(footprint)
    |> InvokeHostFunction.set_contract_auth(authorization)
  end

  defp set_invoke_host_function_params(invoke_host_function_op, footprint, nil, _auth_secret_key),
    do: InvokeHostFunction.set_footprint(invoke_host_function_op, footprint)
end
