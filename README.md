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

Add `soroban` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:soroban, "~> 0.5.0"}
  ]
end
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

## Soroban RPC endpoints

### Simulate Transaction

Submit a trial contract invocation to get back return values, expected ledger footprint, and expected costs.

**Parameters**

- `base64_envelope`: The transaction to be simulated (serialized in base64).

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
   latest_ledger: "475528",
   error: nil
 }}


```

### Send Transaction

Submit a real transaction to the Stellar network. This is the only way to make changes "on-chain".

Unlike Horizon, this does not wait for transaction completion. It simply validates and enqueues the transaction. Clients should call [Get Transaction](#get-transaction) to learn about transaction success/failure.

This supports all transactions, not only smart contract-related transactions.

**Parameters**

- `base64_envelope`: The signed transaction to broadcast (serialized in base64).

**Example**

```elixir
base64_envelope =
  "AAAAAgAAAADBPp7TMinJylnn+6dQXJACNc15LF+aJ2Py1BaR4P10JAAAAGQAAFBfAAAAIQAAAAEAAAAAAAAAAAAAAABkUtg3AAAAAAAAAAEAAAABAAAAAME+ntMyKcnKWef7p1BckAI1zXksX5onY/LUFpHg/XQkAAAAGAAAAAAAAAADAAAADQAAACAU0EuZrCKggMgcYHtwMuiHqnrYwhksO17kfjwJ8h2l3QAAAA8AAAAFaGVsbG8AAAAAAAAPAAAABXdvcmxkAAAAAAAAAgAAAAYU0EuZrCKggMgcYHtwMuiHqnrYwhksO17kfjwJ8h2l3QAAABQAAAAHCoKrtqgxTcxBJ+F9JX+3Gvlw3NtYGwCu8hzxUsbupwIAAAAAAAAAAAAAAAAAAAAB4P10JAAAAEDS4+hvSG1JqhOIPaGSqUerNsjhIcS+AwWhH/K8IOafcmMlZJoyZvMftV1QcdWA/LQhr2QJRTWNT6I52/eTP3IH"

Soroban.RPC.send_transaction(base64_envelope)

{:ok,
 %Soroban.RPC.SendTransactionResponse{
   status: "PENDING",
   hash: "a4721e2a61e9a6b3f54030396e41c3e352101e6cd649b4453e89fb3e827744f4",
   latest_ledger: "476420",
   latest_ledger_close_time: "1683150612",
   error_result_xdr: nil
 }}
```

### Get Transaction

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
   latest_ledger: "476536",
   latest_ledger_close_time: "1683151229",
   oldest_ledger: "475097",
   oldest_ledger_close_time: "1683143656",
   application_order: 1,
   envelope_xdr:
     "AAAAAgAAAADBPp7TMinJylnn+6dQXJACNc15LF+aJ2Py1BaR4P10JAAAAGQAAFBfAAAAIQAAAAEAAAAAAAAAAAAAAABkUtg3AAAAAAAAAAEAAAABAAAAAME+ntMyKcnKWef7p1BckAI1zXksX5onY/LUFpHg/XQkAAAAGAAAAAAAAAADAAAADQAAACAU0EuZrCKggMgcYHtwMuiHqnrYwhksO17kfjwJ8h2l3QAAAA8AAAAFaGVsbG8AAAAAAAAPAAAABXdvcmxkAAAAAAAAAgAAAAYU0EuZrCKggMgcYHtwMuiHqnrYwhksO17kfjwJ8h2l3QAAABQAAAAHCoKrtqgxTcxBJ+F9JX+3Gvlw3NtYGwCu8hzxUsbupwIAAAAAAAAAAAAAAAAAAAAB4P10JAAAAEDS4+hvSG1JqhOIPaGSqUerNsjhIcS+AwWhH/K8IOafcmMlZJoyZvMftV1QcdWA/LQhr2QJRTWNT6I52/eTP3IH",
   result_xdr:
     "AAAAAAAAAGQAAAAAAAAAAQAAAAAAAAAYAAAAAAAAABAAAAABAAAAAgAAAA8AAAAFSGVsbG8AAAAAAAAPAAAABXdvcmxkAAAAAAAAAA==",
   result_meta_xdr:
     "AAAAAwAAAAIAAAADAAdFBQAAAAAAAAAAwT6e0zIpycpZ5/unUFyQAjXNeSxfmidj8tQWkeD9dCQAAAAXDNwRHAAAUF8AAAAgAAAAAAAAAAAAAAAAAAAAAAEAAAAAAAAAAAAAAQAAAAAAAAAAAAAAAAAAAAAAAAACAAAAAAAAAAAAAAAAAAAAAwAAAAAAB0J+AAAAAGRSydYAAAAAAAAAAQAHRQUAAAAAAAAAAME+ntMyKcnKWef7p1BckAI1zXksX5onY/LUFpHg/XQkAAAAFwzcERwAAFBfAAAAIQAAAAAAAAAAAAAAAAAAAAABAAAAAAAAAAAAAAEAAAAAAAAAAAAAAAAAAAAAAAAAAgAAAAAAAAAAAAAAAAAAAAMAAAAAAAdFBQAAAABkUtcZAAAAAAAAAAEAAAAAAAAAAAAAAAEAAAAAAAAAAAAAAGQAAAAAAAAAAQAAAAAAAAAYAAAAAAAAABAAAAABAAAAAgAAAA8AAAAFSGVsbG8AAAAAAAAPAAAABXdvcmxkAAAAAAAAAKQ1a84I/mDKy5j2B/YFeyfTCsTBoKJtON5QDfqS06qwy7xIdQ3ruFNQk7Per4isf0z/h0JVdqWN4rrHVKzbRhYD6NIFNZRcltVrmGLx9Y+ku182sxlHjDdsZ28pYul9HwAAAAA=",
   ledger: "476421"
 }}

```

