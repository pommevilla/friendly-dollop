#
# CMakeLists.txt
#
# Copyright (C) 2021 by RStudio, PBC
#

cmake_minimum_required(VERSION 2.6)
project (Doc)

# version info; copied from CMakeGlobals so this directory can be built
# independently (without reading the entire rstudio-pro repo)
if ("$ENV{RSTUDIO_VERSION_MAJOR}" STREQUAL "")
  set(CPACK_PACKAGE_VERSION_MAJOR "99")
  set(RSTUDIO_UNVERSIONED_BUILD TRUE)
else()
  set(CPACK_PACKAGE_VERSION_MAJOR $ENV{RSTUDIO_VERSION_MAJOR})
endif()
if ("$ENV{RSTUDIO_VERSION_MINOR}" STREQUAL "")
  set(CPACK_PACKAGE_VERSION_MINOR "9")
else()
  set(CPACK_PACKAGE_VERSION_MINOR $ENV{RSTUDIO_VERSION_MINOR})
endif()
if ("$ENV{RSTUDIO_VERSION_PATCH}" STREQUAL "")
  set(CPACK_PACKAGE_VERSION_PATCH "9")
else()
  set(CPACK_PACKAGE_VERSION_PATCH $ENV{RSTUDIO_VERSION_PATCH})
endif()
set(CPACK_PACKAGE_VERSION "${CPACK_PACKAGE_VERSION_MAJOR}.${CPACK_PACKAGE_VERSION_MINOR}.${CPACK_PACKAGE_VERSION_PATCH}")

# set date
string(TIMESTAMP TODAY "%m-%d-%Y")

# pick up suffix if present
if(NOT "$ENV{RSTUDIO_VERSION_SUFFIX}" STREQUAL "" AND NOT "$ENV{RSTUDIO_VERSION_SUFFIX}" STREQUAL "0")
   set(CPACK_PACKAGE_VERSION "${CPACK_PACKAGE_VERSION}-$ENV{RSTUDIO_VERSION_SUFFIX}")
endif()

configure_file(build-book.sh.in ${CMAKE_CURRENT_SOURCE_DIR}/build-book.sh)
configure_file(_quarto.yml.in ${CMAKE_CURRENT_SOURCE_DIR}/_quarto.yml)
configure_file(_variables.yml.in ${CMAKE_CURRENT_SOURCE_DIR}/_variables.yml)
configure_file(cover.tex.in ${CMAKE_CURRENT_SOURCE_DIR}/cover.tex)

# build book
add_custom_target(build_book ALL)
add_custom_command(
   TARGET build_book
   WORKING_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR}
   COMMAND ./build-book.sh ${CPACK_PACKAGE_VERSION})

