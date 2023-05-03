defmodule Soroban.Types.TimePointTest do
  use ExUnit.Case

  alias Soroban.Types.TimePoint
  alias Stellar.TxBuild.SCVal

  setup do
    time_point = TimePoint.new(12_345)
    %{time_point: time_point}
  end

  describe "new/1" do
    test "with a valid value" do
      %TimePoint{value: 12_345} = TimePoint.new(12_345)
    end

    test "with an invalid range integer" do
      {:error, :not_in_time_point_range} = TimePoint.new(-12_345)
    end

    test "with an invalid value" do
      {:error, :invalid} = TimePoint.new("Invalid")
    end

    test "with a nil value" do
      {:error, :invalid} = TimePoint.new(nil)
    end

    test "with an atom value" do
      {:error, :invalid} = TimePoint.new(:atom)
    end
  end

  describe "to_sc_val/1" do
    test "with a valid struct", %{time_point: time_point} do
      %SCVal{type: :time_point, value: 12_345} = TimePoint.to_sc_val(time_point)
    end

    test "with an invalid value" do
      {:error, :invalid_struct_time_point} = TimePoint.to_sc_val(nil)
    end
  end
end
