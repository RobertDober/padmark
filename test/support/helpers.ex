defmodule Support.Helpers do
  @moduledoc false

  alias Padmark.Options

  ###############
  # Helpers.... #
  ###############

  def as_ast(markdown, options \\ []) do
    Padmark.Parser.as_ast(markdown, Options.make_options!(options))
  end

  def as_html(markdown, options \\ []) do
    Padmark.as_html(markdown, Options.make_options!(options))
  end

  def as_html!(markdown, options \\ []) do
    Padmark.as_html!(markdown, Options.make_options!(options))
  end
end

# SPDX-License-Identifier: Apache-2.0
