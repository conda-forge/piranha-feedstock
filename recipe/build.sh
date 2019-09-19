#!/usr/bin/env bash

mkdir build
cd build

# NOTE: there might be undefined references occurring
# in the Boost.system library, depending on the C++ versions
# used to compile Boost and/or the piranha examples. We
# can avoid them by forcing the use of the header-only
# version of the library.
export CXXFLAGS="$CXXFLAGS -DBOOST_ERROR_CODE_HEADER_ONLY"

if [[ "$(uname)" != "Darwin" ]]; then
    LDFLAGS="-lrt ${LDFLAGS}"
fi

cmake \
    -DCMAKE_BUILD_TYPE=Release \
    -DCMAKE_INSTALL_PREFIX=$PREFIX \
    -DCMAKE_PREFIX_PATH=$PREFIX \
    -DPIRANHA_WITH_BZIP2=yes \
    -DPIRANHA_WITH_ZLIB=yes  \
    -DBUILD_TESTS=yes \
    -DBoost_NO_BOOST_CMAKE=ON \
    ${SRC_DIR}
make

if [ "$(uname)" == "Darwin" ]
then
    ctest -E "gastineau|pearce2_unpacked|s11n_perf" -V;
else
    ctest -E "gastineau|pearce2_unpacked" -V;
fi

make install
