#!/bin/bash

set -ex

mkdir build
cd build

mkdir -p ${PREFIX}/include

export LDFLAGS="$LDFLAGS -fno-optimize-sibling-calls"
export FFLAGS="$FFLAGS -fno-optimize-sibling-calls"

# CMAKE_INSTALL_LIBDIR="lib" suppresses CentOS default of lib64 (conda expects lib)

emcmake cmake \
  -DCMAKE_INSTALL_PREFIX=${PREFIX} \
  -DCMAKE_INSTALL_LIBDIR="lib" \
  -DBUILD_TESTING=ON \
  -DBUILD_SHARED_LIBS=OFF \
  -DLAPACKE=ON \
  -DCBLAS=ON \
  -DBUILD_DEPRECATED=ON \
  -DTEST_FORTRAN_COMPILER=OFF \
  ${CMAKE_ARGS} ..

make install -j${CPU_COUNT} VERBOSE=1
