#!/bin/bash

set -ex

mkdir -p build
cd build

mkdir -p $PREFIX/include

export EMSDK_PATH=${EMSCRIPTEN_FORGE_EMSDK_DIR}
export LDFLAGS="$LDFLAGS -fno-optimize-sibling-calls"
export FFLAGS="$FFLAGS \
    --target=wasm32-unknown-emscripten \
    --generate-object-code \
    --fixed-form-infer \
    --implicit-interface"

# CMAKE_INSTALL_LIBDIR="lib" suppresses CentOS default of lib64 (conda expects lib)

# See https://github.com/Shaikh-Ubaid/lapack/blob/lf_01/LF_README.md
emcmake cmake .. \
    -DCMAKE_Fortran_COMPILER=lfortran \
    -DTEST_FORTRAN_COMPILER=OFF \
    -DCBLAS=no \
    -DLAPACKE=no \
    -DBUILD_TESTING=no \
    -DBUILD_DOUBLE=no \
    -DBUILD_COMPLEX=no \
    -DBUILD_COMPLEX16=no \
    -DLAPACKE_WITH_TMG=no \
    -DCMAKE_Fortran_PREPROCESS=yes \
    -DCMAKE_Fortran_FLAGS="$FFLAGS" \
    -DCMAKE_INSTALL_LIBDIR="lib" \
    -DCMAKE_INSTALL_PREFIX=$PREFIX

# emcmake cmake \
#   -DCMAKE_INSTALL_PREFIX=${PREFIX} \
#   -DCMAKE_INSTALL_LIBDIR="lib" \
#   -DBUILD_TESTING=ON \
#   -DBUILD_SHARED_LIBS=OFF \
#   -DLAPACKE=ON \
#   -DCBLAS=ON \
#   -DBUILD_DEPRECATED=ON \
#   -DTEST_FORTRAN_COMPILER=OFF \
#   ${CMAKE_ARGS} ..

make install -j${CPU_COUNT} VERBOSE=1
