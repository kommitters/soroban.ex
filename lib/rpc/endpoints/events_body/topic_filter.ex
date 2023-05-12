defmodule Soroban.RPC.TopicFilter do
  def new(args) when is_list(args) and length(args) <= 4 do
    with {:ok, segment_matchers} <- validate_segments(args) do
      segment_matchers
    end
  end

  defp validate_segments(_args, segment_matchers \\ [])

  defp validate_segments(["*" = val | rest], segment_matchers) do
    segment_matchers = (segment_matchers ++ [val]) |> IO.inspect()
    validate_segments(rest, segment_matchers)
  end

  defp validate_segments([%{__struct__: struct} = val | rest], segment_matchers)
       when is_struct(val) do
    segment_matchers =
      val
      |> struct.to_sc_val()
      |> param_to_xdr()
      |> (&(segment_matchers ++ [&1])).()

    validate_segments(rest, segment_matchers)
  end

  defp validate_segments([], segment_matchers), do: {:ok, segment_matchers}

  # @spec param_to_xdr(param :: struct()) :: xdr()
  defp param_to_xdr(%{__struct__: struct} = param) when is_struct(param) do
    xdr = struct.to_xdr(param)
    xdr_struct = xdr.__struct__
    xdr_struct.encode_xdr!(xdr)
  end
end
