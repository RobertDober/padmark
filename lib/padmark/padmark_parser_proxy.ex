defmodule Padmark.PadmarkParserProxy do
  @moduledoc ~S"""
  This acts as a proxy to adapt to changes in `Padmark.Parser`'s API

  If no changes are needed it can delegate `as_ast` to `Padmark.Parser`

  If changes are needed they will be realised in this modules `as_ast`
  function.

  For that reason `Padmark.Parser.as_ast/*` **SHALL NOT** be invoked
  anywhere else in this code base
  """

  @doc ~S"""
  An adapter to `Padmark.Parser.as_ast/*`
  """
  @spec as_ast([String.t()] | String.t(), Padmark.Options.options()) ::
          {:error, Padmark.ast(), [any()]} | {:ok, Padmark.ast(), [map()]}
  def as_ast(input, options)

  def as_ast(input, options) when is_list(options) do
    Padmark.Parser.as_ast(
      input,
      options |> Keyword.delete(:smartypants) |> Keyword.delete(:messages)
    )
  end

  def as_ast(input, options) when is_map(options) do
    Padmark.Parser.as_ast(input, options |> Map.delete(:smartypants) |> Map.delete(:messages))
  end
end

#  SPDX-License-Identifier: Apache-2.0
