defmodule Earmark.Parser.HelpersTest do
  use ExUnit.Case, async: true

  alias Earmark.Parser.Helpers

  describe "expand_tabs/1" do
    test "expands a tab to the next 4-column stop" do
      assert Helpers.expand_tabs("a\tb") == "a   b"
    end

    test "expands a tab right after a full 4-column stop to a full 4 spaces" do
      assert Helpers.expand_tabs("abcd\te") == "abcd    e"
    end

    test "expands more than one tab in the same line" do
      assert Helpers.expand_tabs("a\tb\tc") == "a   b   c"
    end

    test "leaves a line without tabs untouched" do
      assert Helpers.expand_tabs("no tabs here") == "no tabs here"
    end
  end

  describe "remove_line_ending/2" do
    test "strips a trailing newline when there is no annotation" do
      assert Helpers.remove_line_ending("hello\n", nil) == {"hello", nil}
    end

    test "strips a trailing CRLF when there is no annotation" do
      assert Helpers.remove_line_ending("hello\r\n", nil) == {"hello", nil}
    end

    test "returns the line as is when it has no line ending" do
      assert Helpers.remove_line_ending("hello", nil) == {"hello", nil}
    end

    test "splits off the annotation when the line matches it" do
      annotation = Regex.compile!("\\A(.*)(#{Regex.escape("%%")}.*)")

      assert Helpers.remove_line_ending("code %% comment\n", annotation) ==
               {"code ", "%% comment"}
    end

    test "keeps the annotation nil when the line does not match it" do
      annotation = Regex.compile!("\\A(.*)(#{Regex.escape("%%")}.*)")
      assert Helpers.remove_line_ending("code only\n", annotation) == {"code only", nil}
    end
  end

  describe "replace/4" do
    test "replaces every match by default" do
      assert Helpers.replace("a-b-c", ~r/-/, "_") == "a_b_c"
    end

    test "replaces only the first match when global: false is passed" do
      assert Helpers.replace("a-b-c", ~r/-/, "_", global: false) == "a_b-c"
    end
  end
end
