defmodule Soroban.Contract.RestoreFootprint do
  @moduledoc """
  `RestoreFootprint` implementation to bump a contract.
  """

  alias Soroban.Contract.RPCCalls
  alias Soroban.RPC.SendTransactionResponse
  alias Stellar.Horizon.Accounts

  alias Stellar.TxBuild.{
    Account,
    LedgerFootprint,
    LedgerKey,
    RestoreFootprint,
    SCAddress,
    SCVal,
    SequenceNumber,
    Signature,
    SorobanResources,
    SorobanTransactionData
  }

  @type keys :: Keyword.t()
  @type error :: {:error, atom()}
  @type contract_address :: String.t()
  @type wasm_id :: String.t()
  @type secret_key :: String.t()
  @type send_response :: {:ok, SendTransactionResponse.t()}
  @type restore_footprint_validation :: {:ok, RestoreFootprint.t()} | error()
  @type soroban_data :: SorobanTransactionData.t()

  @spec restore_contract(
          contract_address :: contract_address(),
          secret_key :: secret_key()
        ) :: send_response()
  def restore_contract(contract_address, secret_key) do
    with {public_key, _secret} = keypair <- Stellar.KeyPair.from_secret_seed(secret_key),
         {:ok, seq_num} <- Accounts.fetch_next_sequence_number(public_key),
         {:ok, restore_footprint_op} <- create_restore_footprint_op(),
         %SequenceNumber{} = sequence_number <- SequenceNumber.new(seq_num),
         %SorobanTransactionData{} = soroban_data <- create_soroban_data(contract_address),
         %Account{} = source_account <- Account.new(public_key),
         %Signature{} = signature <- Signature.new(keypair) do
      restore_footprint_op
      |> RPCCalls.simulate(source_account, sequence_number, soroban_data)
      |> RPCCalls.send_transaction(
        source_account,
        sequence_number,
        signature,
        restore_footprint_op
      )
    end
  end

  @spec restore_contract_wasm(
          wasm_id :: wasm_id(),
          secret_key :: secret_key()
        ) :: send_response()
  def restore_contract_wasm(wasm_id, secret_key) do
    with {public_key, _secret} = keypair <- Stellar.KeyPair.from_secret_seed(secret_key),
         {:ok, seq_num} <- Accounts.fetch_next_sequence_number(public_key),
         {:ok, restore_footprint_op} <- create_restore_footprint_op(),
         %SequenceNumber{} = sequence_number <- SequenceNumber.new(seq_num),
         %SorobanTransactionData{} = soroban_data <- create_wasm_soroban_data(wasm_id),
         %Account{} = source_account <- Account.new(public_key),
         %Signature{} = signature <- Signature.new(keypair) do
      restore_footprint_op
      |> RPCCalls.simulate(source_account, sequence_number, soroban_data)
      |> RPCCalls.send_transaction(
        source_account,
        sequence_number,
        signature,
        restore_footprint_op
      )
    end
  end

  @spec restore_contract_keys(
          contract_address :: contract_address(),
          secret_key :: secret_key(),
          keys :: keys()
        ) :: send_response()
  def restore_contract_keys(contract_address, secret_key, keys) do
    with {public_key, _secret} = keypair <- Stellar.KeyPair.from_secret_seed(secret_key),
         {:ok, seq_num} <- Accounts.fetch_next_sequence_number(public_key),
         {:ok, restore_footprint_op} <- create_restore_footprint_op(),
         %SequenceNumber{} = sequence_number <- SequenceNumber.new(seq_num),
         %SorobanTransactionData{} = soroban_data <- create_soroban_data(contract_address, keys),
         %Account{} = source_account <- Account.new(public_key),
         %Signature{} = signature <- Signature.new(keypair) do
      restore_footprint_op
      |> RPCCalls.simulate(source_account, sequence_number, soroban_data)
      |> RPCCalls.send_transaction(
        source_account,
        sequence_number,
        signature,
        restore_footprint_op
      )
    end
  end

  @spec create_soroban_data(contract_address :: contract_address(), keys :: keys()) ::
          soroban_data()
  defp create_soroban_data(contract_address, keys \\ []) do
    with %SCAddress{} = contract_sc_address <- SCAddress.new(contract_address),
         [%LedgerKey{} | _] = contract_data <- create_keys(contract_sc_address, keys),
         %LedgerFootprint{} = footprint <- LedgerFootprint.new(read_write: contract_data) do
      [
        footprint: footprint,
        instructions: 0,
        read_bytes: 0,
        write_bytes: 0,
        extended_meta_data_size_bytes: 0
      ]
      |> SorobanResources.new()
      |> (&SorobanTransactionData.new(resources: &1, refundable_fee: 0)).()
    end
  end

  @spec create_wasm_soroban_data(wasm_id :: wasm_id()) :: soroban_data()
  defp create_wasm_soroban_data(wasm_id) do
    hash = Base.decode16!(wasm_id, case: :lower)
    contract_code = LedgerKey.new({:contract_code, [hash: hash, body_type: :data_entry]})

    footprint = LedgerFootprint.new(read_write: [contract_code])

    [
      footprint: footprint,
      instructions: 0,
      read_bytes: 0,
      write_bytes: 0,
      extended_meta_data_size_bytes: 0
    ]
    |> SorobanResources.new()
    |> (&SorobanTransactionData.new(resources: &1, refundable_fee: 0)).()
  end

  @spec create_restore_footprint_op() :: restore_footprint_validation()
  defp create_restore_footprint_op, do: {:ok, RestoreFootprint.new()}

  @spec create_keys(contract_address :: SCAddress.t(), keys :: keys()) ::
          list(LedgerKey.t()) | error()
  defp create_keys(contract_sc_address, []) do
    key = SCVal.new(ledger_key_contract_instance: nil)

    [
      LedgerKey.new(
        {:contract_data,
         [
           contract: contract_sc_address,
           key: key,
           durability: :persistent,
           body_type: :data_entry
         ]}
      )
    ]
  end

  defp create_keys(contract_sc_address, [{:persistent, values}]) do
    Enum.map(values, fn value ->
      data_key = SCVal.new(symbol: value)
      key = SCVal.new(vec: [data_key])

      LedgerKey.new(
        {:contract_data,
         [
           contract: contract_sc_address,
           key: key,
           durability: :persistent,
           body_type: :data_entry
         ]}
      )
    end)
  end

  defp create_keys(_contract_sc_address, _keys), do: {:error, :invalid_keys}
end
