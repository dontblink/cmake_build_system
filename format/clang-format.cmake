### Supply argument defaults
if(NOT CLANG_FORMAT_EXCLUDE_DIRS)
  set(CLANG_FORMAT_EXCLUDE_DIRS "" CACHE STRING "CMake list of directories to exclude form clang-format.")
endif()

if(NOT CLANG_FORMAT_DIRS)
  set(CLANG_FORMAT_DIRS src test CACHE STRING "CMake list of directories to format using clang-format.")
endif()

if(NOT CLANG_FORMAT_FILETYPES)
  set(CLANG_FORMAT_FILETYPES "*.c" "*.h" "*.cpp" "*.hpp" CACHE STRING "CMake list of file types to format using clang-format.")
endif()

if(CLANG_FORMAT_ADDITIONAL_DIRS)
  list(APPEND CLANG_FORMAT_DIRS ${CLANG_FORMAT_ADDITIONAL_DIRS})
endif()

if(CLANG_FORMAT_ADDITIONAL_FILETYPES)
  list(APPEND CLANG_FORMAT_FILETYPES${CLANG_FORMAT_ADDITIONAL_FILETYPES})
endif()

# replace cmake lists delimmiters with delimitters we use in script
if(CLANG_FORMAT_EXCLUDE_ARG)
  string(REPLACE ";" "," CLANG_FORMAT_EXCLUDE_ARG "${CLANG_FORMAT_EXCLUDE_DIRS}")
  set(CLANG_FORMAT_EXCLUDE_ARG "-e ${CLANG_FORMAT_EXCLUDE_ARG}")
endif()
string(REPLACE ";" "," CLANG_FORMAT_DIRS_ARG "${CLANG_FORMAT_DIRS}")
string(REPLACE ";" "," CLANG_FORMAT_FILETYPES_ARG "${CLANG_FORMAT_FILETYPES}")

find_program(CLANG_FORMAT clang-format)
if(CLANG_FORMAT)
  set(clang_format_args
      ${CLANG_FORMAT_EXCLUDE_ARG}
      ${CLANG_FORMAT_DIRS_ARG}
      ${CLANG_FORMAT_FILETYPES_ARG}
      )

  add_custom_target(format
                    COMMAND ${CMAKE_CURRENT_LIST_DIR}/format.sh
                    # common args
                    ${clang_format_args}
                    WORKING_DIRECTORY ${CMAKE_SOURCE_DIR}
                    )

  add_custom_target(format-patch
                    COMMAND ${CMAKE_CURRENT_LIST_DIR}/format.sh
                    # Enable patch file
                    -p
                    # common args                    
                    ${clang_format_args}
                    WORKING_DIRECTORY ${CMAKE_SOURCE_DIR}
                    )
else()
  message("[WARNING] Clang-format is not installed. Formatting targets are disabled.")
endif()
