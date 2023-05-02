defmodule Soroban.Types.Spec do
  @moduledoc """
  Defines base types constructions.
  """
  alias Stellar.TxBuild.SCVal

  alias Soroban.Types.{
    Address,
    Bool,
    Bytes,
    Duration,
    Int128,
    Int256,
    Int32,
    Int64,
    String,
    Symbol,
    TimePoint,
    UInt128,
    UInt256,
    UInt32,
    UInt64
  }

  @type error :: {:error, atom()}
  @type sc_val :: SCVal.t()
  @type type ::
          Address.t()
          | Bool.t()
          | Bytes.t()
          | Symbol.t()
          | String.t()
          | Duration.t()
          | TimePoint.t()
          | Int32.t()
          | UInt32.t()
          | Int64.t()
          | UInt64.t()
          | Int128.t()
          | UInt128.t()
          | Int256.t()
          | UInt256.t()

  @callback new(any()) :: type() | error()
  @callback to_sc_val(type()) :: sc_val()
end
