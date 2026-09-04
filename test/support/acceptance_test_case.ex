defmodule Support.AcceptanceTestCase do
  @moduledoc false

  defmacro __using__(_options) do
    quote do
      use ExUnit.Case, async: true
      alias Padmark.Options
      import Support.Helpers, only: [as_html: 1, as_html: 2]
      import Support.GenHtml
    end
  end
end

# SPDX-License-Identifier: Apache-2.0
