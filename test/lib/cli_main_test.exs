defmodule Earmark.Cli.MainTest do
  use ExUnit.Case, async: true

  import ExUnit.CaptureIO

  describe "main/1" do
    test "prints the rendered HTML to stdout for a valid file" do
      out = capture_io(fn -> Earmark.Cli.main(["test/fixtures/short1.md"]) end)
      assert out == "<h1>\nHeadline1</h1>\n<hr class=\"thin\">\n<h2>\nHeadline2</h2>\n\n"
    end

    test "prints the error to stderr and exits with 1 for a missing file" do
      result =
        capture_io(:stderr, fn ->
          outcome =
            try do
              Earmark.Cli.main(["no-such-file.md"])
              :did_not_exit
            catch
              :exit, reason -> {:exited, reason}
            end

          send(self(), {:outcome, outcome})
        end)

      assert_received {:outcome, {:exited, 1}}
      assert result == "Cannot open no-such-file.md, reason: enoent\n"
    end
  end
end
