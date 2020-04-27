#!/bin/bash

# Register test here
TESTS=(
    "mimuw" \
    "mimuw-onlyget" \
    "mimuw-onlyanchor" \
    "mimuw-ssl" \
    "mimuw-notrailingslash" \
    "mimuw-notrailingslash-onlyget" \
    "mimuw-notrailingslash-onlyanchor" \
    "mimuw-notrailingslash-ssl" \
    "neverssl" \
    "neverssl-ssl" \
    "chunked-image" \
    "zbyszek-lisp"
)

print_usage_and_die() {
    echo >&2 "Usage: $0 <testhttp-path>"
    exit 1
}

# Change working directory to script location
SCRIPT_PATH="$(cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd)"
cd "${SCRIPT_PATH}"

# Test parameter count
if [ "$#" -lt 1 ]; then
    echo >&2 "Error: Parameter count too low"
    print_usage_and_die
fi

PROGRAM=$(readlink -f "$1")
TESTS_DIR="${SCRIPT_PATH}/tests"
OUTPUTS_DIR="${SCRIPT_PATH}/outputs"

mkdir -p "${OUTPUTS_DIR}"
rm -rf "${OUTPUTS_DIR}/*"

# Generate outputs
for test in "${TESTS[@]}"
do
   echo "Running ${test}..."
   xargs --arg-file="${TESTS_DIR}/${test}.args" "${PROGRAM}" 1> "${OUTPUTS_DIR}/${test}.out"
   xargs_exitcode=$?
   echo "${xargs_exitcode}" > "${OUTPUTS_DIR}/${test}.xargs-exitcode"
done
