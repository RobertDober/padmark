defmodule Earmark.Parser.Enum.ExtTest do
  use ExUnit.Case, async: true

  alias Earmark.Parser.Enum.Ext

  describe "reduce_with_end/3" do
    test "calls the reducer with :end and the initial accumulator for an empty list" do
      reducer = fn :end, acc -> {:done, acc} end
      assert Ext.reduce_with_end([], :initial, reducer) == {:done, :initial}
    end

    test "folds every element before calling the reducer with :end" do
      reducer = fn
        {:element, e}, acc -> [e | acc]
        :end, acc -> {:done, Enum.reverse(acc)}
      end

      assert Ext.reduce_with_end([1, 2, 3], [], reducer) == {:done, [1, 2, 3]}
    end

    test "lets the reducer change the shape of the accumulator at :end" do
      sum_in_batches = fn
        {:element, nil}, {batch, totals} -> {[], [Enum.sum(batch) | totals]}
        {:element, n}, {batch, totals} -> {[n | batch], totals}
        :end, {batch, totals} -> [Enum.sum(batch) | totals] |> Enum.reverse()
      end

      assert Ext.reduce_with_end([1, 2, nil, 4, 1, 0, nil, 3, 2, 2], {[], []}, sum_in_batches) ==
               [3, 5, 7]
    end
  end
end
