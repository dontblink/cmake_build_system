include(${CMAKE_CURRENT_LIST_DIR}/../CPM.cmake)

if(NOT CMOCKA_TEST_OUTPUT_DIR)
  set(CMOCKA_TEST_OUTPUT_DIR ${CMAKE_BINARY_DIR}/test/ CACHE STRING "Location where CMocka test results should live.")
endif()

#Redefine add_custom_target so we can change cmocka's doc target name
# in order to preserve our own
function(add_custom_target target)
  if(${CMAKE_CURRENT_LIST_DIR} MATCHES cmocka-src AND ${target} STREQUAL docs)
    set(target cmocka-docs)
  endif()

  # Forward all arguments to the standard _add_custom_target
  _add_custom_target(${target} ${ARGN})
endfunction()

CPMFindPackage(
  NAME cmocka
  GIT_REPOSITORY https://git.cryptomilk.org/projects/cmocka.git/
  VERSION 1.1.7
  GIT_TAG cmocka-1.1.7
  OPTIONS
    "WITH_EXAMPLES OFF"
    "CMAKE_BUILD_TYPE DEBUG"
)

# add_library(cmocka_dep INTERFACE)
# target_include_directories(cmocka_dep INTERFACE ${CMOCKA_INCLUDE_DIR})
# target_link_libraries(cmocka_dep INTERFACE ${CMOCKA_LIBRARIES})

# Helper Targets

add_custom_target(test-clear-results
                  COMMAND ${CMAKE_COMMAND} -E rm -f ${CMOCKA_TEST_OUTPUT_DIR}/*.xml
                  COMMENT "Removing XML files in the test/ directory"
                  )
add_test(NAME CMocka.ClearResults
         COMMAND ${CMAKE_COMMAND} --build ${CMAKE_BINARY_DIR} --target test-clear-results
         )
