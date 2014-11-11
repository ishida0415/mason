#!/usr/bin/env bash

MASON_NAME=libpng
MASON_VERSION=1.6.13
MASON_LIB_FILE=lib/libpng.a
MASON_PKGCONFIG_FILE=lib/pkgconfig/libpng.pc

. ${MASON_DIR:-~/.mason}/mason.sh

function mason_load_source {
    mason_download \
        http://prdownloads.sourceforge.net/libpng/libpng-1.6.13.tar.gz?download \
        7e0365a970f8c032f8b6dcedcca77e041f149fe6

    mason_extract_tar_gz

    export MASON_BUILD_PATH=${MASON_ROOT}/.build/libpng-${MASON_VERSION}
}

function mason_compile {
    CFLAGS="-fPIC" ./configure \
        --prefix=${MASON_PREFIX} \
        ${MASON_HOST_ARG} \
        --enable-static \
        --with-pic \
        --disable-shared \
        --disable-dependency-tracking

    make install -j${MASON_CONCURRENCY}
}

function mason_strip_ldflags {
    shift # -L...
    shift # -lpng16
    echo "$@"
}

function mason_ldflags {
    mason_strip_ldflags $(`mason_pkgconfig` --static --libs)
}

function mason_clean {
    make clean
}

mason_run "$@"
