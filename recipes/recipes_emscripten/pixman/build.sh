# Bug: there is no symlink to emcc.py
if [ ! -f $BUILD_PREFIX/bin/emcc.py ]; then
    echo "Creating symlink to emcc.py"
    ln -s $BUILD_PREFIX/opt/emsdk/upstream/emscripten/emcc.py $BUILD_PREFIX/bin/emcc.py
fi

meson_config_args=(
    -Ddemos=disabled
    -Dtests=disabled
)

meson setup builddir \
    ${MESON_ARGS} \
    "${meson_config_args[@]}" \
    --buildtype=release \
    --default-library=static \
    --prefix=$PREFIX \
    -Dlibdir=lib \
    --wrap-mode=nofallback \
    --cross-file=$RECIPE_DIR/emscripten.meson.cross

ninja -v -C builddir -j ${CPU_COUNT}
ninja -C builddir install -j ${CPU_COUNT}