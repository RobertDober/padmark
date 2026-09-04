defmodule Acceptance.Html.LinksImages.TitlesTest do
  use Support.AcceptanceTestCase

  describe "Links with titles" do
    test "two titled links" do
      mark_tmp = "[link](/uri \"title\")"
      markdown = "#{mark_tmp} #{mark_tmp}\n"

      html =
        "<p>\n<a href=\"/uri\" title=\"title\">link</a> <a href=\"/uri\" title=\"title\">link</a></p>\n"

      messages = []

      assert as_html(markdown) == {:ok, html, messages}
    end
  end

  describe "Images, and links with titles" do
    test "two titled images, different quotes" do
      markdown = ~s{![a](a 't') ![b](b "u")}

      html =
        "<p>\n  <img src=\"a\" alt=\"a\" title=\"t\">\n   <img src=\"b\" alt=\"b\" title=\"u\">\n</p>\n"

      messages = []

      assert as_html(markdown) == {:ok, html, messages}
    end
  end

  # Regression tests for GHSA-52mm-h59v-f3c7 (CVE-2026-48591). A title
  # containing a quote or an angle bracket used to break out of the
  # attribute instead of being escaped. Every attribute is now escaped at
  # the single point where tags get serialized.
  describe "titles containing characters that must be escaped (GHSA-52mm-h59v-f3c7)" do
    test "a link title with a quote, an ampersand and angle brackets stays inside the attribute" do
      markdown = ~s{[link](/uri "a \\"quoted\\" title & <tag>")}

      html =
        "<p>\n<a href=\"/uri\" title=\"a \\&quot;quoted\\&quot; title &amp; &lt;tag&gt;\">link</a></p>\n"

      messages = []

      assert as_html(markdown) == {:ok, html, messages}
      refute html =~ ~s{<tag>}
    end

    test "an image title with a quote, an ampersand and angle brackets stays inside the attribute" do
      markdown = ~s{![alt & <b>](/img.png "a \\"quoted\\" title & <tag>")}

      html =
        "<p>\n  <img src=\"/img.png\" alt=\"alt &amp; &lt;b&gt;\" title=\"a \\&quot;quoted\\&quot; title &amp; &lt;tag&gt;\">\n</p>\n"

      messages = []

      assert as_html(markdown) == {:ok, html, messages}
      refute html =~ ~s{<b>}
      refute html =~ ~s{<tag>}
    end
  end
end
