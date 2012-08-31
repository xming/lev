# Find http_parse, retuns
#
# HTTP_PARSER_FOUND - found http_parser
# HTTP_PARSER_INCLUDE_DIR - http_parser include dir
# HTTP_PARSER_LIBRARIES - http_parser libs

find_path(HTTP_PARSER_INCLUDE_DIR http_parser.h /usr/include/http-parser)

find_library(HTTP_PARSER_LIBRARIES NAMES http_parser )

include(${CMAKE_ROOT}/Modules/FindPackageHandleStandardArgs.cmake)
find_package_handle_standard_args(HTTP_PARSER DEFAULT_MSG HTTP_PARSER_LIBRARIES HTTP_PARSER_INCLUDE_DIR)

if (HTTP_PARSER_FOUND)
   include(CheckLibraryExists)
endif (HTTP_PARSER_FOUND)

mark_as_advanced(HTTP_PARSER_INCLUDE_DIR HTTP_PARSER_LIBRARIES)
