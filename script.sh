#!/usr/bin/env bash

MASON_NAME=nunicode
MASON_VERSION=1.5.1
MASON_LIB_FILE=lib/libnu.a
MASON_PKGCONFIG_FILE=lib/pkgconfig/nu.pc

. ${MASON_DIR:-~/.mason}/mason.sh

function mason_load_source {
    mason_download \
    https://bitbucket.org/alekseyt/nunicode/get/1.5.1.tar.bz2 \
    d85a6cd2d779db3503034762f56fd094ea6f5def
    mason_extract_tar_bz2

    export MASON_BUILD_PATH=${MASON_ROOT}/.build/alekseyt-nunicode-01c8e4ebc740
}

function mason_compile {
    mkdir -p build-dir
    cd build-dir
    cmake .. -DCMAKE_BUILD_TYPE=RELEASE -DCMAKE_INSTALL_PREFIX=${MASON_PREFIX}
    make
    make install
}

function mason_cflags {
    echo -I${MASON_PREFIX}/include
}

function mason_ldflags {
    echo -L${MASON_PREFIX}/lib -lnu
}

function mason_clean {
    make clean
}

mason_run "$@"
