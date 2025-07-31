#!/bin/bash
set -e

printf "#include <string_view>\n\n"

for i in $@; do
    NAME="$(basename ${i%?????})"
    CAPITALNAME="${NAME^^}"
    SOURCE="$(cat ${i})"

    printf "const std::string_view %s = R\"(\n%s\n)\";\n\n" \
        "${CAPITALNAME}" \
        "${SOURCE}"
done
