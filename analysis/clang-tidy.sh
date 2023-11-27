#!/bin/bash

# Argument 1 is the path to the directory containing the compile_commands.json file
BUILD_OUTPUT_FOLDER=${1:-buildresults}

# read in directories
IFS=',' read -ra DIRS <<< "$2"

# list of file name/types to include in clang-tidy analysis
FILE_TYPES=
IFS=',' read -ra ENTRIES <<< "$3"
for entry in "${ENTRIES[@]}" do
	FILE_TYPES="$FILE_TYPES -o -iname $entry"
done

# Remove the initial -o argument for the first file type
# otherwise the rules will not be properly parsed
FILE_TYPES=${FILE_TYPES:3:${#FILE_TYPES}}

find ${DIRS[@]} ${FILE_TYPES} \
	| xargs clang-tidy -p $BUILD_OUTPUT_FOLDER %{@:4} # forward additional arguments to clang-tidy
