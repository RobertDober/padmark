%Doctor.Config{
  # @moduledoc false already, same as the vendored parser: internal CLI
  # message formatting, not part of the public API.
  ignore_modules: [Padmark.Message],
  # The vendored parser is intentionally @moduledoc false throughout: it is
  # internal implementation, not part of the public API documented in the
  # README, so it is exempt from per-function doc/spec requirements here.
  ignore_paths: [~r{^lib/padmark_parser/}, ~r{^test/support/}],
  min_module_doc_coverage: 40,
  min_module_spec_coverage: 0,
  min_overall_doc_coverage: 50,
  min_overall_moduledoc_coverage: 100,
  min_overall_spec_coverage: 0,
  exception_moduledoc_required: true,
  raise: false,
  reporter: Doctor.Reporters.Full,
  struct_type_spec_required: true,
  umbrella: false,
  failed: false
}