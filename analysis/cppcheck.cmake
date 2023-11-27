option(BUILD_WITH_CPPCHECK_ANALYSIS
       "Compile the probject with cppcheck support."
       OFF)

if(BUILD_WITH_CPPCHECK_ANALYSIS)
  set(CMAKE_C_CPPCHECK ${CPPCHECK_DEFAULT_ARGS})
  set(CMAKE_CXX_CPPCHECK ${CPPCHECK_DEFAULT_ARGS})
endif()

### Supply argument defaults for target

if(NOT CPPCHECK_DIRS)
  set(CPPECHECK_DIRS src test CACHE STRING "CMake list of directories to analyze with cppcheck.")
endif()

if(CPPCHECK_ADDITIONAL_DIRS)
  list(APPEND CPPCHECK_DIRS ${CPPCHECK_ADDITIONAL_DIRS})
endif()

if(NOT CPPCHECK_ENABLE_CHECKS)
  set(CPPCHECK_ENABLE_CHECKS style CACHE STRING "Value to pass to the CppCheck --enable= flag")
endif()

if(CPPCHECK_INCLUDE_DIRS)
  foreach(dir ${CPPCHECK_INCLUDE_DIRS})
    list(APPEND CPPECHECK_INCLUDE_DIRS_ARG -I ${dir})
  endforeach()
endif()

if(CPPCHECK_EXCLUDES)
  foreach(exclude ${CPPCHECK_EXCLUDES})
    list(APPEND CPPCHECK_EXCLUDE_ARGS -i ${exclude})
  endforeach()
endif()

find_program(CPPCHECK cppcheck)
if(CPPCHECK)

  set(CPPCHECK_DEFAULT_ARGS
    ${CPPCHECK} --quiet --enable=${CPPCHECK_ENABLE_CHECKS} --force
      ${CPPCHECK_INCLUDE_DIRS_ARG}
      ${CPPCHECK_EXCLUDE_ARGS}
  )

  if(BUILD_WITH_STATIC_ANALYSIS)
    set(CMAKE_C_CPPCHECK ${CPPCHECK_DEFAULT_ARGS})
  endif()

  add_custom_target(cppcheck
    COMMAND ${CPPCHECK_DEFAULT_ARGS}
    # Source directories
    ${CPPCHECK_DIRS}
    WORKING_DIRECTORY ${CMAKE_SOURCE_DIR}
  )

  add_custom_target(cppcheck-xml
    COMMAND ${CPPCHECK_DEFAULT_ARGS}
    # enable XML output
    --xml --xml-version=2
    # Source directories
    ${CPPCHECK_DIRS}
    # Redirect to file
    2>${CMAKE_BINARY_DIR}/cppcheck.xml
    WORKING_DIRECTORY ${CMAKE_SOURCE_DIR}
  )
else()
  message("[WARNING] CppCheck is not installed. CppCheck targets are disabled")
endif()
