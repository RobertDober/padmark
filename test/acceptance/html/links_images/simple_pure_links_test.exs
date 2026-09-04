defmodule Acceptance.Html.LinksImages.SimplePureLinksTest do
  use Support.AcceptanceTestCase

  describe "simple pure links not yet enabled" do
    test "old behavior" do
      markdown = "https://github.com/pragdave/earmark"
      html     = "<p>\nhttps://github.com/pragdave/earmark</p>\n"
      messages = []

      assert as_html(markdown, pure_links: false) == {:ok, html, messages}
    end
  end

  describe "enabled pure links" do
    test "two in a row" do
      url1 = "https://github.com/pragdave/earmark"
      url2 = "https://github.com/RobertDober/extractly"
      markdown = "#{url1} #{url2}"
       html = "<p>\n<a href=\"https://github.com/pragdave/earmark\">https://github.com/pragdave/earmark</a> <a href=\"https://github.com/RobertDober/extractly\">https://github.com/RobertDober/extractly</a></p>\n"
      messages = []

      assert as_html(markdown) == {:ok, html, messages}
    end

    test "a www. link at the start of the line" do
      markdown = "www.example.com"
      html = "<p>\n<a href=\"http://www.example.com\">www.example.com</a></p>\n"
      messages = []

      assert as_html(markdown) == {:ok, html, messages}
    end

    test "a www. link in the middle of a sentence" do
      markdown = "check www.example.com"
      html = "<p>\ncheck <a href=\"http://www.example.com\">www.example.com</a></p>\n"
      messages = []

      assert as_html(markdown) == {:ok, html, messages}
    end

    test "balanced parentheses inside the url are kept" do
      markdown = "See https://en.wikipedia.org/wiki/Foo_(bar) for more."

      html =
        "<p>\nSee <a href=\"https://en.wikipedia.org/wiki/Foo_(bar)\">https://en.wikipedia.org/wiki/Foo_(bar)</a> for more.</p>\n"

      messages = []

      assert as_html(markdown) == {:ok, html, messages}
    end

    test "an unbalanced closing parenthesis after the url is left out" do
      markdown = "(see https://example.com)"
      html = "<p>\n(see <a href=\"https://example.com\">https://example.com</a>)</p>\n"
      messages = []

      assert as_html(markdown) == {:ok, html, messages}
    end

    test "trailing punctuation is not part of the url" do
      markdown = "Visit https://example.com, it is great."

      html =
        "<p>\nVisit <a href=\"https://example.com\">https://example.com</a>, it is great.</p>\n"

      messages = []

      assert as_html(markdown) == {:ok, html, messages}
    end

    test "a query string ampersand is escaped like any other text" do
      markdown = "Visit https://example.com/a?x=1&y=2 now."

      html =
        "<p>\nVisit <a href=\"https://example.com/a?x=1&amp;y=2\">https://example.com/a?x=1&amp;y=2</a> now.</p>\n"

      messages = []

      assert as_html(markdown) == {:ok, html, messages}
    end

    test "a scheme other than http(s) or www. is left as plain text" do
      markdown = "Use ftp://example.com for that."
      html = "<p>\nUse ftp://example.com for that.</p>\n"
      messages = []

      assert as_html(markdown) == {:ok, html, messages}
    end
  end
end

# SPDX-License-Identifier: Apache-2.0
