defmodule Acceptance.Html.LinksImages.WikilinkTest do
  use Support.AcceptanceTestCase

  describe "wikilinks disabled (default)" do
    test "is left as plain text" do
      markdown = "[[Some Page]]"
      html = "<p>\n[[Some Page]]</p>\n"
      messages = []

      assert as_html(markdown) == {:ok, html, messages}
    end
  end

  describe "wikilinks enabled" do
    test "a bare target is used as both href and text" do
      markdown = "[[Some Page]]"
      html = "<p>\n<a href=\"Some Page\">Some Page</a></p>\n"
      messages = []

      assert as_html(markdown, wikilinks: true) == {:ok, html, messages}
    end

    test "a target with custom text uses the target as href and the text as the link text" do
      markdown = "[[Some Page|Click here]]"
      html = "<p>\n<a href=\"Some Page\">Click here</a></p>\n"
      messages = []

      assert as_html(markdown, wikilinks: true) == {:ok, html, messages}
    end
  end
end

# SPDX-License-Identifier: Apache-2.0
