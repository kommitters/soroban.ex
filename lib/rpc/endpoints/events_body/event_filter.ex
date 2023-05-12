defmodule Soroban.RPC.EventFilter do
  alias Soroban.RPC.TopicFilter
  @type type :: :system | :contract | :diagnostic
  @type contract_ids :: list(String.t())
  @type topics :: list(TopicFilter.t())
  @type t :: %__MODULE__{
          type: type(),
          contract_ids: contract_ids(),
          topics: topics
        }

  defstruct [:type, :contract_ids, :topics]

  def new(args) do
    type = Keyword.get(args, :type)
    contract_ids = Keyword.get(args, :contract_ids)
    topics = Keyword.get(args, :topics)

    %__MODULE__{
      type: type,
      contract_ids: contract_ids,
      topics: topics
    }
  end
end
