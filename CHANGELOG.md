# Changelog

## 0.21.0 (24.07.2024)

- [Stellar Protocol 21 support](https://github.com/kommitters/soroban.ex/issues/158).
  - Create the getVersionInfo endpoint
  - Create the getTransactions endpoint
  - Create the getFeeStats endpoint
  - Update the simulateTransaction response

## 0.20.1 (25.04.2024)

- Add stale issues policy. See [PR #154](https://github.com/kommitters/soroban.ex/pull/154)

## 0.20.0 (07.03.2024)

- Add Soroban.RPC.Server and network_passphrase configuration. Apply changes from `stellar_sdk` v0.21.0. See [Issue #149](https://github.com/kommitters/soroban.ex/issues/149).
- Update dependencies. See [PR #135](https://github.com/kommitters/soroban.ex/pull/135).
- Update Security Policy.

## 0.19.0 (31.01.2024)

- Support `diagnostic_events_xdr` field in `SendTransactionResponse` struct. See [stellar_sdk#350](https://github.com/kommitters/stellar_sdk/issues/350).

## 0.18.0 (20.12.2023)

- [Stellar Protocol 20 support](https://github.com/kommitters/soroban.ex/issues/140).
- [Remove percentages of additional resources + update SimulateTransactionResponse](https://github.com/kommitters/soroban.ex/pull/142).
- [Support resource leeway in simulate transaction](https://github.com/kommitters/soroban.ex/pull/143).
- Add www.bestpractices.dev to scorecards workflow.

## 0.17.0 (26.10.2023)

- [Allow deploying an asset contract by a diferent invoker than the asset issuer](https://github.com/kommitters/soroban.ex/issues/136).

## 0.16.0 (27.09.2023)

- [Testnet Support](https://github.com/kommitters/soroban.ex/issues/131).

## 0.15.0 (21.09.2023)

- [Soroban Preview 11 support](https://github.com/kommitters/soroban.ex/issues/126).

## 0.14.0 (05.09.2023)

- Allow to add custom extra fee rate when invoking functions.
- Update all dependencies.

## 0.13.0 (09.08.2023)

- [Allow invocation with invoker authorization](https://github.com/kommitters/soroban.ex/issues/103).
- [Add BumpFootprintExpiration operation](https://github.com/kommitters/soroban.ex/issues/104).
- [Add RestoreFootprint operation](https://github.com/kommitters/soroban.ex/issues/105).
- Allow to use simulate tx in contract functions invocation.
- Update all dependencies.
- Add `builds.hex.pm` to allowed-endpoints in CD.
- Update harden-runner action to v2.5.1.

## 0.12.0 (28.07.2023)

- [Soroban Preview 10 support: Enable key use cases for deployment and invocation](https://github.com/kommitters/soroban.ex/issues/102).
- [Update erlef/setup-beam action in CD](https://github.com/kommitters/soroban.ex/pull/109).

## 0.11.2 (15.06.2023)

- Update `stellar_sdk` dependency to `0.15.1` which fixes a bug related to the contract address.

## 0.11.1 (09.06.2023)

- [Allow to create empty maps and vecs](https://github.com/kommitters/soroban.ex/pull/95)

## 0.11.0 (06.06.2023)

- [Soroban preview 9 support](https://github.com/kommitters/soroban.ex/issues/91)

## 0.10.0 (18.05.2023)

- [Soroban.ex improvements](https://github.com/kommitters/soroban.ex/issues/84)

## 0.9.0 (18.05.2023)

- [Retrieve unsigned transactions](https://github.com/kommitters/soroban.ex/issues/70)

## 0.8.0 (17.05.2023)

- [Soroban RPC Endpoints](https://github.com/kommitters/soroban.ex/issues/48)

## 0.7.0 (15.05.2023)

- [Contract deployment functions](https://github.com/kommitters/soroban.ex/issues/45)

## 0.6.0 (11.05.2023)

- [Soroban compound types](https://github.com/kommitters/soroban.ex/issues/43)

## 0.5.0 (09.05.2023)

- [Invoke Contract Function](https://github.com/kommitters/soroban.ex/issues/23)

## 0.4.0 (04.05.2023)

- [Soroban RPC: Simulate, Send & Get transaction](https://github.com/kommitters/soroban.ex/issues/16)

## 0.3.0 (03.05.2023)

- [Compose functional requests](https://github.com/kommitters/soroban.ex/issues/13)

## 0.2.0 (03.05.2023)

- [Initial Types](https://github.com/kommitters/soroban.ex/issues/9)

## 0.1.0 (04.28.2023)

- [Project setup](https://github.com/kommitters/soroban.ex/issues/1)
