defmodule Acceptance.Html.FootnotesTest do
  use Support.AcceptanceTestCase

  describe "Footnotes" do
    test "without errors" do
      markdown = "foo[^1] again\n\n[^1]: bar baz"

      {:ok, html, []} = as_html(markdown, footnotes: true)

      {:ok,
       [
         {"p", [], ["\nfoo", {"a", link_atts, ["1"]}, " again"]},
         {"div", [{"class", "footnotes"}], footnote}
       ]} = Floki.parse_document(html)

      assert Enum.sort(link_atts) == [
               {"class", "footnote"},
               {"href", "#fn:1"},
               {"id", "fnref:1"},
               {"title", "see footnote"}
             ]

      [
        {"hr", [], []},
        {"ol", [],
         [
           {"li", [{"id", "fn:1"}],
            [
              {"a", backlink_atts, ["↩"]},
              {"p", [], ["\nbar baz      "]}
            ]}
         ]}
      ] = footnote

      assert Enum.sort(backlink_atts) == [
               {"class", "reversefootnote"},
               {"href", "#fnref:1"},
               {"title", "return to article"}
             ]
    end

    test "two footnotes are numbered in order and each gets its own entry" do
      markdown = "foo[^1] and bar[^2]\n\n[^1]: first note\n\n[^2]: second note"

      assert {:ok, html, []} = as_html(markdown, footnotes: true)
      assert html =~ ~s{<a href="#fn:1" id="fnref:1" class="footnote" title="see footnote">1</a>}
      assert html =~ ~s{<a href="#fn:2" id="fnref:2" class="footnote" title="see footnote">2</a>}
      assert html =~ "first note"
      assert html =~ "second note"
    end

    test "a footnote body spanning more than one block is kept in a single entry" do
      markdown = "foo[^1]\n\n[^1]: first paragraph\n\n    second paragraph"

      assert {:ok, html, []} = as_html(markdown, footnotes: true)
      assert html =~ "<li id=\"fn:1\">"
      assert html =~ "first paragraph"
      assert html =~ "<pre><code>second paragraph</code></pre>"
    end

    test "markdown inside a footnote body is parsed" do
      markdown = "foo[^1]\n\n[^1]: has **bold** and a [link](http://x.test)"

      assert {:ok, html, []} = as_html(markdown, footnotes: true)
      assert html =~ "<strong>bold</strong>"
      assert html =~ ~s{<a href="http://x.test">link</a>}
    end

    test "a reference to an undefined footnote is reported and left untouched" do
      markdown = "foo[^missing] bar"

      assert as_html(markdown, footnotes: true) ==
               {:error, "<p>\nfoo[^missing] bar</p>\n",
                [{:error, 1, "footnote missing undefined, reference to it ignored"}]}
    end
  end
end

# SPDX-License-Identifier: Apache-2.0
