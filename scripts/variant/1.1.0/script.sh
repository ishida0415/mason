#!/usr/bin/env bash

MASON_NAME=variant
MASON_VERSION=1.1.0
MASON_HEADER_ONLY=true

. ${MASON_DIR:-~/.mason}/mason.sh

function mason_load_source {
    mason_download \
    https://github.com/mapbox/variant/archive/v1.1.0.tar.gz \
    cd61bc7ad50429875c7a5deb80611f97d87a8fe0
    mason_extract_tar_gz

    export MASON_BUILD_PATH=${MASON_ROOT}/.build/variant-${MASON_VERSION}
}

function mason_compile {
    mkdir -p ${MASON_PREFIX}/include/mapbox
    cp -v *.hpp ${MASON_PREFIX}/include/mapbox
    cp -v README.md LICENSE ${MASON_PREFIX}
}

function mason_cflags {
    echo -isystem ${MASON_PREFIX}/include -I${MASON_PREFIX}/include
}

function mason_ldflags {
    :
}

function mason_static_libs {
    :
}

mason_run "$@"
