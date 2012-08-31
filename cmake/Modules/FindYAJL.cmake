# Find yajl
#
# YAJL_FOUND - found yajl
# YAJL_INCLUDE_DIR - yajl include dir
# YAJL_LIBRARIES - yajl libs

find_path(YAJL_INCLUDE_DIR yajl_common.h /usr/include/yajl)

find_library(YAJL_LIBRARIES NAMES yajl )

include(${CMAKE_ROOT}/Modules/FindPackageHandleStandardArgs.cmake)
find_package_handle_standard_args(YAJL DEFAULT_MSG YAJL_LIBRARIES YAJL_INCLUDE_DIR)

if (YAJL_FOUND)
   include(CheckLibraryExists)
endif (YAJL_FOUND)

mark_as_advanced(YAJL_INCLUDE_DIR YAJL_LIBRARIES)
