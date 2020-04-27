#!/bin/bash

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
TMP_DIR=$(mktemp -d -t "testhttp"-XXXXXXXXXX)

BOLD_REGULAR='\033[1m'
BOLD_GREEN='\033[1;32m'
BOLD_RED='\033[1;31m'
COLOR_RESET='\033[0m'

# Return code
RC=0

echo "Program path: ${PROGRAM}"
echo "Using tests folder: ${TESTS_DIR}"
echo "Using temporary folder: ${TMP_DIR}"

NAME_PATTERN="*"
if [ "$#" -ge 2 ]; then
    NAME_PATTERN="$2"
fi

for test in `find "${TESTS_DIR}" -type f -name "${NAME_PATTERN}.args" ! -name '#*'`; do
    basename=$(basename "$test" .args)
    echo -ne "${BOLD_REGULAR}[TEST]${COLOR_RESET} $basename.args "

    # Run test
    start_time=`date +%s%3N`
    xargs --arg-file="${TESTS_DIR}/${basename}.args" "${PROGRAM}" 1> "${TMP_DIR}/${basename}.out" 2> "${TMP_DIR}/${basename}.err"
    xargs_exitcode=$?
    end_time=`date +%s%3N`

    # Diff stdout
    diff "${TMP_DIR}/${basename}.out" "${OUTPUTS_DIR}/${basename}.out" 1>/dev/null
    diff_out_exitcode=$?

    # Diff xargs exitcode
    echo "${xargs_exitcode}" | diff --ignore-blank-lines "${OUTPUTS_DIR}/${basename}.xargs-exitcode" - 1>/dev/null
    diff_xargs_exitcode=$?

    # Print info message
    if [ "$xargs_exitcode" -eq 0 ] && [ -s "${TMP_DIR}/${basename}.err" ]
    then
        RC=1
        printf "${BOLD_RED}[ ERROR: exitcode 0, but .err not empty ]${COLOR_RESET}\n"
    elif [ $diff_xargs_exitcode -ne 0 ]
    then
        RC=1
        printf "${BOLD_RED}[ ERROR: wrong xargs exitcode: $xargs_exitcode ]${COLOR_RESET}\n"
    elif [ $diff_out_exitcode -ne 0 ]
    then
        RC=1
        printf "${BOLD_RED}[ ERROR: ${basename}.out: files different ]${COLOR_RESET}\n"
        diff "${TMP_DIR}/${basename}.out" "${OUTPUTS_DIR}/${basename}.out"
    else
        printf "${BOLD_GREEN}[ OK ]${COLOR_RESET} ($(expr $end_time - $start_time) ms)\n"
    fi
    
done

# Remove temporary folder if all tests passing
if [ "$RC" -ne 0 ]; then
    printf "Keeping temporary folder: ${TMP_DIR}\n"
else
    printf "Removing temporary folder: ${TMP_DIR}\n"
    rm -rf "${TMP_DIR}"
fi

exit ${RC}
