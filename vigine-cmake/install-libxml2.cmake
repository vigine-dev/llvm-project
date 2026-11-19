# Included by the LLVM build through CMAKE_PROJECT_LLVM_INCLUDE (named by the recipe's llvm-release steps, the only
# place that knows where our libxml2 was installed: VIGINE_LIBXML2_ROOT, the folder the libxml2-ours step installs to).
# It puts our libxml2 into the same prefix as LLVM: its headers, its static library and its CMake package files, plus a
# FindLibXml2.cmake that replaces LLVM's own one in the installed LLVM package. LLVM's installed config asks for
# find_package(LibXml2); LLVM's own module asks pkg-config and the system first, which on a consumer's machine finds the
# system SDK's libxml2. The replacement looks only in the prefix it is installed in. LLVM's sources are not changed, and
# the module used inside LLVM's own build (llvm/cmake/modules) is not this one.
if(NOT VIGINE_LIBXML2_ROOT)
  message(FATAL_ERROR "VIGINE_LIBXML2_ROOT is not set: the recipe's llvm-release step names the folder our libxml2 was installed to")
endif()
if(NOT EXISTS "${VIGINE_LIBXML2_ROOT}/include/libxml2/libxml/xpath.h")
  message(FATAL_ERROR "VIGINE_LIBXML2_ROOT=${VIGINE_LIBXML2_ROOT} holds no include/libxml2/libxml/xpath.h")
endif()
file(GLOB _vigine_libxml2_package_dirs "${VIGINE_LIBXML2_ROOT}/lib/cmake/libxml2*")
if(NOT _vigine_libxml2_package_dirs)
  message(FATAL_ERROR "VIGINE_LIBXML2_ROOT=${VIGINE_LIBXML2_ROOT} holds no lib/cmake/libxml2* package files")
endif()

# Called at the end of the top directory's processing, so these rules come after LLVM's own install rules: the
# replacement FindLibXml2.cmake is written last and wins over LLVM's copy in lib/cmake/llvm. The pkg-config file of
# libxml2 is left out: it names the build folder as its prefix.
function(vigine_install_libxml2)
  install(DIRECTORY "${VIGINE_LIBXML2_ROOT}/include/" DESTINATION "${CMAKE_INSTALL_INCLUDEDIR}")
  install(DIRECTORY "${VIGINE_LIBXML2_ROOT}/lib/" DESTINATION "${CMAKE_INSTALL_LIBDIR}"
    PATTERN "pkgconfig" EXCLUDE)
  install(FILES "${VIGINE_CMAKE_DIR}/FindLibXml2.cmake" DESTINATION "${LLVM_INSTALL_PACKAGE_DIR}")
endfunction()

set(VIGINE_CMAKE_DIR "${CMAKE_CURRENT_LIST_DIR}")
cmake_language(DEFER DIRECTORY "${CMAKE_SOURCE_DIR}" CALL vigine_install_libxml2)
