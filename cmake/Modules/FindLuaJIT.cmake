# Find LuaJIT, returns
#
# LUAJIT_FOUND - found luajit
# LUAJIT_INCLUDE_DIR - luajit include dir
# LUAJIT_LIBRARIES - luajit libs

find_path(LUAJIT_INCLUDE_DIR luajit.h /usr/include/luajit-2.0 /usr/include/luajit)
find_library(LUAJIT_LIBRARIES NAMES luajit-2.0 | NAMES luajit)

include(${CMAKE_ROOT}/Modules/FindPackageHandleStandardArgs.cmake)
find_package_handle_standard_args(LUAJIT DEFAULT_MSG LUAJIT_LIBRARIES LUAJIT_INCLUDE_DIR)

if (LUAJIT_FOUND)
   include(CheckLibraryExists)
endif (LUAJIT_FOUND)

mark_as_advanced(LUAJIT_INCLUDE_DIR LUAJIT_LIBRARIES)
