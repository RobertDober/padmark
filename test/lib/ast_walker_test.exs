defmodule Padmark.Parser.Ast.Renderer.AstWalkerTest do
  use ExUnit.Case, async: true

  alias Padmark.Parser.Ast.Renderer.AstWalker

  describe "walk_ast/2" do
    test "returns an empty list for an empty list" do
      assert AstWalker.walk_ast([], &String.upcase/1) == []
    end

    test "accepts a bare string, not just a list" do
      assert AstWalker.walk_ast("hello", &String.upcase/1) == ["HELLO"]
    end

    test "drops a string leaf when the function returns an empty list" do
      assert AstWalker.walk_ast(["hello"], fn _ -> [] end) == []
    end

    test "splices a string leaf into several elements when the function returns a list" do
      assert AstWalker.walk_ast(["hello world"], &String.split(&1, " ")) == ["hello", "world"]
    end

    test "replaces a string leaf one for one when the function returns a bare value" do
      assert AstWalker.walk_ast(["hello"], &String.upcase/1) == ["HELLO"]
    end

    test "recurses into a tag tuple's content, keeping tag, attributes and meta" do
      ast = [{"em", [{"class", "x"}], ["hi"], %{some: :meta}}]

      assert AstWalker.walk_ast(ast, &String.upcase/1) == [
               {"em", [{"class", "x"}], ["HI"], %{some: :meta}}
             ]
    end

    test "recurses into a nested list independently" do
      assert AstWalker.walk_ast([["a", "b"]], &String.upcase/1) == [["A", "B"]]
    end

    test "keeps non-string nodes untouched while transforming strings around them" do
      br = {"br", [], [], %{}}
      assert AstWalker.walk_ast(["a", br, "b"], &String.upcase/1) == ["A", br, "B"]
    end

    test "raises for a node that is neither a string, a tag tuple nor a list" do
      assert_raise FunctionClauseError, fn ->
        AstWalker.walk_ast([:not_a_valid_node], & &1)
      end
    end
  end
end
