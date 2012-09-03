macro(luavit_add_ext TARGET_NAME TYPE DIR URL MD5 LINK_LIB INCLUDE_DIR)
  set(EP_PREFIX ${CMAKE_BINARY_DIR}/src/modules/${MOD_DIR})
  ExternalProject_Add(${TARGET_NAME}
    URL ${URL}
    URL_MD5 ${MD5}
    BUILD_IN_SOURCE 1
    CMAKE_ARGS -DLUAJIT_LIBRARIES=${LUAJIT_LIBRARIES} -DLUAJIT_INCLUDE_DIR=${LUAJIT_INCLUDE_DIR} ${MOD_CONFIG_VARS}
    INSTALL_COMMAND ""
  )
  ExternalProject_Get_Property(${TARGET_NAME} SOURCE_DIR)
  if(EXISTS ${CMAKE_SOURCE_DIR}/src/${TYPE}/${DIR}/CMakeLists-${TARGET_NAME}.txt)
    ExternalProject_Add_Step(${TARGET_NAME} AddCmake
      COMMAND ${CMAKE_COMMAND} -E copy ${CMAKE_SOURCE_DIR}/src/${TYPE}/${DIR}/CMakeLists-${TARGET_NAME}.txt ${SOURCE_DIR}/CMakeLists.txt
      DEPENDEES download
      DEPENDERS update
    )
  endif()

  include_directories(${SOURCE_DIR}/${INCLUDE_DIR})
  set(LIBS ${SOURCE_DIR}/${LINK_LIB} ${LIBS})
  set(LUVIT_EXTERNAL_DEPS ${LUVIT_EXTERNAL_DEPS} ${MOD_NAME})
  if ((NOT ${USE_SYSTEM_LUAJIT}) AND (NOT ${TARGET_NAME} MATCHES UV))
    add_dependencies(${TARGET_NAME} LUAJIT)
  endif()
  if ((NOT ${USE_SYSTEM_UV}) AND (NOT ${TARGET_NAME} MATCHES LUAJIT))
    add_dependencies(${TARGET_NAME} UV)
  endif()
#  if (${USE_OPENSSL} AND (NOT ${USE_SYSTEM_OPENSSL}) AND (${TARGET_NAME} MATCHES LUACRYPTO))
#    add_dependencies(${TARGET_NAME} OPENSSL)
#  endif()
endmacro()

macro(luvit_add_mod_src)
  add_definitions(-DUSE_${MOD_NAME})
  include_directories(${LUVIT_MODULES_DIR}/${MOD_DIR}/src)
  file(GLOB MOD_SRC ${LUVIT_MODULES_DIR}/${MOD_DIR}/src/*.c)
  set(LUVIT_SRC ${LUVIT_SRC} ${MOD_SRC})
endmacro()

macro(luvit_find_system_pkg PKG VARNAME)
  find_package(${PKG})
  if(${VARNAME}_FOUND)
    add_definitions(-DUSE_SYSTEM_${MOD_NAME})
    include_directories(${${VARNAME}_INCLUDE_DIR})
    set(LIBS ${LIBS} ${${VARNAME}_LIBRARIES})
  endif()
endmacro()

macro(luvid_generate_bytecode DIR BYTECODE_SRC)
  set (BYTECODE_DIR bytecode/)
  file(MAKE_DIRECTORY ${CMAKE_BINARY_DIR}/${BYTECODE_DIR})
  if (NOT ${USE_SYSTEM_LUAJIT})
    set(DEPENDS_ON JIT)
  endif()
  add_custom_command(OUTPUT ${BYTECODE_DIR}/${BYTECODE_SRC}.o
    COMMAND ${LUAJIT_BIN} -bg ${DIR}/${BYTECODE_SRC}.lua ${BYTECODE_DIR}/${BYTECODE_SRC}.o
    DEPENDS ${DEPENDS_ON}
  )
  set(LUVIT_BYTECODE ${LUVIT_BYTECODE} ${BYTECODE_DIR}/${DOTLUA}.o)
  #if (NOT ${USE_SYSTEM_LUAJIT})
  #  add_dependencies(${BYTECODE_DIR}/${BYTECODE_SRC}.o LUAJIT)
  #endif()
endmacro()

macro(luvit_add_to_bundle)
  #file(GLOB MOD_LUA_FILES RELATIVE ${CMAKE_SOURCE_DIR}/src/modules/${MOD_DIR}/lib/ *.*)
  set(MOD_LIB_DIR ${CMAKE_SOURCE_DIR}/src/modules/${MOD_DIR}/lib/)
  file(GLOB MOD_LUA_FILES RELATIVE ${CMAKE_SOURCE_DIR}/src/modules/${MOD_DIR}/lib src/modules/${MOD_DIR}/lib/*.lua)
  foreach(MOD_LUA_FILE ${MOD_LUA_FILES})
    string(REGEX REPLACE ".lua$" "" DOTLUA ${MOD_LUA_FILE})
    luvid_generate_bytecode(${CMAKE_SOURCE_DIR}/src/modules/${MOD_DIR}/lib ${DOTLUA})
    set(EXTRA_BYTECODE ${EXTRA_BYTECODE} ${DOTLUA})
  endforeach()
endmacro()
