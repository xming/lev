### yajl ###

# Defines
set(MOD_NAME YAJL)
set(MOD_DESC "JSON support")
set(MOD_SYSTEM_DESC "JSON support with system libs")
set(MOD_DIR yajl)

# this is for system lib
set (MOD_SYSTEM_PKG ${MOD_NAME})
set (MOD_SYSTEM_PKG_VAR ${MOD_NAME}})

# this is for non system lib build
set(MOD_URL ${CMAKE_SOURCE_DIR}/tarballs/yajl.tar.bz2)
set(MOD_MD5 f7e5d62d68714c8ab4fb9d9ee19585c2)
SET(MOD_LINK_LIB yajl-2.0.5/lib/libyajl_s.a)

option(USE_${MOD_NAME} ${MOD_DESC} 0)
if (${USE_${MOD_NAME}})
  option(USE_SYSTEM_${MOD_NAME} ${MOD_SYSTEM_DESC} 1)
  add_definitions(-DYAJL_VERSIONISH="2.0.5") # need version detection
  if (${USE_SYSTEM_${MOD_NAME}})
    luvit_find_system_pkg(${MOD_SYSTEM_PKG} ${MOD_SYSTEM_PKG_VAR})
  else() # not using system lib, needs to fetch and compile
    luavit_add_ext(${MOD_NAME} modules ${MOD_DIR} ${MOD_URL} ${MOD_MD5} ${MOD_LINK_LIB} src)
  endif ()
  luvit_add_mod_src()
  #bundling
  luvit_add_to_bundle()
endif ()
