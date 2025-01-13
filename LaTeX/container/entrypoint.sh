#!/usr/bin/env bash
set -euxo pipefail

cd "$INPUT_SUBDIRECTORY"
make "$INPUT_MAKE"
