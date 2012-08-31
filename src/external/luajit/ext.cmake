### Luajit ###

# Defines
set(EXT_NAME LUAJIT)
option(USE_SYSTEM_${EXT_NAME} "libuv system libs" 1)
set(EXT_DIR luajit)

# this is for non system lib build
set(EXT_URL ${CMAKE_SOURCE_DIR}/tarballs/LuaJIT-2.0.0-beta10.tar.gz)
set(EXT_MD5 ed66689b96f7ad7bfeffe0b4ff2d63d4)

set(EXT_LINK_LIB libluajit.a)

luavit_add_ext(${EXT_NAME} external ${EXT_DIR} ${EXT_URL} ${EXT_MD5} ${EXT_LINK_LIB} src)
#include_directories()
set(LUAJIT_LIBRARIES ${SOURCE_DIR}/libluajit.a)
set(LUAJIT_INCLUDE_DIR ${SOURCE_DIR}/src)
set(LUAJIT_BIN ${SOURCE_DIR}/luajit)
#file(MAKE_DIRECTORY ${CMAKE_BINARY_DIR}/jit)
add_custom_command(OUTPUT JIT
  COMMAND ${CMAKE_COMMAND} -E copy_directory ${SOURCE_DIR}/lib ${CMAKE_BINARY_DIR}/jit
  DEPENDS LUAJIT
)
