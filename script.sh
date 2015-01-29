#!/usr/bin/env bash

MASON_NAME=zlib
MASON_VERSION=system
MASON_SYSTEM_PACKAGE=true

. ${MASON_DIR:-~/.mason}/mason.sh

function mason_load_source {
    :
}

function mason_system_version {
    mkdir -p "${MASON_PREFIX}"
    cd "${MASON_PREFIX}"
    if [ ! -f version ]; then
        echo "#include <zlib.h>
#include <stdio.h>
#include <assert.h>
int main() {
    assert(ZLIB_VERSION[0] == zlibVersion()[0]);
    printf(\"%s\", ZLIB_VERSION);
    return 0;
}
" > version.c && cc version.c $(mason_cflags) $(mason_ldflags) -o version
    fi
    ./version
}

function mason_compile {
if [[ ${MASON_PLATFORM} = 'osx' || ${MASON_PLATFORM} = 'ios' ]]; then
    MASON_HEADER_FILE="${MASON_SDK_PATH}/usr/include/zlib.h"
    if [ ! -f "${MASON_HEADER_FILE}" ]; then
        mason_error "Can't find header file ${MASON_HEADER_FILE}"
        exit 1
    fi

    MASON_LIBRARY_FILE="${MASON_SDK_PATH}/usr/lib/libz.dylib"
    if [ ! -f "${MASON_LIBRARY_FILE}" ]; then
        mason_error "Can't find library file ${MASON_LIBRARY_FILE}"
        exit 1
    fi
    mkdir -p ${MASON_PREFIX}/lib/
    mkdir -p ${MASON_PREFIX}/include/
    ln -s ${MASON_SDK_PATH}/usr/include/zlib.h ${MASON_PREFIX}/include/zlib.h
    ln -s ${MASON_SDK_PATH}/usr/include/zconf.h ${MASON_PREFIX}/include/zconf.h
    ln -s ${MASON_SDK_PATH}/usr/lib/libz.dylib ${MASON_PREFIX}/lib/libz.dylib
    MASON_CFLAGS="-I${MASON_PREFIX}/include/"
    MASON_LDFLAGS="-L${MASON_PREFIX}/lib -lz"
elif [[ ${MASON_PLATFORM} = 'android' ]]; then
    MASON_HEADER_FILE="${MASON_SDK_PATH}/usr/include/zlib.h"
    if [ ! -f "${MASON_HEADER_FILE}" ]; then
        mason_error "Can't find header file ${MASON_HEADER_FILE}"
        exit 1
    fi

    MASON_LIBRARY_FILE="${MASON_SDK_PATH}/usr/lib/libz.so"
    if [ ! -f "${MASON_LIBRARY_FILE}" ]; then
        mason_error "Can't find library file ${MASON_LIBRARY_FILE}"
        exit 1
    fi

    ln -s ${MASON_SDK_PATH}/usr/include/zlib.h ${MASON_PREFIX}/include/zlib.h
    ln -s ${MASON_SDK_PATH}/usr/include/zconf.h ${MASON_PREFIX}/include/zconf.h
    ln -s ${MASON_SDK_PATH}/usr/lib/libz.dylib ${MASON_PREFIX}/lib/libz.dylib
    MASON_CFLAGS="-I${MASON_PREFIX}/include/"
    MASON_LDFLAGS="-L${MASON_PREFIX}/lib -lz"
elif [[ -d /usr/include/zlib.h ]] && [[ -d /usr/include/zconf.h ]]; then
    mkdir -p ${MASON_PREFIX}/lib/
    mkdir -p ${MASON_PREFIX}/include/
    ln -s /usr/include/zlib.h ${MASON_PREFIX}/include/zlib.h
    ln -s /usr/include/zconf.h ${MASON_PREFIX}/include/zconf.h
    ln -s /usr/lib/libz.so ${MASON_PREFIX}/lib/libz.so
    MASON_CFLAGS="-I${MASON_PREFIX}/include/"
    MASON_LDFLAGS="-L${MASON_PREFIX}/lib -lz"
else
    MASON_CFLAGS=`pkg-config zlib --cflags`
    MASON_LDFLAGS=`pkg-config zlib --libs`
fi
}

function mason_cflags {
    echo ${MASON_CFLAGS}
}

function mason_ldflags {
    echo ${MASON_LDFLAGS}
}

mason_run "$@"
