load("@build_bazel_rules_nodejs//:providers.bzl", "JSModuleInfo")

def _js_outputs(ctx):
  files_depsets = []
  for dep in ctx.attr.deps:
    files_depsets.append(dep[JSModuleInfo].direct_sources)
  return [
    DefaultInfo(
      files = depset(transitive = files_depsets)
    )
  ]

js_outputs = rule(
    implementation = _js_outputs,
    attrs = {
        "deps": attr.label_list(providers = [JSModuleInfo]),
    },
)
