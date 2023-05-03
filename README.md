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
    {:soroban, "~> 0.3.0"}
  ]
end
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
