#!/bin/bash
set -e

RESOURCE_DIR=$(dirname "$0")
SHADER_HEADER="${RESOURCE_DIR}/shaders.h"

[ -f "${SHADER_HEADER}" ] && exit 0

echo -e "#include <string>" >> ${SHADER_HEADER}

for i in $(ls ${RESOURCE_DIR}/*.glsl)
do
    NAME="$(basename ${i%?????})"
    CAPITALNAME="${NAME^^}"
    SOURCE="$(cat ${i})"

    echo -e "std::string ${CAPITALNAME} = R\"(\n${SOURCE}\n)\";" >> ${SHADER_HEADER}
done
