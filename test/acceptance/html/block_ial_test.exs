defmodule Acceptance.Html.BlockIalTest do
  use Support.AcceptanceTestCase

  describe "IAL" do
    test "Not associated" do
      markdown = "{:hello=world}"
      html = "<p>\n{:hello=world}</p>\n"
      messages = []

      assert as_html(markdown) == {:ok, html, messages}
    end

    test "Not associated means verbatim" do
      markdown = "{: hello=world  }"
      html = "<p>\n{: hello=world  }</p>\n"
      messages = []

      assert as_html(markdown) == {:ok, html, messages}
    end

    test "Associated" do
      markdown = "Before\n{:hello=world}"
      html = "<p hello=\"world\">\nBefore</p>\n"
      messages = []

      assert as_html(markdown) == {:ok, html, messages}
    end

    test "class shorthand" do
      markdown = "Before\n{:.myclass}"
      html = "<p class=\"myclass\">\nBefore</p>\n"
      messages = []

      assert as_html(markdown) == {:ok, html, messages}
    end

    test "id shorthand" do
      markdown = "Before\n{:#myid}"
      html = "<p id=\"myid\">\nBefore</p>\n"
      messages = []

      assert as_html(markdown) == {:ok, html, messages}
    end

    test "single quoted attribute value" do
      markdown = "Before\n{:title='hello world'}"
      html = "<p title=\"hello world\">\nBefore</p>\n"
      messages = []

      assert as_html(markdown) == {:ok, html, messages}
    end

    test "double quoted attribute value" do
      markdown = "Before\n{:title=\"hello world\"}"
      html = "<p title=\"hello world\">\nBefore</p>\n"
      messages = []

      assert as_html(markdown) == {:ok, html, messages}
    end

    test "unquoted attribute value" do
      markdown = "Before\n{:title=hello}"
      html = "<p title=\"hello\">\nBefore</p>\n"
      messages = []

      assert as_html(markdown) == {:ok, html, messages}
    end

    test "class, id and a custom attribute combined" do
      markdown = "Before\n{:.myclass #myid title=hello}"
      html = "<p class=\"myclass\" id=\"myid\" title=\"hello\">\nBefore</p>\n"
      messages = []

      assert as_html(markdown) == {:ok, html, messages}
    end

    # Regression test for GHSA-52mm-h59v-f3c7: an IAL attribute value is not
    # restricted to plain text, so it must go through the same escaping as
    # any other attribute (Padmark.Transform._make_att1/2).
    test "an attribute value with a tag and an ampersand is escaped" do
      markdown = "Before\n{:title=\"<b>bold</b> & more\"}"
      html = "<p title=\"&lt;b&gt;bold&lt;/b&gt; &amp; more\">\nBefore</p>\n"
      messages = []

      assert as_html(markdown) == {:ok, html, messages}
    end

    test "an illegal attribute is dropped and reported as a warning" do
      markdown = "Before\n{:bad!attr}"
      html = "<p>\nBefore</p>\n"
      messages = [{:warning, 2, ~s{Illegal attributes ["bad!attr"] ignored in IAL}}]

      assert as_html(markdown) == {:error, html, messages}
    end

    test "several illegal attributes are all reported in one warning" do
      markdown = "Before\n{:bad!attr also!bad}"
      html = "<p>\nBefore</p>\n"

      messages = [
        {:warning, 2, ~s{Illegal attributes ["also!bad", "bad!attr"] ignored in IAL}}
      ]

      assert as_html(markdown) == {:error, html, messages}
    end
  end
end

# SPDX-License-Identifier: Apache-2.0
