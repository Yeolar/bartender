# Find raster3
#
#  RASTER3_INCLUDE_DIR - where to find raster/*.
#  RASTER3_LIBRARY     - List of libraries when using raster3.
#  RASTER3_FOUND       - True if raster3 found.

if(RASTER3_INCLUDE_DIR)
  # Already in cache, be silent
  set(RASTER3_FIND_QUIETLY TRUE)
endif()

find_path(RASTER3_INCLUDE_DIR raster/raster-config.h)
find_library(RASTER3_LIBRARY NAMES raster)

# handle the QUIETLY and REQUIRED arguments and set RASTER3_FOUND to TRUE 
# if all listed variables are TRUE
include(FindPackageHandleStandardArgs)
find_package_handle_standard_args(
    RASTER3 DEFAULT_MSG
    RASTER3_LIBRARY RASTER3_INCLUDE_DIR)

mark_as_advanced(RASTER3_LIBRARY RASTER3_INCLUDE_DIR)
