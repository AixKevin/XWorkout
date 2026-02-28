#!/usr/bin/env bash

# shell-agnostic root detection for sourced usage
if [ -n "${BASH_SOURCE:-}" ]; then
  _SCRIPT_PATH="${BASH_SOURCE[0]}"
elif [ -n "${ZSH_VERSION:-}" ]; then
  _SCRIPT_PATH="${(%):-%N}"
else
  _SCRIPT_PATH="$0"
fi

ROOT_DIR="$(cd "$(dirname "$_SCRIPT_PATH")/.." && pwd)"
JAVA_BIN="$(readlink -f /usr/bin/java)"
JAVA_HOME="${JAVA_BIN%/bin/java}"

export JAVA_HOME
export FLUTTER_ROOT="$ROOT_DIR/.toolchain/flutter"
export ANDROID_SDK_ROOT="$ROOT_DIR/.android-sdk"
export ANDROID_HOME="$ANDROID_SDK_ROOT"
export PUB_CACHE="$ROOT_DIR/.pub-cache"
export PATH="$FLUTTER_ROOT/bin:$ANDROID_SDK_ROOT/platform-tools:$ANDROID_SDK_ROOT/cmdline-tools/latest/bin:$PATH"
