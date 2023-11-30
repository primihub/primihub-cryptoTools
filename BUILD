package(default_visibility = ["//visibility:public"])

config_setting(
  name = "enable_sse",
  values = {"define": "cpu_arch=x86_64"},
)

GEN_CONFIG_H_CMD = select({
  "enable_sse": (
    """
      set -x
      tmpdir="cryptoTools.tmp"
      mkdir -p "$${tmpdir}/src/cryptoTools/Common"
      echo "#pragma once \r\n \
    #define ENABLE_RELIC ON \r\n \
    #define ENABLE_CIRCUITS ON \r\n \
    #define ENABLE_SPAN_LITE ON \r\n \
    #define ENABLE_CPP_14 ON \r\n \
    #define ENABLE_BOOST ON \r\n \
    #define ENABLE_CPP_14 ON \r\n \
    #define ENABLE_SSE ON \r\n \
    #define ENABLE_NET_LOG ON \r\n \
    #define ENABLE_NASM ON \r\n \
    #if (defined(_MSC_VER) || defined(__SSE2__)) && defined(ENABLE_SSE) \r\n \
    #define ENABLE_SSE_BLAKE2 ON \r\n \
    #define OC_ENABLE_SSE2 ON \r\n \
    #endif \r\n \
    #if (defined(_MSC_VER) || defined(__PCLMUL__)) && defined(ENABLE_SSE) \r\n \
    #define OC_ENABLE_PCLMUL \r\n \
    #endif \r\n \
    #if (defined(_MSC_VER) || defined(__AES__)) && defined(ENABLE_SSE) \r\n \
    #define OC_ENABLE_AESNI ON \r\n \
    #else \r\n \
    #define OC_ENABLE_PORTABLE_AES OFF \r\n \
    #endif \r\n \
    ">"$${tmpdir}"/src/cryptoTools/Common/config.h
        ls -ltrh "$${tmpdir}"
        mv "$${tmpdir}"/src/cryptoTools/Common/config.h $(location src/cryptoTools/Common/config.h)
        rm -r -f -- "$${tmpdir}"
    """),
  "//conditions:default": (
    """
      set -x
      tmpdir="cryptoTools.tmp"
      mkdir -p "$${tmpdir}/src/cryptoTools/Common"
      echo "#pragma once \r\n \
    #define ENABLE_RELIC ON \r\n \
    #define ENABLE_CIRCUITS ON \r\n \
    #define ENABLE_SPAN_LITE ON \r\n \
    #define ENABLE_CPP_14 ON \r\n \
    #define ENABLE_BOOST ON \r\n \
    #define ENABLE_CPP_14 ON \r\n \
    #define ENABLE_NET_LOG ON \r\n \
    #define ENABLE_NASM ON \r\n \
    #if (defined(_MSC_VER) || defined(__SSE2__)) && defined(ENABLE_SSE) \r\n \
    #define ENABLE_SSE_BLAKE2 ON \r\n \
    #define OC_ENABLE_SSE2 ON \r\n \
    #endif \r\n \
    #if (defined(_MSC_VER) || defined(__PCLMUL__)) && defined(ENABLE_SSE) \r\n \
    #define OC_ENABLE_PCLMUL \r\n \
    #endif \r\n \
    #if (defined(_MSC_VER) || defined(__AES__)) && defined(ENABLE_SSE) \r\n \
    #define OC_ENABLE_AESNI ON \r\n \
    #else \r\n \
    #define OC_ENABLE_PORTABLE_AES OFF \r\n \
    #endif \r\n \
    ">"$${tmpdir}"/src/cryptoTools/Common/config.h
        ls -ltrh "$${tmpdir}"
        mv "$${tmpdir}"/src/cryptoTools/Common/config.h $(location src/cryptoTools/Common/config.h)
        rm -r -f -- "$${tmpdir}"
    """),
})

genrule(
  name = "cryptoTools_config_h",
  outs = [
    "src/cryptoTools/Common/config.h",
  ],
  cmd = GEN_CONFIG_H_CMD,
  visibility = ["//visibility:public"],
)


ENABLE_SSE_COPT = select({
  "enable_sse": [
    "-DENABLE_SSE=ON",
    "-maes",
    "-msse2",
    "-msse3",
    "-msse4.1",
    "-mpclmul",
  ],
  "//conditions:default": []
})

ENABLE_RELIC_COPT = [
  #"-I@toolkit_relic//:relic/include",
  "-DENABLE_RELIC=ON",
]

ENABLE_RELIC_DEPS = [
  "@toolkit_relic//:relic",
]

