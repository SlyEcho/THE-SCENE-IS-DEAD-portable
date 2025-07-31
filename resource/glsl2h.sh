#!/bin/bash
set -e

printf "#include <string>\n\n"

for i in $@; do
    NAME="$(basename ${i%?????})"
    CAPITALNAME="${NAME^^}"
    SOURCE="$(cat ${i})"

    printf "std::string %s = R\"(\n%s\n)\";\n\n" \
        "${CAPITALNAME}" \
        "${SOURCE}"
done
