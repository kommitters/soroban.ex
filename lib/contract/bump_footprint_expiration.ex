defmodule Soroban.Contract.BumpFootprintExpiration do
  @moduledoc """
  `BumpFootprintExpiration` implementation to bump a contract.
  """

  alias Soroban.Contract.RPCCalls
  alias Soroban.RPC.SendTransactionResponse
  alias Stellar.Horizon.Accounts

  alias Stellar.TxBuild.{
    Account,
    BumpFootprintExpiration,
    LedgerFootprint,
    LedgerKey,
    SCAddress,
    SCVal,
    SequenceNumber,
    Signature,
    SorobanResources,
    SorobanTransactionData
  }

  @type durability :: :persistent | :temporary
  @type data_key :: String.t()
  @type keys :: list({durability(), data_key()})
  @type error :: {:error, atom()}
  @type contract_address :: String.t()
  @type contract_hash :: String.t()
  @type secret_key :: String.t()
  @type ledgers_to_bump :: non_neg_integer()
  @type send_response :: {:ok, SendTransactionResponse.t()}
  @type bump_footprint_validation :: {:ok, BumpFootprintExpiration.t()} | error()
  @type soroban_data :: SorobanTransactionData.t()

  @spec bump_contract(
          contract_address :: contract_address(),
          secret_key :: secret_key(),
          ledgers_to_bump :: ledgers_to_bump()
        ) :: send_response()
  def bump_contract(contract_address, secret_key, ledgers_to_bump) do
    with {public_key, _secret} = keypair <- Stellar.KeyPair.from_secret_seed(secret_key),
         {:ok, seq_num} <- Accounts.fetch_next_sequence_number(public_key),
         {:ok, bump_footprint_op} <- create_bump_footprint_op(ledgers_to_bump),
         %SequenceNumber{} = sequence_number <- SequenceNumber.new(seq_num),
         %SorobanTransactionData{} = soroban_data <- create_soroban_data(contract_address),
         %Account{} = source_account <- Account.new(public_key),
         %Signature{} = signature <- Signature.new(keypair) do
      bump_footprint_op
      |> RPCCalls.simulate(source_account, sequence_number, soroban_data)
      |> RPCCalls.send_transaction(
        source_account,
        sequence_number,
        signature,
        bump_footprint_op
      )
    end
  end

  @spec bump_contract_wasm(
          contract_hash :: contract_hash(),
          secret_key :: secret_key(),
          ledgers_to_bump :: ledgers_to_bump()
        ) :: send_response()
  def bump_contract_wasm(contract_hash, secret_key, ledgers_to_bump) do
    with {public_key, _secret} = keypair <- Stellar.KeyPair.from_secret_seed(secret_key),
         {:ok, seq_num} <- Accounts.fetch_next_sequence_number(public_key),
         {:ok, bump_footprint_op} <- create_bump_footprint_op(ledgers_to_bump),
         %SequenceNumber{} = sequence_number <- SequenceNumber.new(seq_num),
         %SorobanTransactionData{} = soroban_data <- create_wasm_soroban_data(contract_hash),
         %Account{} = source_account <- Account.new(public_key),
         %Signature{} = signature <- Signature.new(keypair) do
      bump_footprint_op
      |> RPCCalls.simulate(source_account, sequence_number, soroban_data)
      |> RPCCalls.send_transaction(
        source_account,
        sequence_number,
        signature,
        bump_footprint_op
      )
    end
  end

  @spec bump_contract_keys(
          contract_address :: contract_address(),
          secret_key :: secret_key(),
          ledgers_to_bump :: ledgers_to_bump(),
          keys :: keys()
        ) :: send_response()
  def bump_contract_keys(contract_address, secret_key, ledgers_to_bump, keys) do
    with {public_key, _secret} = keypair <- Stellar.KeyPair.from_secret_seed(secret_key),
         {:ok, seq_num} <- Accounts.fetch_next_sequence_number(public_key),
         {:ok, bump_footprint_op} <- create_bump_footprint_op(ledgers_to_bump),
         %SequenceNumber{} = sequence_number <- SequenceNumber.new(seq_num),
         %SorobanTransactionData{} = soroban_data <- create_soroban_data(contract_address, keys),
         %Account{} = source_account <- Account.new(public_key),
         %Signature{} = signature <- Signature.new(keypair) do
      bump_footprint_op
      |> RPCCalls.simulate(source_account, sequence_number, soroban_data)
      |> RPCCalls.send_transaction(
        source_account,
        sequence_number,
        signature,
        bump_footprint_op
      )
    end
  end

  @spec create_soroban_data(contract_address :: contract_address()) :: soroban_data()
  defp create_soroban_data(contract_address, keys \\ []) do
    with %SCAddress{} = contract_sc_address <- SCAddress.new(contract_address),
         [%LedgerKey{} | _] = contract_data <- create_keys(contract_sc_address, keys),
         %LedgerFootprint{} = footprint <- LedgerFootprint.new(read_only: contract_data) do
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

  @spec create_wasm_soroban_data(contract_hash :: contract_hash()) :: soroban_data() | error()
  defp create_wasm_soroban_data(contract_hash) do
    hash = Base.decode16!(contract_hash, case: :lower)
    contract_code = LedgerKey.new({:contract_code, [hash: hash, body_type: :data_entry]})

    footprint = LedgerFootprint.new(read_only: [contract_code])

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

  @spec create_bump_footprint_op(ledgers_to_bump :: ledgers_to_bump()) ::
          bump_footprint_validation()
  defp create_bump_footprint_op(ledgers_to_bump)
       when is_integer(ledgers_to_bump) and ledgers_to_bump > 0,
       do: {:ok, BumpFootprintExpiration.new(ledgers_to_expire: ledgers_to_bump)}

  defp create_bump_footprint_op(_ledgers_to_bump), do: {:error, :invalid_ledger_to_bump}

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

  defp create_keys(contract_sc_address, keys) when is_list(keys) do
    Enum.map(keys, fn {durability, value} ->
      data_key = SCVal.new(symbol: value)
      key = SCVal.new(vec: [data_key])

      LedgerKey.new(
        {:contract_data,
         [
           contract: contract_sc_address,
           key: key,
           durability: durability,
           body_type: :data_entry
         ]}
      )
    end)
  end

  defp create_keys(_contract_sc_address, _keys), do: {:error, :invalid_keys}
end
