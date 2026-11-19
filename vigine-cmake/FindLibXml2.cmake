# Installed into lib/cmake/llvm over LLVM's own FindLibXml2.cmake (see install-libxml2.cmake). LLVMConfig.cmake calls
# find_package(LibXml2) and LLVM's libraries link LibXml2::LibXml2. This module finds the libxml2 installed beside LLVM
# in the same prefix and nowhere else: no pkg-config, no system folders, no CMAKE_PREFIX_PATH. The libxml2 package file
# in that prefix is relocatable and defines LibXml2::LibXml2 (static, LIBXML_STATIC, and on Windows bcrypt) and the
# LIBXML2_* variables.
get_filename_component(_vigine_llvm_prefix "${CMAKE_CURRENT_LIST_DIR}/../../.." ABSOLUTE)
file(GLOB _vigine_libxml2_package_dirs "${_vigine_llvm_prefix}/lib/cmake/libxml2*")
find_package(LibXml2 CONFIG QUIET
  PATHS ${_vigine_libxml2_package_dirs}
  NO_DEFAULT_PATH
  NO_CMAKE_FIND_ROOT_PATH)
if(LibXml2_FOUND)
  if(NOT LibXml2_FIND_QUIETLY)
    message(STATUS "Found LibXml2: ${LIBXML2_LIBRARY} (the one installed with LLVM in ${_vigine_llvm_prefix}, version ${LIBXML2_VERSION_STRING})")
  endif()
elseif(LibXml2_FIND_REQUIRED)
  message(FATAL_ERROR "LibXml2 is not installed beside LLVM in ${_vigine_llvm_prefix}/lib/cmake")
endif()
unset(_vigine_libxml2_package_dirs)
unset(_vigine_llvm_prefix)
