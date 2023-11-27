option(BUILD_WITH_CLANG_TIDY_ANALYSIS
       "Compile the project with clang-tidy support"
       OFF)
if(BUILD_WITH_CLANG_TIDY_ANALYSIS)
  set(CMAKE_C_CLANG_TIDY ${CLANG_TIDY})
  set(CMAKE_CXX_CLANG_TIDY ${CLANG_TIDY})
endif()

### Supply argument defaults
if(NOT CLANG_TIDY_DIRS)
  set(CLANG_TIDY_DIRS src test CACHE STRING "CMake list of directories to analyze with clang-tidy.")
endif()

if(NOT CLANG_TIDY_FILETYPES)
  set(CLANG_TIDY_FILETYPES "*.c" "*.cpp" CACHE STRING "CMake list of file types to analyze using clang-tidy.")
endif()

if(CLANG_TIDY_ADDITIONAL_DIRS)
  list(APPEND CLANG_TIDY_DIRS ${CLANG_TIDY_ADDITIONAL_DIRS})
endif()

if(CLANG_TIDY_ADDITIONAL_FILETYPES)
  list(APPEND CLANG_TIDY_FILETYPES ${CLANG_TIDY_ADDITIONAL_FILETYPES})
endif()

## Convert Variables into script format
string(REPLACE ";" "," CLANG_TIDY_DIRS_ARG "${CLANG_TIDY_DIRS}")
string(REPLACE ";" "," CLANG_TIDY_FILETYPES_ARG "${CLANG_TIDY_FILETYPES}")

find_program(CLANG_TIDY clang-tidy)
if(CLANG_TIDY)
  if(BUILD_WITH_STATIC_ANALYSIS)
    set(CMAKE_C_CLANG_TIDY ${CLANG_TIDY})
  endif()

  add_custom_target(tidy
    COMMAND ${CMAKE_CURRENT_LIST_DIR}/clang-tidy.sh ${CMAKE_BINARY_DIR}
    # Directories to include in analysis
    ${CLANG_TIDY_DIRS_ARG}
    # File types to include in analysis
    ${CLANG_TIDY_FILETYPES_ARG}
    # Additional user options to pass to clang-tidy
    ${CLANG_TIDY_ADDITIONAL_OPTIONS}
    WORKING_DIRECTORY ${CMAKE_SOURCE_DIR}
  )
else()
  message("[WARNING] Clang-tidy is not installed. Clang-tidy targets are disabled.")
endif()
