load("@rules_foreign_cc//foreign_cc:repositories.bzl", "rules_foreign_cc_dependencies")
load("@com_github_nelhage_rules_boost//:boost/boost.bzl", "boost_deps")
load("@bazel_tools//tools/build_defs/repo:http.bzl", "http_archive")
load("@bazel_tools//tools/build_defs/repo:git.bzl", "new_git_repository")

def cryptoTools_deps(repo_reference = ""):
  reference_index = ""
  if repo_reference:
      reference_index = "@{}".format(repo_reference)

  if "toolkit_relic" not in native.existing_rules():
    new_git_repository(
      name = "toolkit_relic",
      build_file = "{}//bazel:BUILD.relic".format(reference_index),
      remote = "https://gitee.com/orzmzp/relic.git",
      commit = "3f616ad64c3e63039277b8c90915607b6a2c504c",
      shallow_since = "1581106153 -0800",
    )

  rules_foreign_cc_dependencies()
  #deps boost
  boost_deps()
