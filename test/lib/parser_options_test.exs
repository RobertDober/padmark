defmodule Padmark.Parser.OptionsTest do
  use ExUnit.Case, async: true

  alias Padmark.Parser.Options

  describe "add_deprecations/2" do
    test "returns the messages unchanged when nothing is deprecated" do
      assert Options.add_deprecations(%Options{}, []) == []
    end

    test "reports the smartypants option and clears it" do
      assert Options.add_deprecations(%Options{smartypants: true}, []) == [
               {:deprecated, 0,
                "The smartypants option has no effect anymore and will be removed in Padmark.Parser 1.5"}
             ]
    end

    test "reports the pedantic option and clears it" do
      assert Options.add_deprecations(%Options{pedantic: true}, []) == [
               {:deprecated, 0,
                "The pedantic option has no effect anymore and will be removed in Padmark.Parser 1.5"}
             ]
    end

    test "reports the timeout option and clears it" do
      assert Options.add_deprecations(%Options{timeout: 5000}, []) == [
               {:deprecated, 0,
                "The timeout option has no effect anymore and will be removed in Padmark.Parser 1.5"}
             ]
    end

    test "reports every deprecated option set at once" do
      messages = Options.add_deprecations(%Options{smartypants: true, pedantic: true}, [])
      assert length(messages) == 2
    end
  end

  describe "normalize/1" do
    test "leaves a nil annotations option untouched" do
      assert Options.normalize(%Options{annotations: nil}).annotations == nil
    end

    test "leaves an already compiled annotations regex untouched" do
      regex = ~r/x/
      assert Options.normalize(%Options{annotations: regex}).annotations == regex
    end

    test "compiles a string annotations option into a regex" do
      # compared by source: regexes compiled apart are not `==` on OTP 28 and later
      assert Regex.source(Options.normalize(%Options{annotations: "%%"}).annotations) ==
               Regex.source(~r{\A(.*)(%%.*)})
    end

    test "escapes regex-special characters in the annotations marker" do
      normalized = Options.normalize(%Options{annotations: "a.b"})

      assert Regex.run(normalized.annotations, "code a.b comment") == [
               "code a.b comment",
               "code ",
               "a.b comment"
             ]

      refute Regex.run(normalized.annotations, "code axb comment")
    end

    test "builds the struct from a keyword list first" do
      assert %Options{gfm: false} = Options.normalize(gfm: false)
    end

    test "expands all: true into the individual options it stands for" do
      normalized = Options.normalize(%Options{all: true})

      assert %Options{
               breaks: true,
               footnotes: true,
               gfm_tables: true,
               sub_sup: true,
               wikilinks: true
             } = normalized
    end

    test "leaves the individual options alone when all is not set" do
      normalized = Options.normalize(%Options{all: false})

      assert %Options{
               breaks: false,
               footnotes: false,
               gfm_tables: false,
               sub_sup: false,
               wikilinks: false
             } = normalized
    end

    test "keeps an empty messages MapSet as is" do
      assert Options.normalize(%Options{messages: MapSet.new()}).messages == MapSet.new()
    end

    test "replaces a non-MapSet messages value with a deprecation warning" do
      normalized = Options.normalize(%Options{messages: [some: :thing]})

      assert normalized.messages ==
               MapSet.new([
                 {:deprecated, 0,
                  "messages is an internal option that is ignored and will be removed from the API in v1.5"}
               ])
    end
  end
end
