#!/bin/bash

set -ex

export CFLAGS="$CFLAGS -fPIC"
export LDFLAGS="$LDFLAGS -sALLOW_MEMORY_GROWTH=1 -sSTACK_SIZE=1MB"

# Bug: there is no symlink to emcc.py
if [ ! -f $BUILD_PREFIX/bin/emcc.py ]; then
    echo "Creating symlink to emcc.py"
    ln -s $BUILD_PREFIX/opt/emsdk/upstream/emscripten/emcc.py $BUILD_PREFIX/bin/emcc.py
fi

meson_setup_args=(
    -Ddocs=false
    -Dtests=false
    -Ddefault_library=static
)

meson setup builddir \
    ${meson_setup_args[@]} \
    --prefix=$PREFIX \
    --buildtype=release \
    --prefer-static \
    --cross-file=$RECIPE_DIR/emscripten.meson.cross

meson install -C builddir
