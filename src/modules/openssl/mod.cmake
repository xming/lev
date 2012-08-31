### OpenSSL ###
# Defines
set(MOD_NAME OPENSSL)
set(MOD_DESC "OpenSSL support")
set(MOD_SYSTEM_DESC "OpenSSL support with system libs")
set(MOD_DIR openssl)

# this is for system lib
set (MOD_SYSTEM_PKG OpenSSL)
set (MOD_SYSTEM_PKG_VAR OPENSSL)

# this is for non system lib build
set(MOD_URL ${CMAKE_SOURCE_DIR}/tarballs/openssl-1.0.0j.tar.gz)
set(MOD_MD5 cbe4ac0d8f598680f68a951e04b0996b)
set(MOD_LINK_LIB libssl.a)

option(USE_${MOD_NAME} ${MOD_DESC} 0)
if (${USE_${MOD_NAME}})
  option(USE_SYSTEM_${MOD_NAME} ${MOD_SYSTEM_DESC} 1)
  if (${USE_SYSTEM_${MOD_NAME}})
    luvit_find_system_pkg(${MOD_SYSTEM_PKG} ${MOD_SYSTEM_PKG_VAR})
  else() # not using system lib, needs to fetch and compile
    luavit_add_ext(${MOD_NAME} modules ${MOD_DIR} ${MOD_URL} ${MOD_MD5} ${MOD_LINK_LIB} include/openssl)
    set(OPENSSL_LIBRARIES ${SOURCE_DIR}/libcrypto.a ${SOURCE_DIR}/libssl.a)
    set(OPENSSL_INCLUDE_DIR ${SOURCE_DIR}/include/openssl)
  endif ()
  luvit_add_mod_src()
  #bundling
  luvit_add_to_bundle()
  set(LIBS ${LIBS} ${SOURCE_DIR}/libcrypto.a)
endif ()