## Invoke contracts functions

### Invoke without required authorization 

```elixir
alias Soroban.Contract
alias Soroban.Types.Symbol

Contract.invoke(
  "be4138b31cc5d0d9d91b53193d74316d254406794ec0f81d3ed40f4dc1b86a6e",
  "SCAVFA3PI3MJLTQNMXOUNBSEUOSY66YMG3T2KCQKLQBENNVLVKNPV3EK",
  "hello",
  [Symbol.new("world")]
)

{:ok,
 %Soroban.RPC.SendTransactionResponse{
   status: "PENDING",
   hash: "f62cb9e20c6d297316f49dca2041be4bf1af6b069c784764e51ac008b313d716",
   latest_ledger: "570194",
   latest_ledger_close_time: "1683643419",
   error_result_xdr: nil
 }}
```

### Invoke with required authorization 

- When the invoker is the signer


```elixir
alias Soroban.Contract
alias Soroban.Types.{Address, UInt128}

Soroban.Contract.invoke(
  "be4138b31cc5d0d9d91b53193d74316d254406794ec0f81d3ed40f4dc1b86a6e",
  "SCAVFA3PI3MJLTQNMXOUNBSEUOSY66YMG3T2KCQKLQBENNVLVKNPV3EK",
  "inc",
  [Address.new("GDEU46HFMHBHCSFA3K336I3MJSBZCWVI3LUGSNL6AF2BW2Q2XR7NNAPM"), UInt128.new(2)]
)

{:ok,
 %Soroban.RPC.SendTransactionResponse{
   status: "PENDING",
   hash: "e888193b4fed9b3ca6ad2beca3c1ed5bef3e0099e558756de85d03511cbaa00b",
   latest_ledger: "570253",
   latest_ledger_close_time: "1683643728",
   error_result_xdr: nil
 }}
``` 

- When the invokers is not the signer 

```elixir
alias Soroban.Contract
alias Soroban.Types.{Address, Int128}

Contract.invoke(
  "be4138b31cc5d0d9d91b53193d74316d254406794ec0f81d3ed40f4dc1b86a6e",
  "SDRD4CSRGPWUIPRDS5O3CJBNJME5XVGWNI677MZDD4OD2ZL2R6K5IQ24",
  "swap",
  [
    Address.new("GDEU46HFMHBHCSFA3K336I3MJSBZCWVI3LUGSNL6AF2BW2Q2XR7NNAPM"),
    Int128.new(100),
    Int128.new(4500)
  ],
  ["SCAVFA3PI3MJLTQNMXOUNBSEUOSY66YMG3T2KCQKLQBENNVLVKNPV3EK"]
)

{:ok,
 %Soroban.RPC.SendTransactionResponse{
   status: "PENDING",
   hash: "da263f59a8f8b29f415e7e26758cad6e8d88caec875112641b88757ce8e01873",
   latest_ledger: "570349",
   latest_ledger_close_time: "1683644240",
   error_result_xdr: nil
 }}
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
