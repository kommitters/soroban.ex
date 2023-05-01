defmodule Soroban.Types.DurationTest do
  use ExUnit.Case

  alias Soroban.Types.Duration
  alias Stellar.TxBuild.SCVal

  setup do
    duration = Duration.new(12_345)
    %{duration: duration}
  end

  describe "new/1" do
    test "with a valid value" do
      %Duration{value: 12_345} = Duration.new(12_345)
    end

    test "with an invalid range integer" do
      {:error, :not_in_duration_range} = Duration.new(-12_345)
    end

    test "with an invalid value" do
      {:error, :invalid} = Duration.new("Invalid")
    end

    test "with a nil value" do
      {:error, :invalid} = Duration.new(nil)
    end

    test "with an atom value" do
      {:error, :invalid} = Duration.new(:atom)
    end
  end

  describe "to_sc_val/1" do
    test "with a valid struct", %{duration: duration} do
      %SCVal{type: :duration, value: 12_345} = Duration.to_sc_val(duration)
    end

    test "with an invalid value" do
      {:error, :invalid_struct_duration} = Duration.to_sc_val(nil)
    end
  end
end
