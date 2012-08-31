### http_parser ###

# Defines
set(MOD_NAME HTTP_PARSER)
set(MOD_DESC "http_parser support")
set(MOD_SYSTEM_DESC "http_parser support with system libs")
set(MOD_DIR http)

# this is for system lib
set (MOD_SYSTEM_PKG HttpParser)
set (MOD_SYSTEM_PKG_VAR ${MOD_NAME})

# this is for non system lib build
set(MOD_URL ${CMAKE_SOURCE_DIR}/tarballs/http_parser.tar.bz2)
set(MOD_MD5 d695d0643a53bb164fa71f7ceb5d4bbe)
SET(MOD_LINK_LIB libhttp_parser.a)

option(USE_${MOD_NAME} ${MOD_DESC} 0)
if (${USE_${MOD_NAME}})
  option(USE_SYSTEM_${MOD_NAME} ${MOD_SYSTEM_DESC} 1)
  add_definitions(-DHTTP_VERSION="v1.0-79") # need to do version detection
  if (${USE_SYSTEM_${MOD_NAME}})
    luvit_find_system_pkg(${MOD_SYSTEM_PKG} ${MOD_SYSTEM_PKG_VAR})
  else() # not using system lib, needs to fetch and compile
    luavit_add_ext(${MOD_NAME} modules ${MOD_DIR} ${MOD_URL} ${MOD_MD5} ${MOD_LINK_LIB} .)
  endif ()
  luvit_add_mod_src()
  #bundling
  luvit_add_to_bundle()
endif ()
