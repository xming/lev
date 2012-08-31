### libuv ###

# Defines
set(EXT_NAME UV)
option(USE_SYSTEM_${EXT_NAME} "libuv system libs" 1)
set(EXT_DIR libuv)

# this is for non system lib build
#set(EXT_URL ${CMAKE_SOURCE_DIR}/tarballs/uv.tar.bz2)
set(EXT_URL ${CMAKE_SOURCE_DIR}/tarballs/joyent-libuv-node-v0.8.3-0-g94355e4.tar.gz)
set(EXT_MD5 18b11792fc407911e699e6b60d4c0837)

set(EXT_LINK_LIB libuv.a)

luavit_add_ext(${EXT_NAME} external ${EXT_DIR} ${EXT_URL} ${EXT_MD5} ${EXT_LINK_LIB} include)
include_directories()
