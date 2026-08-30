#!/usr/bin/env bash
# Idempotent bootstrap for the algorithm-journey repository.
#
# This project is a large collection of standalone Java teaching programs under
# src/classNNN. There is no third-party dependency and no build tool; the only
# requirement is a JDK. This script verifies the toolchain and compiles every
# source file into ./out so that any program can be run directly, e.g.:
#
#     java -cp out class005.Validator
#
# It is safe to run repeatedly: ./out is fully rebuilt each time.
set -euo pipefail

cd "$(dirname "$0")/.."

echo "== Toolchain =="
java -version
javac -version

echo "== Compiling all Java sources into ./out =="
rm -rf out
mkdir -p out

# Collect every source file. Using a file list keeps the command line short
# regardless of how many files the repository grows to contain.
SOURCES_LIST="$(mktemp)"
trap 'rm -f "$SOURCES_LIST"' EXIT
find src -name '*.java' > "$SOURCES_LIST"

FILE_COUNT="$(wc -l < "$SOURCES_LIST" | tr -d ' ')"
echo "Found ${FILE_COUNT} Java files."

javac -encoding UTF-8 -d out "@$SOURCES_LIST"

echo "== Done: compiled ${FILE_COUNT} files into ./out =="
