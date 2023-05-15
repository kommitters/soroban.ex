defmodule Soroban.RPC.EventFilter do
  @moduledoc """
  `EventFilter` struct definition.
  """
  alias Soroban.RPC.TopicFilter
  @type args :: Keyword.t()
  @type error :: {:error, atom()}
  @type type :: :system | :contract | :diagnostic | nil
  @type contract_ids :: list(String.t()) | nil
  @type type_validation :: {:ok, type()} | error()
  @type contract_ids_validation :: {:ok, contract_ids()} | error()
  @type topics :: list(TopicFilter.t()) | nil
  @type topics_validation :: {:ok, topics()} | error()
  @type request_args :: map()
  @type t :: %__MODULE__{
          type: type(),
          contract_ids: contract_ids(),
          topics: topics
        }

  @allowed_types [:system, :contract, :diagnostic]

  defstruct [:type, :contract_ids, :topics]

  @spec new(args :: args()) :: t()
  def new(args) do
    type = Keyword.get(args, :type)
    contract_ids = Keyword.get(args, :contract_ids)
    topics = Keyword.get(args, :topics)

    with {:ok, type} <- validate_type(type),
         {:ok, contract_ids} <- validate_contract_ids(contract_ids),
         {:ok, topics} <- validate_topics(topics) do
      %__MODULE__{
        type: type,
        contract_ids: contract_ids,
        topics: topics
      }
    end
  end

  @spec to_request_args(t()) :: request_args()
  def to_request_args(%__MODULE__{type: type, contract_ids: contract_ids, topics: topics}),
    do: %{type: type, contractIds: contract_ids, topics: topics}

  @spec validate_type(type :: type()) :: type_validation()
  defp validate_type(type) when type in @allowed_types, do: {:ok, type}
  defp validate_type(nil), do: {:ok, nil}
  defp validate_type(_type), do: {:error, :invalid_type}

  @spec validate_contract_ids(contract_ids :: contract_ids()) :: contract_ids_validation()
  defp validate_contract_ids(nil), do: {:ok, nil}

  defp validate_contract_ids(contract_ids) when is_list(contract_ids) do
    case Enum.all?(contract_ids, &is_binary/1) do
      true -> {:ok, contract_ids}
      false -> {:error, :invalid_contract_ids}
    end
  end

  defp validate_contract_ids(_contract_ids), do: {:error, :invalid_contract_ids}

  @spec validate_topics(topics :: topics()) :: topics_validation()
  defp validate_topics([%TopicFilter{} = topic | _] = topics) do
    if Enum.any?(topics, fn t -> t.__struct__ != topic.__struct__ end),
      do: {:error, :invalid_topics},
      else: {:ok, topics}
  end

  defp validate_topics(nil), do: {:ok, nil}
  defp validate_topics(_topics), do: {:error, :invalid_topics}
end
