include(${CMAKE_CURRENT_LIST_DIR}/CheckAndApplyFlags.cmake)

set(desired_common_warning_flags
  # Base Warnings
  -Wall
  -Wextra
  # Diagnostics
  -fdiagnostics-show-option
  -fcolor-diagnostics
  # Disabled Warnings
  -Wno-c++98-compat
  -Wno-c++98-compat-pedantic
  -Wno-padded
  -Wno-exit-time-destructors # causes warnings if you use static values
  -Wno-global-constructors # causes warnings if you use static values
  -Wno-covered-switch-default
  # Desired Warnings
  -Wfloat-equal
  -Wconversion
  -Wlogical-op
  -Wundef
  -Wredundant-decls
  -Wshadow
  -Wstrict-overflow=2
  -Wwrite-strings
  -Wpointer-arith
  -Wcast-qual
  -Wformat=2
  -Wformat-truncation
  -Wmissing-include-dirs
  -Wcast-align
  -Wswitch-enum
  -Wsign-conversion
  -Wdisabled-optimization
  -Winline
  -Winvalid-pch
  -Wmissing-declarations
  -Wdouble-promotion
  -Wshadow
  -Wtrampolines
  -Wvector-operation-performance
  -Wshift-overflow=2
  -Wnull-dereference
  -Wduplicated-cond
  -Wshift-overflow=2
  -Wnull-dereference
  -Wduplicated-cond
  -Wcast-align=strict
)

set(desired_cpp_warning_flags
  -Wold-style-cast
  -Wnon-virtual-dtor
  -Wctor-dtor-privacy
  -Woverloaded-virtual
  -Wnoexcept
  -Wstrict-null-sentinel
  -Wuseless-cast
  -Wzero-as-null-pointer-constant
  -Wextra-semi
)

set(desired_common_compiler_optimization_flags
  -ffunction-sections # Place each function in its own section (ELF Only)
  -fdata-sections # Place each data in its own section (ELF Only)
  -fdevirtualize # Attempt to convert calls to virtual functions to direct calls
)

# If we're not a subproject, globally apply our warning flags
if(CMAKE_PROJECT_NAME STREQUAL PROJECT_NAME)
  apply_supported_compiler_flags_globally(C desired_common_warning_flags)
  apply_supported_compiler_flags_globally(CXX desired_common_warning_flags)
  apply_supported_compiler_flags_globally(CXX desired_cpp_warning_flags)
  apply_supported_compiler_flags_globally(C desired_common_compiler_optimization_flags)
  apply_supported_compiler_flags_globally(CXX desired_common_compiler_optimization_flags)
endif()

#set default flags
apply_supported_compiler_flags_globally(C "-Wno-unknown-pragmas")
apply_supported_compiler_flags_globally(CXX "-Wno-unknown-pragmas")
