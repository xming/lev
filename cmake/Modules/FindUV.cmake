# Find uv, retuns
#
# UV_FOUND - found uv
# UV_INCLUDE_DIR - uv include dir
# UV_LIBRARIES - uv libs

find_path(UV_INCLUDE_DIR uv.h )

find_library(UV_LIBRARIES NAMES uv )

include(${CMAKE_ROOT}/Modules/FindPackageHandleStandardArgs.cmake)
find_package_handle_standard_args(UV DEFAULT_MSG UV_LIBRARIES UV_INCLUDE_DIR)

if (UV_FOUND)
   include(CheckLibraryExists)
endif (UV_FOUND)

mark_as_advanced(UV_INCLUDE_DIR UV_LIBRARIES)
