# Copyright (C) 2018, Yeolar

# Define project
project(bartender)

cmake_minimum_required(VERSION 3.2)

set(CMAKE_MODULE_PATH ${PROJECT_SOURCE_DIR}/cmake-scripts)

# Set project version
set(VERSION_MAJOR 1)
set(VERSION_MINOR 0)
set(VERSION_PATCH 0)

# Required packages
set(CMAKE_THREAD_PREFER_PTHREAD TRUE)
set(Boost_USE_MULTITHREADED TRUE)
find_package(Threads REQUIRED)
find_package(Boost REQUIRED COMPONENTS random regex thread)
find_package(DoubleConversion REQUIRED)
find_package(GFlags REQUIRED)
find_package(Protobuf REQUIRED)
find_package(Accelerator REQUIRED)
find_package(Crystal REQUIRED)
find_package(Raster3 REQUIRED)

# Optional packages
find_package(GTest)

# Setup environment
set(CMAKE_BUILD_TYPE RelWithDebInfo)
set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -march=native")
#set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -fsanitize=address")    # memcheck
set(CMAKE_CXX_STANDARD 14)
set(CMAKE_POSITION_INDEPENDENT_CODE ON)
set(CMAKE_VERBOSE_MAKEFILE OFF)

# Link libraries
link_libraries(
    ${CMAKE_THREAD_LIBS_INIT}
    ${CMAKE_DL_LIBS}
    ${Boost_LIBRARIES}
    ${DOUBLE_CONVERSION_LIBRARY}
    ${GFLAGS_LIBRARIES}
    ${PROTOBUF_LIBRARIES}
    ${ACCELERATOR_LIBRARY}
    ${CRYSTAL_LIBRARY}
)

include_directories(
    ${PROJECT_SOURCE_DIR}
    ${RASTER3_INCLUDE_DIR}
)

# Check and setup configurations
include(CheckCXXSourceCompiles REQUIRED)
include(CheckFunctionExists REQUIRED)

# Check and setup configurations
if(GFLAGS_FOUND)
    set(CMAKE_REQUIRED_LIBRARIES "gflags")

    check_cxx_source_compiles("
        #include <gflags/gflags.h>
        void foo() { google::GetArgv(); }
        int main() { return 0; }"
        BAR_UNUSUAL_GFLAGS_NAMESPACE)

    if(BAR_UNUSUAL_GFLAGS_NAMESPACE)
        set(BAR_GFLAGS_NAMESPACE "google")
    else()
        set(BAR_GFLAGS_NAMESPACE "gflags")
    endif()
endif()

configure_file(
    ${PROJECT_SOURCE_DIR}/bartender/bartender-config.h.in
    ${PROJECT_SOURCE_DIR}/bartender/bartender-config.h
)

# Work on all sub directories
add_subdirectory(bartender)
add_subdirectory(bartender/apps/search)

add_library(bartender_app_search SHARED
    $<TARGET_OBJECTS:bartender_app_search_obj>
)

install(TARGETS bartender_app_search
    DESTINATION lib
    PERMISSIONS OWNER_READ OWNER_WRITE OWNER_EXECUTE
                GROUP_READ GROUP_EXECUTE
                WORLD_READ WORLD_EXECUTE
)

# Binary

# Test
if(GTEST_FOUND)
    enable_testing()
    #add_subdirectory(bartender/test)
endif()

# Pack
set(CPACK_SYSTEM_NAME "amd64")
find_program(DPKG_CMD dpkg)
if(DPKG_CMD)
    execute_process(
        COMMAND "${DPKG_CMD}" --print-architecture
        OUTPUT_VARIABLE CPACK_SYSTEM_NAME
        OUTPUT_STRIP_TRAILING_WHITESPACE)
endif()

include(InstallRequiredSystemLibraries)
set(CPACK_GENERATOR "DEB;TXZ")
set(CPACK_PACKAGE_VERSION_MAJOR "${VERSION_MAJOR}")
set(CPACK_PACKAGE_VERSION_MINOR "${VERSION_MINOR}")
set(CPACK_PACKAGE_VERSION_PATCH "${VERSION_PATCH}")
set(CPACK_PACKAGE_CONTACT "yeolar@qq.com")
set(CPACK_PACKAGE_DESCRIPTION_SUMMARY "Applications.")
set(CPACK_DEBIAN_PACKAGE_DEPENDS "libboost-all-dev,libgflags-dev")
include(CPack)