DEFAULT_C_OPT = ENABLE_SSE_COPT + ENABLE_RELIC_COPT
DEFAILT_LINK_OPT = ENABLE_RELIC_DEPS
cc_library(
  name = "crypto_tools_gsl",
  hdrs = glob(["src/cryptoTools/gsl/*"]),
  deps = []
)

cc_library(
  name = "libcryptoTools",
  srcs = glob([
    "src/cryptoTools/Circuit/*.cpp",
    "src/cryptoTools/Common/*.cpp",
    "src/cryptoTools/Crypto/*.cpp",
    "src/cryptoTools/Crypto/blake2/c/*.c",
    "src/cryptoTools/Crypto/blake2/sse/*.c",
    "src/cryptoTools/Network/*.cpp"],
  ),
  hdrs = [":cryptoTools_config_h"] +
    glob([
      "src/cryptoTools/Circuit/*.h",
      "src/cryptoTools/Common/*.h",
      "src/cryptoTools/Common/*.hpp",
      "src/cryptoTools/Crypto/*.h",
      "src/cryptoTools/Crypto/blake2/c/*.h",
      "src/cryptoTools/Crypto/blake2/sse/*.h",
      "src/cryptoTools/Network/*.h"],
    ),
  includes = [
    ":cryptoTools_config_h"
  ],
  copts = [
    "-Wall",
    "-O0 -g -ggdb -rdynamic",
    "-DENABLE_CIRCUITS=ON",
    "-DENABLE_BOOST=ON",
    "-DRAND=HASHD",
    "-DMULTI=PTHREAD",
    "-DBoost_USE_MULTITHREADED=ON",
  ] + DEFAULT_C_OPT,
  linkopts = ["-pthread"],
  # strip_include_prefix = "src",
  # Using an empty include_prefix causes Bazel to emit -I instead of -iquote
  # options for the include directory, so that #include <gmp.h> works.
  include_prefix = "",
  linkstatic = True,
  deps = [
    ":crypto_tools_gsl",
    "@boost//:fiber",
    "@boost//:asio",
    "@boost//:variant",
    "@boost//:multiprecision",
    "@boost//:system",
    "@boost//:circular_buffer",
    "@github_com_span_lite//:span_lite",
  ] + DEFAILT_LINK_OPT,
)

cc_library(
  name = "tests_cryptoTools",
  srcs = glob([
      "tests_cryptoTools/**/*.cpp"
    ],
  ),
  hdrs = glob([
    "tests_cryptoTools/**/*.h"
    ]),
  copts = [
    " -O0 -g -ggdb -rdynamic",
    "-DENABLE_CIRCUITS=ON",
    "-DENABLE_BOOST=ON",
    "-DBoost_USE_MULTITHREADED=ON"
  ] + DEFAULT_C_OPT,
  linkopts = ["-pthread"],
  linkstatic = True,
  deps = [
    ":libcryptoTools",
  ] + DEFAILT_LINK_OPT,
)

cc_library(
  name = "lib_frontend_cryptoTools",
  srcs = glob([
    "frontend_cryptoTools/**/*.cpp"
    ],
    exclude = [
      "frontend_cryptoTools/cuckoo/cuckooTests.cpp",
      "frontend_cryptoTools/main.cpp",
    ],
  ),
  hdrs = glob([
      "frontend_cryptoTools/**/*.h"
    ],
    exclude = [],
  ),
  copts = [
    " -O0 -g -ggdb -rdynamic",
    "-DENABLE_CIRCUITS=ON",
    "-DENABLE_BOOST=ON",
    "-DBoost_USE_MULTITHREADED=ON",
    "-DENABLE_FULL_GSL=ON",
  ] + DEFAULT_C_OPT,
  linkopts = ["-pthread -lstdc++"],
  linkstatic = True,
  deps = [
    ":libcryptoTools",
    ":tests_cryptoTools",
  ] + DEFAILT_LINK_OPT,
)

cc_binary(
  name = "frontend_cryptoTools",
  srcs = glob([
    "frontend_cryptoTools/main.cpp",
  ]),
  copts = [
    "-O0 -g -ggdb -rdynamic",
    "-DENABLE_CIRCUITS=ON",
    "-DENABLE_BOOST=ON",
  ] + ENABLE_SSE_COPT + ENABLE_RELIC_COPT,
  linkopts = ["-pthread -lstdc++"],
  linkstatic = False,
  deps = [
    ":lib_frontend_cryptoTools",
    ":libcryptoTools",
    ":tests_cryptoTools",
  ] + DEFAILT_LINK_OPT,
)

