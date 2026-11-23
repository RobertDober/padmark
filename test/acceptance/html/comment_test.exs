defmodule Acceptance.Html.CommentTest do
  use ExUnit.Case, async: true

  import Support.Helpers, only: [as_html: 1]

  describe "HTML Comments" do
    test "one line" do
      markdown = "<!-- Hello -->"
      html = "<!-- Hello -->\n"
      messages = []

      assert as_html(markdown) == {:ok, html, messages}
    end

    test "more lines" do
      markdown = "<!-- Hello\n World -->"
      html = "<!-- Hello\n World -->\n"
      messages = []

      assert as_html(markdown) == {:ok, html, messages}
    end

    test "what about the closing" do
      markdown = "<!-- Hello\n World -->"
      html = "<!-- Hello\n World -->\n"
      messages = []

      assert as_html(markdown) == {:ok, html, messages}
    end

    test "inside inline code" do
      markdown = "The `<!--more-->` tag tells us where to cut."

      html =
        "<p>\nThe <code class=\"inline\">&lt;!--more--&gt;</code> tag tells us where to cut.</p>\n"

      messages = []

      assert as_html(markdown) == {:ok, html, messages}
    end
  end
end

# SPDX-License-Identifier: Apache-2.0
