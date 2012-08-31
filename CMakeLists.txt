cmake_minimum_required (VERSION 2.8)
project (lev)

##################
# Compiler flags #
##################
#set(CMAKE_C_FLAGS -O2 -march=native -pipe)

#######################
# include other cmake #
#######################
include(${CMAKE_ROOT}/Modules/ExternalProject.cmake)
include(cmake/Modules/LuavitHelpers.cmake)

#######################
# define modules path #
#######################
set(CMAKE_MODULE_PATH ${CMAKE_MODULE_PATH} ${CMAKE_CURRENT_SOURCE_DIR}/cmake/Modules)

######################
# define directories #
######################
set(LUVIT_SRC_DIR ${CMAKE_SOURCE_DIR}/src/core/src)
set(LUVIT_MODULES_DIR ${CMAKE_SOURCE_DIR}/src/modules)
set(LUVIT_LIB_DIR ${CMAKE_SOURCE_DIR}/src/core/lib)
set(LUVIT_EXT_DIR ${CMAKE_SOURCE_DIR}/src/external)

################
# include dirs #
################
include_directories(${LUVIT_SRC_DIR})

###########
# defines #
###########
add_definitions(-DLUVIT_VERSION="0.4")
# compile time features
option(USE_BUNDLE "Bundling lua scripts into the binary" 1)
option(USE_SYSTEM_UV "Use system libuv" 1)
option(USE_SYSTEM_LUAJIT "Use system luajit" 1)

#####################
# finding libraries #
#####################

### rt ###
set(LIBS ${LIBS} rt)

### threads ###
find_package(Threads REQUIRED)
set(LIBS ${LIBS} ${CMAKE_THREAD_LIBS_INIT})

### LuaJiT ###
add_definitions(-DLUAJIT_VERSION="v2.0.0-beta10") # need auto detect
if (${USE_SYSTEM_LUAJIT})
  find_package(LuaJIT REQUIRED)
  include_directories(${LUAJIT_INCLUDE_DIR})
  set(LIBS ${LIBS} ${LUAJIT_LIBRARIES})
else ()
  include(${LUVIT_EXT_DIR}/luajit/ext.cmake)
endif()

### libuv ###
add_definitions(-DUV_VERSION="3")
if (${USE_SYSTEM_UV})
  find_package(UV REQUIRED)
  if (UV_FOUND)
    include_directories(${UV_INCLUDE_DIR})
    set(LIBS ${LIBS} ${UV_LIBRARIES})
  endif ()
else()
  include(${LUVIT_EXT_DIR}/libuv/ext.cmake)
endif()

######################
# search for modules #
######################

file(GLOB SUB_DIRS ${LUVIT_MODULES_DIR}/*)
foreach(LUVIT_MODULE ${SUB_DIRS})
  if(IS_DIRECTORY ${LUVIT_MODULE})
    if(EXISTS ${LUVIT_MODULE}/mod.cmake)
      include(${LUVIT_MODULE}/mod.cmake)
    endif()
  endif()
endforeach()

#######################
# luvit core building #
#######################

set(LUVIT_SRC ${LUVIT_SRC}
  ${LUVIT_SRC_DIR}/utils.c
#  ${LUVIT_SRC_DIR}/lev_main.c
  ${LUVIT_SRC_DIR}/lev_buffer.c
  ${LUVIT_SRC_DIR}/lev_slab.c
  ${LUVIT_SRC_DIR}/luv_fs.c
  ${LUVIT_SRC_DIR}/luv_dns.c
  ${LUVIT_SRC_DIR}/luv_debug.c
  ${LUVIT_SRC_DIR}/luv_handle.c
  ${LUVIT_SRC_DIR}/luv_udp.c
  ${LUVIT_SRC_DIR}/luv_fs_watcher.c
  ${LUVIT_SRC_DIR}/luv_timer.c
  ${LUVIT_SRC_DIR}/luv_process.c
  ${LUVIT_SRC_DIR}/luv_stream.c
  ${LUVIT_SRC_DIR}/luv_tcp.c
  ${LUVIT_SRC_DIR}/luv_pipe.c
  ${LUVIT_SRC_DIR}/luv_tty.c
  ${LUVIT_SRC_DIR}/luv_misc.c
  ${LUVIT_SRC_DIR}/luv.c
  ${LUVIT_SRC_DIR}/lev_init.c
  ${LUVIT_SRC_DIR}/lconstants.c
  ${LUVIT_SRC_DIR}/los.c
  ${LUVIT_SRC_DIR}/lenv.c)

set(LUVIT_LIBS ${LUVIT_LIBS}
  buffer
  childprocess
  core
  dgram
  dns
  fiber
  fs
  lev
  mime
  module
  net
  path
  querystring
  repl
  stack
  timer
  url
  utils
  uv)


if (${USE_BUNDLE})
  if (${USE_SYSTEM_LUAJIT})
    find_program(LUAJIT_BIN luajit | NAMES luajit-2.0 )
  endif()
  foreach(DOTLUA ${LUVIT_LIBS})
#    add_custom_command(OUTPUT ${BYTECODE_DIR}/${DOTLUA}.o
#      COMMAND ${LUAJIT_BIN} -bg ${LUVIT_LIB_DIR}/${DOTLUA}.lua ${BYTECODE_DIR}/${DOTLUA}.o
#    )
#    set(LUVIT_BYTECODE ${LUVIT_BYTECODE} ${BYTECODE_DIR}/${DOTLUA}.o)
    luvid_generate_bytecode(${LUVIT_LIB_DIR} ${DOTLUA})
  endforeach()

  #including the .lua from modules
  set(LUVIT_LIBS ${LUVIT_LIBS} ${EXTRA_BYTECODE})
  # Generate luvit_exports.c
  foreach(LUVITLIB ${LUVIT_LIBS})
    set (LUVIT_EXPORT_1 "${LUVIT_EXPORT_1}extern const char *luaJIT_BC_${LUVITLIB}[];\n")
    set (LUVIT_EXPORT_TMP "${LUVIT_EXPORT_TMP}   (size_t)(const char *)luaJIT_BC_${LUVITLIB} +\n")
  endforeach()
  string(REGEX REPLACE " \\+\n$" "" LUVIT_EXPORT_2 ${LUVIT_EXPORT_TMP})
  configure_file(${LUVIT_SRC_DIR}/luvit_exports.c.tmpl ${LUVIT_SRC_DIR}/luvit_exports.c)

  # this is needed for handling bytecodes as objects and not as source
  set_source_files_properties(
    ${LUVIT_BYTECODE}
    PROPERTIES
    EXTERNAL_OBJECT true
    GENERATED true
  )
  set(LUVIT_BUNDLE_SOURCES ${LUVIT_SRC_DIR}/luvit_exports.c ${LUVIT_BYTECODE})
endif ()

add_library(lev-lib ${LUVIT_SRC})
add_executable(lev ${LUVIT_SRC_DIR}/lev_main.c ${LUVIT_BUNDLE_SOURCES})
target_link_libraries(lev lev-lib m dl)
target_link_libraries(lev-lib ${LIBS})
if (LUVIT_EXTERNAL_DEPS)
  add_dependencies(lev ${LUVIT_EXTERNAL_DEPS})
endif()
set_target_properties(
  lev
  PROPERTIES
  LINKER_LANGUAGE C
)
set_target_properties(
  lev-lib
  PROPERTIES
  LIBRARY_OUTPUT_NAME lev
)
