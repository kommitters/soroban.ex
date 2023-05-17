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
  @type auth_account :: String.t() | nil
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
        auth_account \\ nil
      )

  def send_transaction(
        {:ok, %SimulateTransactionResponse{results: [%{footprint: footprint, auth: auth}]}},
        source_account,
        sequence_number,
        signature,
        invoke_host_function_op,
        auth_account
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

  def send_transaction(
        {:ok, %SimulateTransactionResponse{}} = response,
        _source_account,
        _sequence_number,
        _signature,
        _invoke_host_function_op,
        _auth_account
      ),
      do: response

  @spec retrieve_xdr_to_sign(
          simulate_response :: simulate_response(),
          source_account :: account(),
          sequence_number :: sequence_number(),
          invoke_host_function_op :: invoke_host_function()
        ) :: envelope_xdr() | simulate_response()
  def retrieve_xdr_to_sign(
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

  def retrieve_xdr_to_sign(
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
end
