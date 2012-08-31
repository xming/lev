### luacrypto ###
# Defines
set(MOD_NAME LUACRYPTO)
set(MOD_DESC "TLS support")
set(MOD_SYSTEM_DESC "TLS support with system libs")
set(MOD_DIR luacrypto)

# this is for system lib
#set (MOD_SYSTEM_PKG ${MOD_NAME})
#set (MOD_SYSTEM_PKG_VAR ${MOD_NAME}})

# this is for non system lib build
set(MOD_URL ${CMAKE_SOURCE_DIR}/tarballs/luacrypto.tar.bz2)
set(MOD_MD5 bbbf1f27f469f47f0527d13337cab29a)
set(MOD_LINK_LIB liblcrypto-static.a)

if (${USE_OPENSSL})
  set(MOD_CONFIG_VARS -DOPENSSL_INCLUDE_DIR=${OPENSSL_INCLUDE_DIR} -DOPENSSL_LIB_CRYPTO=${OPENSSL_LIB_CRYPTO})
  luavit_add_ext(${MOD_NAME} modules ${MOD_DIR} ${MOD_URL} ${MOD_MD5} ${MOD_LINK_LIB} src/)
  luvit_add_mod_src()
  add_dependencies(LUACRYPTO OPENSSL)
  #bundling
  luvit_add_to_bundle()
endif ()
