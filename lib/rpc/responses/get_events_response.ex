defmodule Soroban.RPC.GetEventsResponse do
  @moduledoc """
  `GetEventsResponse` struct definition.
  """
  @behaviour Soroban.RPC.Response.Spec

  @type latest_ledger :: String.t()
  @type events :: list()
  @type t :: %__MODULE__{
          latest_ledger: latest_ledger(),
          events: events()
        }
  defstruct [:latest_ledger, :events]

  @impl true
  def new(attrs), do: struct(%__MODULE__{}, attrs)
end
