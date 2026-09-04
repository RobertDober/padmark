defmodule Padmark.Helpers do
  @moduledoc false

  @doc """
  `Regex.replace` with the arguments in the correct order
  """
  @spec replace(
          String.t(),
          Regex.t(),
          String.t() | (... -> String.t()),
          Padmark.Options.options()
        ) :: String.t()
  def replace(text, regex, replacement, options \\ []) do
    Regex.replace(regex, text, replacement, options)
  end
end

# SPDX-License-Identifier: Apache-2.0
