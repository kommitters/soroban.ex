# Soroban.ex

![Build Badge](https://img.shields.io/github/actions/workflow/status/kommitters/soroban.ex/ci.yml?branch=main&style=for-the-badge)
[![Coverage Status](https://img.shields.io/coveralls/github/kommitters/soroban.ex?style=for-the-badge)](https://coveralls.io/github/kommitters/soroban.ex)
[![Version Badge](https://img.shields.io/hexpm/v/soroban?style=for-the-badge)](https://hexdocs.pm/soroban)
![Downloads Badge](https://img.shields.io/hexpm/dt/soroban?style=for-the-badge)
[![License badge](https://img.shields.io/hexpm/l/soroban?style=for-the-badge)](https://github.com/kommitters/soroban.ex/blob/main/LICENSE)
[![OpenSSF Scorecard](https://img.shields.io/ossf-scorecard/github.com/kommitters/soroban.ex?label=openssf%20scorecard&style=for-the-badge)](https://api.securityscorecards.dev/projects/github.com/kommitters/soroban.ex)

**Soroban.ex** is an open source library for Elixir to interact with the Soroban-RPC server, and facilitate the deployment and invocation of Soroban smart contracts.

> **Warning**
> Please note that Soroban is still under development, so breaking changes may occur.

## Installation

[**Available in Hex**][hex], add `soroban` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:soroban, "~> 0.17.0"}
  ]
end
```

## Documentation

Soroban.ex is made up of three components:

- [**`Types`**](#types): Soroban types that can be utilized as function arguments when invoking a smart contract.
- [**`RPC`**](#soroban-rpc-endpoints): Interface to interact with the Soroban-RPC server.
- [**`Contract`**](#deploy-and-invoke-soroban-smart-contracts): Deploy and invoke Soroban smart contracts with ease. No need to worry about transaction building.

### Types

The `Soroban.Types` context defines a comprehensive set of types that are crucial since they can be utilized as function arguments when invoking a smart contract.

The types provided by **Soroban.ex** aim to replicate the experience of working with types in smart contract development. They range from scalar types (such as Bool, Int32, etc.) to compound types (such as Map, Struct, Tuple, etc.).

#### Bool

```elixir
Soroban.Types.Bool.new(true)
Soroban.Types.Bool.new(false)
```

#### Integers

These types include signed integers (`Int32`, `Int64`, `Int128`, `Int256`) and unsigned integers (`UInt32`, `UInt64`, `UInt128`, `UInt256`).

```elixir
Soroban.Types.Int32.new(1)
Soroban.Types.Int64.new(1)
Soroban.Types.Int128.new(1)
Soroban.Types.Int256.new(1)

Soroban.Types.UInt32.new(1)
Soroban.Types.UInt64.new(1)
Soroban.Types.UInt128.new(1)
Soroban.Types.UInt256.new(1)
```

#### TimePoint

```elixir
Soroban.Types.TimePoint.new(12_345)
```

#### Duration

```elixir
Soroban.Types.Duration.new(12_345)
```

#### Bytes

```elixir
# From raw bytes
Soroban.Types.Bytes.new(<<1, 2, 3>>)

# From string
Soroban.Types.Bytes.new("Hello World!")
```

#### Symbol

```elixir
Soroban.Types.Symbol.new("symbol")
```

#### String

```elixir
Soroban.Types.String.new("Hello World!")
```

#### Address

```elixir
# Account address
Soroban.Types.Address.new("GB6FIXFOEK46VBDAG5USXRKKDJYFOBQZDMAPOYY6MC4KMRTSPVUH3X2A")

# Contract address
Soroban.Types.Address.new("CCEMOFO5TE7FGOAJOA3RDHPC6RW3CFXRVIGOFQPFE4ZGOKA2QEA636SN")
```

#### Option

`Option` is a type that represents an optional value. It can hold any `Soroban.Types` type.

```elixir
# When the value is not present
Soroban.Types.Option.new()

# When the value is present
100
|> Soroban.Types.UInt32.new()
|> Soroban.Types.Option.new()
```

#### Vec

`Vec` is a type that represents a vector of values. It can hold any `Soroban.Types` type as long as all the values are of the same type.

```elixir
values = [
  Soroban.Types.Symbol.new("A"),
  Soroban.Types.Symbol.new("B"),
  Soroban.Types.Symbol.new("C")
]

Soroban.Types.Vec.new(values)
```

#### Tuple

`Tuple` is a type that represents a tuple of values. It can hold any `Soroban.Types` type.

```elixir
alias Soroban.Types.{Tuple, Symbol, Int32}

values = [Symbol.new("A"), Symbol.new("B"), Int32.new(1)]

Tuple.new(values)
```

#### Map

`Map` is a type that represents a map of key-value pairs. It can hold any `Soroban.Types` type as key and value.

```elixir
alias Soroban.Types.{Map, MapEntry, Symbol, UInt32, Bool}

key1 = Symbol.new("key1")
value1 = UInt32.new(100)
entry1 = MapEntry.new({key1, value1})

key2 = Symbol.new("key2")
value2 = Bool.new(true)
entry2 = MapEntry.new({key2, value2})

Map.new([entry1, entry2])
```

#### Enum

The `Enum` type supports both unit and tuple variants. More info can be found [here](https://soroban.stellar.org/docs/learn/custom-types#enum-unit-and-tuple-variants).

```elixir
alias Soroban.Types.{Enum, UInt32}

# Unit variant
Enum.new("A")

# Tuple variant
Enum.new({"B", UInt32.new(100)})
```

#### Struct

`Struct` is a type that represents a custom struct. It can hold any `Soroban.Types` type.

```elixir
alias Soroban.Types.{Struct, StructField, UInt32, Address}

key1 = "key1"
value1 = UInt32.new(100)
field1 = StructField.new({key1, value1})

key2 = "key2"
value2 = Address.new("GB6FIXFOEK46VBDAG5USXRKKDJYFOBQZDMAPOYY6MC4KMRTSPVUH3X2A")
field2 = StructField.new({key2, value2})

Struct.new([field1, field2])
```

### Soroban RPC endpoints

Interaction with the Soroban-RPC server is done through the `Soroban.RPC` module.

Currently, `Soroban.ex` can run on `Futurenet`, `Testnet`, and `Local`, the former being the default network. To use the `Testnet` network change the :stellar_sdk setting, which will also change to the RPC endpoint that works with that network. e.g.

```elixir
config :stellar_sdk, network: :test
```

#### Simulate Transaction

Submit a trial contract invocation to get back return values, expected ledger footprint, and expected costs.

**Parameters**

- `base64_envelope`: `<xdr.TransactionEnvelope>` - The transaction to be simulated (serialized in base64).

**Example**

```elixir
base64_envelope =
  "AAAAAgAAAADWKIRtrzg/aTCtUHeZnpyYu0iNxJxcn4tr0jXG2hOIlwAAAGQABzbWAAAAAwAAAAEAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAEAAAAAAAAAGAAAAAAAAAAEAAAADQAAACC8xDySpTRgcsckFZY9QBvIP3LL70Jp0xG3cmpCvp0d/QAAAA8AAAAJaW5jcmVtZW50AAAAAAAAEwAAAAAAAAAA1iiEba84P2kwrVB3mZ6cmLtIjcScXJ+La9I1xtoTiJcAAAADAAAACgAAAAAAAAAAAAAAAQAAAAC8xDySpTRgcsckFZY9QBvIP3LL70Jp0xG3cmpCvp0d/QAAAAlpbmNyZW1lbnQAAAAAAAACAAAAEwAAAAAAAAAA1iiEba84P2kwrVB3mZ6cmLtIjcScXJ+La9I1xtoTiJcAAAADAAAACgAAAAAAAAAAAAAAAAAAAAA="

Soroban.RPC.simulate_transaction(base64_envelope)

{:ok,
 %Soroban.RPC.SimulateTransactionResponse{
   results: [
     %{
       auth: nil,
       events: nil,
       footprint:
         "AAAAAgAAAAYU0EuZrCKggMgcYHtwMuiHqnrYwhksO17kfjwJ8h2l3QAAABQAAAAHCoKrtqgxTcxBJ+F9JX+3Gvlw3NtYGwCu8hzxUsbupwIAAAAA",
       xdr: "AAAAEAAAAAEAAAACAAAADwAAAAVIZWxsbwAAAAAAAA8AAAAFd29ybGQAAAA="
     }
   ],
   cost: %{cpu_insns: "1048713", mem_bytes: "1201148"},
   latest_ledger: 45075181,
   restore_preamble: nil,
   error: nil
 }}

```

#### Send Transaction

Submit a real transaction to the Stellar network. This is the only way to make changes "on-chain".

Unlike Horizon, this does not wait for transaction completion. It simply validates and enqueues the transaction. Clients should call [Get Transaction](#get-transaction) to learn about transaction success/failure.

This supports all transactions, not only smart contract-related transactions.

**Parameters**

- `base64_envelope`: `<xdr.TransactionEnvelope>` - The signed transaction to broadcast (serialized in base64).

**Example**

```elixir
base64_envelope =
  "AAAAAgAAAADBPp7TMinJylnn+6dQXJACNc15LF+aJ2Py1BaR4P10JAAAAGQAAFBfAAAAIQAAAAEAAAAAAAAAAAAAAABkUtg3AAAAAAAAAAEAAAABAAAAAME+ntMyKcnKWef7p1BckAI1zXksX5onY/LUFpHg/XQkAAAAGAAAAAAAAAADAAAADQAAACAU0EuZrCKggMgcYHtwMuiHqnrYwhksO17kfjwJ8h2l3QAAAA8AAAAFaGVsbG8AAAAAAAAPAAAABXdvcmxkAAAAAAAAAgAAAAYU0EuZrCKggMgcYHtwMuiHqnrYwhksO17kfjwJ8h2l3QAAABQAAAAHCoKrtqgxTcxBJ+F9JX+3Gvlw3NtYGwCu8hzxUsbupwIAAAAAAAAAAAAAAAAAAAAB4P10JAAAAEDS4+hvSG1JqhOIPaGSqUerNsjhIcS+AwWhH/K8IOafcmMlZJoyZvMftV1QcdWA/LQhr2QJRTWNT6I52/eTP3IH"

Soroban.RPC.send_transaction(base64_envelope)

{:ok,
 %Soroban.RPC.SendTransactionResponse{
   status: "PENDING",
   hash: "a4721e2a61e9a6b3f54030396e41c3e352101e6cd649b4453e89fb3e827744f4",
   latest_ledger: 45075181,
   latest_ledger_close_time: "1683150612",
   error_result_xdr: nil
 }}
```

#### Get Transaction

Clients will poll this to tell when the transaction has been completed.

**Parameters**

- `hash`: Transaction hash to query, as a hex-encoded string.

**Example**

```elixir

hash = "a4721e2a61e9a6b3f54030396e41c3e352101e6cd649b4453e89fb3e827744f4"

Soroban.RPC.get_transaction(hash)

{:ok,
 %Soroban.RPC.GetTransactionResponse{
   status: "SUCCESS",
   latest_ledger: 45075181,
   latest_ledger_close_time: "1683151229",
   oldest_ledger: 475097,
   oldest_ledger_close_time: "1683143656",
   application_order: 1,
   envelope_xdr:
     "AAAAAgAAAADBPp7TMinJylnn+6dQXJACNc15LF+aJ2Py1BaR4P10JAAAAGQAAFBfAAAAIQAAAAEAAAAAAAAAAAAAAABkUtg3AAAAAAAAAAEAAAABAAAAAME+ntMyKcnKWef7p1BckAI1zXksX5onY/LUFpHg/XQkAAAAGAAAAAAAAAADAAAADQAAACAU0EuZrCKggMgcYHtwMuiHqnrYwhksO17kfjwJ8h2l3QAAAA8AAAAFaGVsbG8AAAAAAAAPAAAABXdvcmxkAAAAAAAAAgAAAAYU0EuZrCKggMgcYHtwMuiHqnrYwhksO17kfjwJ8h2l3QAAABQAAAAHCoKrtqgxTcxBJ+F9JX+3Gvlw3NtYGwCu8hzxUsbupwIAAAAAAAAAAAAAAAAAAAAB4P10JAAAAEDS4+hvSG1JqhOIPaGSqUerNsjhIcS+AwWhH/K8IOafcmMlZJoyZvMftV1QcdWA/LQhr2QJRTWNT6I52/eTP3IH",
   result_xdr:
     "AAAAAAAAAGQAAAAAAAAAAQAAAAAAAAAYAAAAAAAAABAAAAABAAAAAgAAAA8AAAAFSGVsbG8AAAAAAAAPAAAABXdvcmxkAAAAAAAAAA==",
   result_meta_xdr:
     "AAAAAwAAAAIAAAADAAdFBQAAAAAAAAAAwT6e0zIpycpZ5/unUFyQAjXNeSxfmidj8tQWkeD9dCQAAAAXDNwRHAAAUF8AAAAgAAAAAAAAAAAAAAAAAAAAAAEAAAAAAAAAAAAAAQAAAAAAAAAAAAAAAAAAAAAAAAACAAAAAAAAAAAAAAAAAAAAAwAAAAAAB0J+AAAAAGRSydYAAAAAAAAAAQAHRQUAAAAAAAAAAME+ntMyKcnKWef7p1BckAI1zXksX5onY/LUFpHg/XQkAAAAFwzcERwAAFBfAAAAIQAAAAAAAAAAAAAAAAAAAAABAAAAAAAAAAAAAAEAAAAAAAAAAAAAAAAAAAAAAAAAAgAAAAAAAAAAAAAAAAAAAAMAAAAAAAdFBQAAAABkUtcZAAAAAAAAAAEAAAAAAAAAAAAAAAEAAAAAAAAAAAAAAGQAAAAAAAAAAQAAAAAAAAAYAAAAAAAAABAAAAABAAAAAgAAAA8AAAAFSGVsbG8AAAAAAAAPAAAABXdvcmxkAAAAAAAAAKQ1a84I/mDKy5j2B/YFeyfTCsTBoKJtON5QDfqS06qwy7xIdQ3ruFNQk7Per4isf0z/h0JVdqWN4rrHVKzbRhYD6NIFNZRcltVrmGLx9Y+ku182sxlHjDdsZ28pYul9HwAAAAA=",
   ledger: 476421
 }}

```

#### Get Health

General node health check.

**Example**

```elixir
Soroban.RPC.get_health()

{:ok, %Soroban.RPC.GetHealthResponse{status: "healthy"}}

```

#### Get Latest Ledger

For finding out the current latest known ledger of this node. This is a subset of the ledger info from Horizon.

**Example**

```elixir
Soroban.RPC.get_latest_ledger()

{:ok,
 %Soroban.RPC.GetLatestLedgerResponse{
   id: "2a00000000000000000000000000000000000000000000000000000000000000",
   protocol_version: 20,
   sequence: 666
 }}

```

#### Get Network

General info about the currently configured network.

**Example**

```elixir
Soroban.RPC.get_network()

{:ok,
 %Soroban.RPC.GetNetworkResponse{
   friendbot_url: "https://friendbot-futurenet.stellar.org/",
   passphrase: "Test SDF Future Network ; October 2022",
   protocol_version: "20"
 }}

```

#### Get Ledger Entries

For reading the current value of ledger entries directly.

Allows you to directly inspect the current state of a contract, a contract's code, or any other ledger entry. This is a backup way to access your contract data which may not be available via events or simulateTransaction.

**Parameters**

- `keys`: `<xdr.LedgerKey[]>` - Array containing the keys of the ledger entries you wish to retrieve (an array of serialized base64 strings).

**Example**

```elixir
keys = ["AAAABvrOGFv9hxq4ke1yjqrbfSQPrggCrdo12YvueQldm8h8AAAADwAAAAdDT1VOVEVSAA=="]

Soroban.RPC.get_ledger_entries(keys)

{:ok,
 %GetLedgerEntriesResponse{
   entries: [
     %{
       key: "AAAAB+qfy4GuVKKfazvyk4R9P9fpo2n9HICsr+xqvVcTF+DC",
       xdr: "AAAABwAAAADqn8uBrlSin2s78pOEfT/X6aNp/RyArK/sar1XExfgwgAAAAphIGNvbnRyYWN0AAA=",
       last_modified_ledger_seq: 13,
       live_until_ledger_seq: 320384
     }
   ],
   latest_ledger: 45075181
 }}

```

#### Get Events

Clients can request a filtered list of events emitted by a given ledger range.

Soroban-RPC will support querying within a maximum 24 hours of recent ledgers.

> **Note:**
> This could be used by the client to only prompt a refresh when there is a new ledger with relevant events. It should also be used by backend Dapp components to "ingest" events into their own database for querying and serving.

If making multiple requests, clients should deduplicate any events received, based on the event's unique id field. This prevents double-processing in the case of duplicate events being received.

By default soroban-rpc retains the most recent 24 hours of events.

**Parameters**

`EventsPayload`:

- `start_ledger`: Stringified ledger sequence number to fetch events after (inclusive). This method will return an error if start_ledger is less than the oldest ledger stored in this node, or greater than the latest ledger seen by this node. If a cursor is included in the request, start_ledger must be omitted.

- `cursor`: (optional) A string ID that points to a specific location in a collection of responses and is pulled from the paging_token value of a record. When a cursor is provided Soroban-RPC will not include the element whose id matches the cursor in the response. Only elements which appear after the cursor are included.
- `limit`: (optional) The maximum number of records returned. The limit for getEvents can range from 1 to 10000 - an upper limit that is hardcoded in Soroban-RPC for performance reasons. If this argument isn't designated, it defaults to 100.

- `filters`: List of `EventFilter` for the returned events. Events matching any of the filters are included. To match a filter, an event must match both a contractId and a topic. Maximum 5 filters are allowed per request.

  - `type`: (optional) A list of event types (`:system`, `:contract`, or `:diagnostic`) used to filter events. If omitted, all event types are included.
  - `contract_ids`: (optional) List of contract ids to query for events. If omitted, return events for all contracts. Maximum 5 contract IDs are allowed per request.
  - `topics`: (optional) List of `TopicFilter`. If omitted, query for all events. If multiple filters are specified, events will be included if they match any of the filters. Maximum 5 filters are allowed per request.
    - `TopicFilter`: is a SegmentMatcher[]. The list can be 1-4 SegmentMatchers long.
    - `SegmentMatcher`:
      - For an exact segment match, use Soroban.ex Types that will be converted into string base64-encoded ScVal values.
      - For a wildcard single-segment match, the string "\*", matches exactly one segment.
    - E.g: `[Symbol.new("transfer"), "*", "*", "*"]`

**Example**

```elixir
alias Soroban.RPC.{
  EventsPayload,
  EventFilter,
  TopicFilter
}

alias Soroban.Types.Symbol

limit = 1
start_ledger = "674736"
args = [Symbol.new("transfer"), "*", "*", "*"]
topic_filter = [TopicFilter.new(args)]
contract_ids = ["CCEMOFO5TE7FGOAJOA3RDHPC6RW3CFXRVIGOFQPFE4ZGOKA2QEA636SN"]

filters = [
  EventFilter.new(type: [:contract], contract_ids: contract_ids, topics: topic_filter)
]

events_payload =
  EventsPayload.new(
    start_ledger: start_ledger,
    filters: filters,
    limit: limit
  )

Soroban.RPC.get_events(events_payload)

{:ok,
 %Soroban.RPC.GetEventsResponse{
   latest_ledger: 45075181,
   events: [
     %{
       contract_id: "CCEMOFO5TE7FGOAJOA3RDHPC6RW3CFXRVIGOFQPFE4ZGOKA2QEA636SN",
       id: "0002917807507378176-0000000000",
       in_successful_contract_call: true,
       ledger: 679355,
       ledger_closed_at: "2023-05-16T06:02:47Z",
       paging_token: "0002917807507378176-0000000000",
       topic: [
         "AAAADwAAAAh0cmFuc2Zlcg==",
         "AAAAEwAAAAAAAAAAVAw2XIf/C6hPQZ2EgaY6R7RKuLfchP7836ZvBjZxdVY=",
         "AAAAEwAAAAG2UFHmWnQeBKU73RLX7AQKCktEUE/F/bKqVy+ejoC/YQ==",
         "AAAADQAAACVVU0RDOl3dfLGIo7lPPO+E0KPPSVxWCQ1qOen8umo/g+Jx8baEAAAA"
       ],
       type: "contract",
       value: "AAAACgAAAAAF9eEAAAAAAAAAAAA="
     }
   ]
 }}
```

### Deploy and Invoke Soroban smart contracts

The deployment and invocation of Soroban smart contracts is done through the `Soroban.Contract` module which provides convenient functions that streamline the process.

#### Invoke contract function

**Parameters**

- `contract_address`: Identifier of the contract to be invoked, encoded as `StrKey`.
- `source_secret_key`: Secret key of the function invoker responsible for signing the transaction.
- `function_name`: String indicating the name of the function to be invoked.
- `function_args`: List of `Soroban.Types` representing the arguments required by the indicated function (`function_name`). They should be provided in the specific order expected by the function.
- `extra_fee_rate`: Float number to increment the transaction fee to pay, useful when the operation returns an insufficient fee error.
- `auth_secret_key`: (optional) Secret key used to authorize the function invocation when the function invoker is not the same function authorizer.

##### Simple invocation - no authorization required

```elixir
alias Soroban.Contract
alias Soroban.Types.String

contract_address = "CAEYZ6JI5YV2CBI3NRRUNA2DMERJ4KLJTI76WDZBTWZ7VMPGY6JDIZD5"
source_secret_key = "SCAVFA3PI3MJLTQNMXOUNBSEUOSY66YMG3T2KCQKLQBENNVLVKNPV3EK"
extra_fee_rate = 0.08
function_name = "hello"

function_args = [String.new("world")]

Contract.invoke(contract_address, source_secret_key, function_name, function_args, extra_fee_rate)

{:ok,
  %Soroban.RPC.SendTransactionResponse{
    status: "PENDING",
    hash: "f62cb9e20c6d297316f49dca2041be4bf1af6b069c784764e51ac008b313d716",
    latest_ledger: 45075181,
    latest_ledger_close_time: "1683643419",
    error_result_xdr: nil
  }}
```

##### Invocation with required authorization

- When the function invoker authorizes the function invocation

  ```elixir
  alias Soroban.Contract
  alias Soroban.Types.{Address, UInt128}

  contract_address = "CAEYZ6JI5YV2CBI3NRRUNA2DMERJ4KLJTI76WDZBTWZ7VMPGY6JDIZD5"
  source_secret_key = "SCAVFA3PI3MJLTQNMXOUNBSEUOSY66YMG3T2KCQKLQBENNVLVKNPV3EK"
  extra_fee_rate = 0.08
  function_name = "inc"

  function_args = [
    Address.new("GDEU46HFMHBHCSFA3K336I3MJSBZCWVI3LUGSNL6AF2BW2Q2XR7NNAPM"),
    UInt128.new(2)
  ]

  Contract.invoke(contract_address, source_secret_key, function_name, function_args, extra_fee_rate)

  {:ok,
    %Soroban.RPC.SendTransactionResponse{
      status: "PENDING",
      hash: "e888193b4fed9b3ca6ad2beca3c1ed5bef3e0099e558756de85d03511cbaa00b",
      latest_ledger: 45075181,
      latest_ledger_close_time: "1683643728",
      error_result_xdr: nil
    }}
  ```

- When the function invoker is not the function authorizer.

  > **Note**
  > This operation will not succeed if one of the `auth_secret_keys` is the same as the `source_secret_key`, because the simulate_transaction will return that auth as a `SOROBAN_CREDENTIALS_SOURCE_ACCOUNT` type.

  ```elixir
  alias Soroban.Contract
  alias Soroban.Types.{Address, Int128}

  contract_address = "CAEYZ6JI5YV2CBI3NRRUNA2DMERJ4KLJTI76WDZBTWZ7VMPGY6JDIZD5"
  source_secret_key = "SDRD4CSRGPWUIPRDS5O3CJBNJME5XVGWNI677MZDD4OD2ZL2R6K5IQ24"
  extra_fee_rate = 0.1
  function_name = "swap"

  function_args = [
    Address.new("GDEU46HFMHBHCSFA3K336I3MJSBZCWVI3LUGSNL6AF2BW2Q2XR7NNAPM"),
    Address.new("GDAH3LPNC32U2HLJ4UKDSG2HSJN65XTMZKAZII4Z4NOAFFWJTI2PUN5W"),
    Int128.new(100),
    Int128.new(4500)
  ]

  auth_secret_keys = [
    "SCAVFA3PI3MJLTQNMXOUNBSEUOSY66YMG3T2KCQKLQBENNVLVKNPV3EK",
    "SDLOYUOMX67YX6NK7TZLWTGYU3V4FIEBL5RFRX36EYDZ4OM46VSJXV7C"
  ]

  Contract.invoke(
    contract_address,
    source_secret_key,
    function_name,
    function_args,
    extra_fee_rate,
    auth_secret_keys
  )

  {:ok,
    %Soroban.RPC.SendTransactionResponse{
      status: "PENDING",
      hash: "da263f59a8f8b29f415e7e26758cad6e8d88caec875112641b88757ce8e01873",
      latest_ledger: 45075181,
      latest_ledger_close_time: "1683644240",
      error_result_xdr: nil
    }}
  ```

#### Deploy contracts

##### Upload Contract Code

**Parameters**

- `wasm`: Binary of the web assembly (WASM) file resulting from building the contract.
- `secret_key`: Secret key of the function invoker responsible for signing the transaction.

```elixir
alias Soroban.Contract
alias Soroban.Contract.UploadContractCode
alias Soroban.RPC
alias Soroban.RPC.SendTransactionResponse

wasm = File.read!("../your_wasm_path/hello.wasm")
secret_key = "SCA..."

{:ok, %SendTransactionResponse{hash: hash}} = Contract.upload(wasm, secret_key)

{:ok,
  %Soroban.RPC.SendTransactionResponse{
    status: "PENDING",
    hash: "65d...",
    latest_ledger: 45075181,
    latest_ledger_close_time: "16",
    error_result_xdr: nil
  }}

```

##### Deploy Contract from WASM

**Parameters**

- `wasm_id`: Binary identification of the uploaded contract to deploy.
- `secret_key`: Secret key of the function invoker responsible for signing the transaction.

```elixir
alias Soroban.Contract
alias Soroban.RPC.SendTransactionResponse
alias Soroban.Contract.DeployContract

wasm_id = <<187, 187, 69, ...>>
secret_key = "SCA..."

{:ok, %SendTransactionResponse{hash: hash}} = Contract.deploy(wasm_id, secret_key)

{:ok,
  %Soroban.RPC.SendTransactionResponse{
    status: "PENDING",
    hash: "f95...",
    latest_ledger: 45075181,
    latest_ledger_close_time: "16",
    error_result_xdr: nil
  }}

```

##### Deploy Asset Contract

**Parameters**

- `asset_code`: String from 1 to 12 characters indicating the asset symbol.
- `asset_issuer`: Public key of the asset issuer.
- `secret_key`: Secret key of the function invoker responsible for signing the transaction.

```elixir
alias Soroban.Contract
alias Soroban.RPC.SendTransactionResponse
alias Soroban.Contract.DeployAssetContract

asset_code = "DBZ"
asset_issuer = "GBL..."
secret_key = "SCA..."

{:ok, %SendTransactionResponse{hash: hash}} = Contract.deploy_asset(asset_code, asset_issuer, secret_key)

{:ok,
%Soroban.RPC.SendTransactionResponse{
  status: "PENDING",
  hash: "b667...",
  latest_ledger: 45075181,
  latest_ledger_close_time: "16",
  error_result_xdr: nil
}}

```

#### ExtendFootprintTTL operation

##### Extend contract

Extends a contract instance lifetime.

**Parameters**

- `contract_address`: Identifier of the contract to be extended, encoded as `StrKey`.
- `source_secret_key`: Secret key of the function invoker responsible for signing the transaction.
- `ledgers_to_extend`: The number of ledgers wanted to extend the contract lifetime.

```elixir
alias Soroban.Contract
alias Soroban.RPC.SendTransactionResponse

contract_address = "CAEYZ6JI5YV2CBI3NRRUNA2DMERJ4KLJTI76WDZBTWZ7VMPGY6JDIZD5"
secret_key = "SDRD4CSRGPWUIPRDS5O3CJBNJME5XVGWNI677MZDD4OD2ZL2R6K5IQ24"
ledgers_to_extend = 100_000

{:ok, %SendTransactionResponse{hash: hash}} =
  Contract.extend_contract(contract_address, secret_key, ledgers_to_extend)

{:ok,
 %Soroban.RPC.SendTransactionResponse{
   status: "PENDING",
   hash: "2f6f...",
   latest_ledger: 45075181,
   latest_ledger_close_time: "1691441432",
   error_result_xdr: nil
}}

```

##### Extend contract wasm

Extends the lifetime of a contract's uploaded wasm code.

**Parameters**

- `wasm_id`: Binary identification of an uploaded contract.
- `source_secret_key`: Secret key of the function invoker responsible for signing the transaction.
- `ledgers_to_extend`: The number of ledgers wanted to extend the wasm lifetime.

```elixir
alias Soroban.Contract
alias Soroban.RPC.SendTransactionResponse

wasm_id = "067eb7ba419edd3e946e08eb17a81fbe1e850e690ed7692160875c2b65b45f21"
secret_key = "SDRD4CSRGPWUIPRDS5O3CJBNJME5XVGWNI677MZDD4OD2ZL2R6K5IQ24"
ledgers_to_extend = 100_000

{:ok, %SendTransactionResponse{hash: hash}} =
  Contract.extend_contract_wasm(wasm_id, secret_key, ledgers_to_extend)

{:ok,
 %Soroban.RPC.SendTransactionResponse{
   status: "PENDING",
   hash: "2f6f...",
   latest_ledger: 45075181,
   latest_ledger_close_time: "1691441432",
   error_result_xdr: nil
}}

```

##### Extend contract keys

Extends the lifetime of a contract's data entry keys.

**Parameters**

- `contract_address`: Identifier of the contract to be extended, encoded as `StrKey`.
- `source_secret_key`: Secret key of the function invoker responsible for signing the transaction.
- `ledgers_to_extend`: The number of ledgers wanted to extend the contract lifetime.
- `keys`: A list of tuples indicating the durability and the name of the data entry, to increase its lifetime.
  - `durability`: Allowed types `:persistent`, `:temporary`
  - `data entry`: Any `String` that is 32 characters or less.

```elixir
alias Soroban.Contract
alias Soroban.RPC.SendTransactionResponse

contract_address = "CAEYZ6JI5YV2CBI3NRRUNA2DMERJ4KLJTI76WDZBTWZ7VMPGY6JDIZD5"
secret_key = "SDRD4CSRGPWUIPRDS5O3CJBNJME5XVGWNI677MZDD4OD2ZL2R6K5IQ24"
ledgers_to_extend = 100_000
keys =  [{:persistent, "Prst"}, {:temporary, "Tmp"}]

{:ok, %SendTransactionResponse{hash: hash}} =
  Contract.extend_contract_keys(contract_address, secret_key, ledgers_to_extend, keys)

{:ok,
 %Soroban.RPC.SendTransactionResponse{
   status: "PENDING",
   hash: "2f6f...",
   latest_ledger: 45075181,
   latest_ledger_close_time: "1691441432",
   error_result_xdr: nil
}}

```

#### RestoreFootprint operation

##### Restore contract

Restores a contract instance.

**Parameters**

- `contract_address`: Identifier of the contract to be restored, encoded as `StrKey`.
- `source_secret_key`: Secret key of the function invoker responsible for signing the transaction.

```elixir
alias Soroban.Contract
alias Soroban.RPC.SendTransactionResponse

contract_address = "CAEYZ6JI5YV2CBI3NRRUNA2DMERJ4KLJTI76WDZBTWZ7VMPGY6JDIZD5"
secret_key = "SDRD4CSRGPWUIPRDS5O3CJBNJME5XVGWNI677MZDD4OD2ZL2R6K5IQ24"

{:ok, %SendTransactionResponse{hash: hash}} =
  Contract.restore_contract(contract_address, secret_key)

{:ok,
 %Soroban.RPC.SendTransactionResponse{
   status: "PENDING",
   hash: "eedb...",
   latest_ledger: 45075181,
   latest_ledger_close_time: "1691523150",
   error_result_xdr: nil
 }}

```

##### Restore contract wasm

Restores a contract uploaded wasm code.

> **Note**: When restoring a contract wasm make sure the contract wasn't re-uploaded, because the transaction could succeed but, since the `wasm_id` changed, the restored one will continue not working.

**Parameters**

- `wasm_id`: Binary identification of an uploaded contract.
- `source_secret_key`: Secret key of the function invoker responsible for signing the transaction.

```elixir
alias Soroban.Contract
alias Soroban.RPC.SendTransactionResponse

wasm_id = "067eb7ba419edd3e946e08eb17a81fbe1e850e690ed7692160875c2b65b45f21"
secret_key = "SDRD4CSRGPWUIPRDS5O3CJBNJME5XVGWNI677MZDD4OD2ZL2R6K5IQ24"

{:ok, %SendTransactionResponse{hash: hash}} = Contract.restore_contract_wasm(wasm_id, secret_key)

{:ok,
 %Soroban.RPC.SendTransactionResponse{
   status: "PENDING",
   hash: "eedb...",
   latest_ledger: 45075181,
   latest_ledger_close_time: "1691523689",
   error_result_xdr: nil
 }}

```

##### Restore contract keys

Restore contract's data entry keys.

> **Note**: Only `persistent` data entries are allowed because temporary entries cannot be restored as they are permanently deleted when they expire.

**Parameters**

- `contract_address`: Identifier of the contract to be restored, encoded as `StrKey`.
- `source_secret_key`: Secret key of the function invoker responsible for signing the transaction.
- `keys`: A keyword list indicating the durability and the name of the data entry, to restore.
  - `durability`: Allowed types `:persistent`
  - `data entry`: Any `String` that is 32 characters or less.

```elixir
alias Soroban.Contract
alias Soroban.RPC.SendTransactionResponse

contract_address = "CAEYZ6JI5YV2CBI3NRRUNA2DMERJ4KLJTI76WDZBTWZ7VMPGY6JDIZD5"
secret_key = "SDRD4CSRGPWUIPRDS5O3CJBNJME5XVGWNI677MZDD4OD2ZL2R6K5IQ24"
keys =  [persistent: ["Prst"]]

{:ok, %SendTransactionResponse{hash: hash}} =
  Contract.restore_contract_keys(contract_address, secret_key, keys)

{:ok,
 %Soroban.RPC.SendTransactionResponse{
   status: "PENDING",
   hash: "0521...",
   latest_ledger: 45075181,
   latest_ledger_close_time: "1691524532",
   error_result_xdr: nil
 }}

```

### Retrieve unsigned Transaction Envelope XDR

In order to facilitate seamless integration with wallets, we have developed functions that enable the retrieval of the unsigned Transaction Envelope XDR for each type of interaction with contracts: invocation, upload, and deployment.

This XDR is required by wallets to sign transactions before they can be submitted to the network. Once the wallet returns the signed XDR, the `Soroban.RPC.send_transaction/1` function can be used to submit the transaction.

#### Invoke contract function

**Parameters**

- `contract_address`: Identifier of the contract to be invoked, encoded as `StrKey`.
- `source_public_key`: Public key of the function invoker responsible for signing the transaction.
- `function_name`: String value indicating the name of the function to be invoked.
- `function_args`: List of `Soroban.Types` representing the arguments required by the indicated function (`function_name`). They should be provided in the specific order expected by the function.
- `extra_fee_rate`: Float number to increment the transaction fee to pay, useful when the operation returns an insufficient fee error.

```elixir
alias Soroban.Contract
alias Soroban.Types.String

contract_address = "CAEYZ6JI5YV2CBI3NRRUNA2DMERJ4KLJTI76WDZBTWZ7VMPGY6JDIZD5"
source_public_key = "GDEU46HFMHBHCSFA3K336I3MJSBZCWVI3LUGSNL6AF2BW2Q2XR7NNAPM"
extra_fee_rate = 0.08
function_name = "hello"

function_args = [String.new("world")]

Contract.retrieve_unsigned_xdr_to_invoke(
  contract_address,
  source_public_key,
  function_name,
  function_args,
  extra_fee_rate
)

"AAAAAgAAAAD...QAAAAAAAAAAAAAAAAAAAAA="

```

#### Install contract code

**Parameters**

- `wasm`: Binary of the web assembly (WASM) file resulting from building the contract.
- `source_public_key`: Public key of the function invoker responsible for signing the transaction.

```elixir
alias Soroban.Contract

wasm = File.read!("../your_wasm_path/hello.wasm")
source_public_key = "GDEU46HFMHBHCSFA3K336I3MJSBZCWVI3LUGSNL6AF2BW2Q2XR7NNAPM"

Contract.retrieve_unsigned_xdr_to_upload(wasm, source_public_key)

"AAAAAgAAAABaOyGfG/GU6itO0ElcKHcFqVS+fbN5bGtw0yDCwWKx2gAAAGQAADg8AAAAOgAAAAAAAAAAAAAAAQAAAAAAAAAYAA..."

```

#### Deploy Contract

**Parameters**

- `wasm_id`: Binary identification of the uploaded contract to deploy.
- `source_public_key`: Public key of the function invoker responsible for signing the transaction.

```elixir
alias Soroban.Contract

wasm_id = <<43, 175, 217, 68, 182, 222, 246, 123, 230, 77, 134, 236, 60, 179, 45, 137, 54,
  44, 8, 19, 0, 134, 104, 112, 90, 233, 87, 199, 60, 136, 151, 169>>
source_public_key = "GDEU46HFMHBHCSFA3K336I3MJSBZCWVI3LUGSNL6AF2BW2Q2XR7NNAPM"

Contract.retrieve_unsigned_xdr_to_deploy(wasm_id, source_public_key)

"AAAAAgAAAAD...ZAAAAFAAAAAAAAAAAAAAAAA=="

```

#### Deploy Asset Contract

**Parameters**

- `asset_code`: String from 1 to 12 characters indicating the asset symbol.
- `source_public_key`: Public key of the function invoker responsible for signing the transaction.

```elixir
alias Soroban.Contract

asset_code = "DBZ"
source_public_key = "GDEU46HFMHBHCSFA3K336I3MJSBZCWVI3LUGSNL6AF2BW2Q2XR7NNAPM"

Contract.retrieve_unsigned_xdr_to_deploy_asset(asset_code, source_public_key)

"AAAAAgAAAADJ...d4kfn7AAAAFAAAAAAAAAAAAAAAAA=="

```

## Configuration

The default HTTP Client is `:hackney`. Options can be passed to `:hackney` via configuration parameters.

```elixir
config :soroban, hackney_options: [{:connect_timeout, 1000}, {:recv_timeout, 5000}]
```

You can also change the default HTTP Client library.

```elixir
config :soroban, http_client: YourApp.CustomHTTPClient
```

### Custom HTTP Client

`soroban.ex` allows you to use the HTTP client implementation of your choice. See [**Soroban.RPC.Client.Spec**][http_client_spec] for details.

```elixir
config :soroban, :http_client_impl, YourApp.CustomClientImpl
```

### Custom JSON library

Following the same approach as the HTTP client, the JSON parsing library can also be configured. Defaults to [`Jason`][jason_url].

```elixir
config :soroban, :json_library, YourApp.CustomJSONLibrary
```

## Development

- Install an Elixir version `v1.14` or lower.
- Compile dependencies: `mix deps.get`.
- Run tests: `mix test`.

## Changelog

Features and bug fixes are listed in the [CHANGELOG][changelog] file.

## Code of conduct

We welcome everyone to contribute. Make sure you have read the [CODE_OF_CONDUCT][coc] before.

## Contributing

For information on how to contribute, please refer to our [CONTRIBUTING][contributing] guide.

## License

This library is licensed under an MIT license. See [LICENSE][license] for details.

## Acknowledgements

Made with 💙 by [kommitters Open Source](https://kommit.co)

[license]: https://github.com/kommitters/soroban.ex/blob/main/LICENSE
[coc]: https://github.com/kommitters/soroban.ex/blob/main/CODE_OF_CONDUCT.md
[changelog]: https://github.com/kommitters/soroban.ex/blob/main/CHANGELOG.md
[contributing]: https://github.com/kommitters/soroban.ex/blob/main/CONTRIBUTING.md
[http_client_spec]: https://github.com/kommitters/soroban.ex/blob/main/lib/rpc/client/spec.ex
[jason_url]: https://github.com/michalmuskala/jason
[hex]: https://hex.pm/packages/soroban
