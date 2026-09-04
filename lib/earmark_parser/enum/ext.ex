defmodule Earmark.Parser.Enum.Ext do
  @moduledoc ~S"""
    Some extensions of Enum functions
  """

  @doc ~S"""
  `reduce_with_end` is like `Enum.reduce` for lists, but the reducer function is called for
  each element of the list with the tuple `{:element, element}` and the accumulator and once
  more at the end with `:end` and the accumulator

      iex(1)> reducer =
      ...(1)>   fn {:element, nil}, {partial, result} -> {[], [Enum.sum(partial)|result]}
      ...(1)>      {:element, val}, {partial, result} -> {[val|partial], result}
      ...(1)>      :end,            {partial, result} -> [Enum.sum(partial)|result] |> Enum.reverse
      ...(1)>   end
      ...(1)> [1, 2, nil, 4, 1, 0, nil, 3, 2, 2]
      ...(1)> |> reduce_with_end({[], []}, reducer)
      [3, 5, 7]

  **N.B.** that in the treatment of `:end` we can change the shape of the accumulator w/o any
  penalty concerning the complexity of the reducer function
  """
  def reduce_with_end(collection, initial_acc, reducer_fn)

  def reduce_with_end([], acc, reducer_fn) do
    reducer_fn.(:end, acc)
  end

  def reduce_with_end([ele | rest], acc, reducer_fn) do
    reduce_with_end(rest, reducer_fn.({:element, ele}, acc), reducer_fn)
  end
end

#  SPDX-License-Identifier: Apache-2.0
