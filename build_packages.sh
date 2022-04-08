#!/bin/bash
set -e

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )


BUILD_NAME=$1
SKIP=$2
PKG_NAMES=($(python build_all_helper.py $BUILD_NAME 0 | tr -d '[],'))
BUILD_OR_HOST=($(python build_all_helper.py $BUILD_NAME 1 | tr -d '[],'))


for i in "${!PKG_NAMES[@]}"; do
    PKG_NAME=${PKG_NAMES[i]}


    if [[ ${BUILD_OR_HOST[i]} == "build" ]]; then
        boa build recipes/$PKG_NAME  $SKIP
    else
        boa build recipes/$PKG_NAME --target-platform=emscripten-32  $SKIP
        python browser_test_package.py $SCRIPT_DIR/recipes/$PKG_NAME
        python better_test_package.py $SCRIPT_DIR/recipes/$PKG_NAME
    fi
done