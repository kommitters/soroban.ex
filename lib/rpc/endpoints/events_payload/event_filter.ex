defmodule Soroban.RPC.EventFilter do
  @moduledoc """
  `EventFilter` struct definition.
  """
  alias Soroban.RPC.TopicFilter

  @type args :: Keyword.t()
  @type error :: {:error, atom()}
  @type type :: list(:system | :contract | :diagnostic) | nil
  @type contract_ids :: list(String.t()) | nil
  @type type_validation :: {:ok, type()} | error()
  @type contract_ids_validation :: {:ok, contract_ids()} | error()
  @type topics :: list(TopicFilter.t()) | nil
  @type topics_validation :: {:ok, topics()} | error()
  @type request_args :: map() | :error
  @type t :: %__MODULE__{
          type: type(),
          contract_ids: contract_ids(),
          topics: topics()
        }

  @allowed_types [:system, :contract, :diagnostic]

  defstruct [:type, :contract_ids, :topics]

  @spec new(args :: args()) :: t() | error()
  def new(args) when is_list(args) do
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

  def new(_args), do: {:error, :invalid_args}

  @spec to_request_args(t()) :: request_args()
  def to_request_args(%__MODULE__{type: type, contract_ids: contract_ids, topics: topics}) do
    topics = Enum.map(topics, &TopicFilter.to_request_args/1)

    type =
      if type != nil,
        do: Enum.join(type, ", ")

    %{type: type, contractIds: contract_ids, topics: topics}
  end

  def to_request_args(_topic_filter), do: :error

  @spec validate_type(type :: type()) :: type_validation()
  defp validate_type(types) when is_list(types) do
    if Enum.all?(types, &(&1 in @allowed_types)),
      do: {:ok, types},
      else: {:error, :invalid_type}
  end

  defp validate_type(nil), do: {:ok, nil}
  defp validate_type(_type), do: {:error, :invalid_types}

  @spec validate_contract_ids(contract_ids :: contract_ids()) :: contract_ids_validation()
  defp validate_contract_ids(nil), do: {:ok, nil}

  defp validate_contract_ids(contract_ids)
       when is_list(contract_ids) and length(contract_ids) in 1..5 do
    if Enum.all?(contract_ids, &is_contract_id?(&1)),
      do: {:ok, contract_ids},
      else: {:error, :invalid_contract_ids}
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

  defp is_contract_id?(contract_id) when is_binary(contract_id) do
    case StellarBase.StrKey.decode(contract_id, :contract) do
      {:ok, _decoded} -> true
      {:error, _error} -> false
    end
  end

  defp is_contract_id?(_contract_id), do: false
end
