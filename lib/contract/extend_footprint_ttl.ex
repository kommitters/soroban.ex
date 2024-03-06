defmodule Soroban.Contract.ExtendFootprintTTL do
  @moduledoc """
  `ExtendFootprintTTL` implementation to extend a contract.
  """

  alias Soroban.Contract.RPCCalls
  alias Soroban.RPC
  alias Soroban.RPC.{SendTransactionResponse, Server}

  alias Stellar.TxBuild.{
    Account,
    ExtendFootprintTTL,
    LedgerFootprint,
    LedgerKey,
    SCAddress,
    SCVal,
    SequenceNumber,
    Signature,
    SorobanResources,
    SorobanTransactionData
  }

  @type server :: Server.t()
  @type network_passphrase :: String.t()
  @type durability :: :persistent | :temporary
  @type data_key :: String.t()
  @type keys :: list({durability(), data_key()})
  @type error :: {:error, atom()}
  @type contract_address :: String.t()
  @type wasm_id :: String.t()
  @type secret_key :: String.t()
  @type ledgers_to_extend :: non_neg_integer()
  @type send_response :: {:ok, SendTransactionResponse.t()}
  @type extend_footprint_ttl_validation :: {:ok, ExtendFootprintTTL.t()} | error()
  @type soroban_data :: SorobanTransactionData.t()
  @type addl_resources :: keyword()

  @spec extend_contract(
          server :: server(),
          network_passphrase :: network_passphrase(),
          contract_address :: contract_address(),
          secret_key :: secret_key(),
          ledgers_to_extend :: ledgers_to_extend(),
          addl_resources :: addl_resources()
        ) :: send_response()
  def extend_contract(
        %Server{} = server,
        network_passphrase,
        contract_address,
        secret_key,
        ledgers_to_extend,
        addl_resources \\ []
      ) do
    with {public_key, _secret} = keypair <- Stellar.KeyPair.from_secret_seed(secret_key),
         {:ok, seq_num} <- RPC.fetch_next_sequence_number(server, public_key),
         {:ok, extend_footprint_ttl_op} <- create_extend_footprint_ttl_op(ledgers_to_extend),
         %SequenceNumber{} = sequence_number <- SequenceNumber.new(seq_num),
         %SorobanTransactionData{} = soroban_data <- create_soroban_data(contract_address),
         %Account{} = source_account <- Account.new(public_key),
         %Signature{} = signature <- Signature.new(keypair) do
      extend_footprint_ttl_op
      |> RPCCalls.simulate(
        server,
        network_passphrase,
        source_account,
        sequence_number,
        addl_resources,
        soroban_data
      )
      |> RPCCalls.send_transaction(
        server,
        network_passphrase,
        source_account,
        sequence_number,
        signature,
        extend_footprint_ttl_op
      )
    end
  end

  @spec extend_contract_wasm(
          server :: server(),
          network_passphrase :: network_passphrase(),
          wasm_id :: wasm_id(),
          secret_key :: secret_key(),
          ledgers_to_extend :: ledgers_to_extend(),
          addl_resources :: addl_resources()
        ) :: send_response()
  def extend_contract_wasm(
        %Server{} = server,
        network_passphrase,
        wasm_id,
        secret_key,
        ledgers_to_extend,
        addl_resources \\ []
      ) do
    with {public_key, _secret} = keypair <- Stellar.KeyPair.from_secret_seed(secret_key),
         {:ok, seq_num} <- RPC.fetch_next_sequence_number(server, public_key),
         {:ok, extend_footprint_ttl_op} <- create_extend_footprint_ttl_op(ledgers_to_extend),
         %SequenceNumber{} = sequence_number <- SequenceNumber.new(seq_num),
         %SorobanTransactionData{} = soroban_data <- create_wasm_soroban_data(wasm_id),
         %Account{} = source_account <- Account.new(public_key),
         %Signature{} = signature <- Signature.new(keypair) do
      extend_footprint_ttl_op
      |> RPCCalls.simulate(
        server,
        network_passphrase,
        source_account,
        sequence_number,
        addl_resources,
        soroban_data
      )
      |> RPCCalls.send_transaction(
        server,
        network_passphrase,
        source_account,
        sequence_number,
        signature,
        extend_footprint_ttl_op
      )
    end
  end

  @spec extend_contract_keys(
          server :: server(),
          network_passphrase :: network_passphrase(),
          contract_address :: contract_address(),
          secret_key :: secret_key(),
          ledgers_to_extend :: ledgers_to_extend(),
          keys :: keys(),
          addl_resources :: addl_resources()
        ) :: send_response()
  def extend_contract_keys(
        %Server{} = server,
        network_passphrase,
        contract_address,
        secret_key,
        ledgers_to_extend,
        keys,
        addl_resources \\ []
      ) do
    with {public_key, _secret} = keypair <- Stellar.KeyPair.from_secret_seed(secret_key),
         {:ok, seq_num} <- RPC.fetch_next_sequence_number(server, public_key),
         {:ok, extend_footprint_ttl_op} <- create_extend_footprint_ttl_op(ledgers_to_extend),
         %SequenceNumber{} = sequence_number <- SequenceNumber.new(seq_num),
         %SorobanTransactionData{} = soroban_data <- create_soroban_data(contract_address, keys),
         %Account{} = source_account <- Account.new(public_key),
         %Signature{} = signature <- Signature.new(keypair) do
      extend_footprint_ttl_op
      |> RPCCalls.simulate(
        server,
        network_passphrase,
        source_account,
        sequence_number,
        addl_resources,
        soroban_data
      )
      |> RPCCalls.send_transaction(
        server,
        network_passphrase,
        source_account,
        sequence_number,
        signature,
        extend_footprint_ttl_op
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
        write_bytes: 0
      ]
      |> SorobanResources.new()
      |> (&SorobanTransactionData.new(resources: &1, resource_fee: 0)).()
    end
  end

  @spec create_wasm_soroban_data(wasm_id :: wasm_id()) :: soroban_data()
  defp create_wasm_soroban_data(wasm_id) do
    hash = Base.decode16!(wasm_id, case: :lower)
    contract_code = LedgerKey.new({:contract_code, [hash: hash]})

    footprint = LedgerFootprint.new(read_only: [contract_code])

    [
      footprint: footprint,
      instructions: 0,
      read_bytes: 0,
      write_bytes: 0
    ]
    |> SorobanResources.new()
    |> (&SorobanTransactionData.new(resources: &1, resource_fee: 0)).()
  end

  @spec create_extend_footprint_ttl_op(ledgers_to_extend :: ledgers_to_extend()) ::
          extend_footprint_ttl_validation()
  defp create_extend_footprint_ttl_op(ledgers_to_extend)
       when is_integer(ledgers_to_extend) and ledgers_to_extend > 0,
       do: {:ok, ExtendFootprintTTL.new(extend_to: ledgers_to_extend)}

  defp create_extend_footprint_ttl_op(_ledgers_to_extend), do: {:error, :invalid_ledger_to_extend}

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
           durability: :persistent
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
           durability: durability
         ]}
      )
    end)
  end

  defp create_keys(_contract_sc_address, _keys), do: {:error, :invalid_keys}
end
