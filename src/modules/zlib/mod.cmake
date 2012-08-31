### zlib ###

# Defines
set(MOD_NAME ZLIB)
set(MOD_DESC "zlib support")
set(MOD_SYSTEM_DESC "zlib support with system libs")
set(MOD_DIR zlib)

# this is for system lib
set (MOD_SYSTEM_PKG ${MOD_NAME})
set (MOD_SYSTEM_PKG_VAR ${MOD_NAME})

# this is for non system lib build
set(MOD_URL ${CMAKE_SOURCE_DIR}/tarballs/zlib-1.2.7.tar.bz2)
set(MOD_MD5 2ab442d169156f34c379c968f3f482dd)
SET(MOD_LINK_LIB libz.a)

option(USE_${MOD_NAME} ${MOD_DESC} 0)
if (${USE_${MOD_NAME}})
  option(USE_SYSTEM_${MOD_NAME} ${MOD_SYSTEM_DESC} 1)
  if (${USE_SYSTEM_${MOD_NAME}})
    luvit_find_system_pkg(${MOD_SYSTEM_PKG} ${MOD_SYSTEM_PKG_VAR})
  else() # not using system lib, needs to fetch and compile
    luavit_add_ext(${MOD_NAME} modules ${MOD_DIR} ${MOD_URL} ${MOD_MD5} ${MOD_LINK_LIB} .)
  endif ()
  luvit_add_mod_src()
  #bundling
  luvit_add_to_bundle()
endif ()
