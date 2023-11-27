include(CMakeDependentOption)

CMAKE_DEPENDENT_OPTION(ENABLE_COVERAGE
  "Enable code coverage analysis."
  OFF
  "\"${CMAKE_BUILD_TYPE}\" STREQUAL \"Debug\""
  OFF)

if(ENABLE_COVERAGE)
  include(cmake/CodeCoverage.cmake)
  append_coverage_compiler_flags()
endif()

# Call this function with dependencies that should be added to the coverage targets
function(enable_coverage_targets)
	if(ENABLE_COVERAGE_ANALYSIS)
		setup_target_for_coverage_gcovr_xml(
		                                    NAME coverage-xml
		                                    EXECUTABLE ctest
		                                    DEPENDENCIES ${ARGN})

		setup_target_for_coverage_gcovr_html(
		                                     NAME coverage-html
		                                     EXECUTABLE ctest
		                                     DEPENDENCIES ${ARGN})
		add_custom_target(coverage
		                  DEPENDS coverage-xml coverage-html)
	endif()
endfunction()
