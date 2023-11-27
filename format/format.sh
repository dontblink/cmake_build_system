#!/bin/bash

EXCLUDES_ARGS=
PATCH='0'

while getopts "e:p" opt; do
	case $opt in
		e) EXCLUDES_ARGS="$OPTARG"
		;;
		p) PATCH='1'
		;;
		\?) echo "Invalid option -$OPTARG" >&2
		;;
	esac
done

# Shift off the getopts args, leaving us with positional args
shift $((OPTIND -1))

# IFS = delimitter, read the value of the argument $1 into DIRS with read as an array
IFS=',' read -ra DIRS <<< "$1"

# handle file types
FILE_TYPES=
IFS=',' read -ra ENTRIES <<< "$2"
for entry in "${ENTRIES[@]}"; do
	FILE_TYPES="$FILE_TYPES -o -iname $entry"
done

# Remote the initial '-o' argument for the first file type, otherwise
# the rules will not be properly parsed
FILE_TYPES=${FILE_TYPES:3:${#FILE_TYPES}}

#handle excluded files
EXCLUDES=
IFS=',' read -ra ENTRIES <<< "$EXCLUDES_ARGS"
for entry in "${ENTRIES[@]}"; do
	EXCLUDES="$EXCLUDES -o -path $entry"
done

if [[ ! -z $EXCLUDES ]]; then
	# Remove the initial -o argument for a single/first directory
	EXCLUDES=${EXCLUDES:3:${#EXCLUDES}}

	# Create the final argument string
	EXCLUDES="-type d \( $EXCLUDES \) -prune"
else
	# Remove the initial -o argument for the first file type if there are no excludes,
	# otherwise the rules will not be properly parsed
	FILE_TYPES=${FILE_TYPES:3:${#FILE_TYPES}}
fi

eval find ${DIRS[@]} $EXCLUDES -prune -type f $FILE_TYPES \
	| xargs clang-format -style=file -i -fallback-style=none

if [ "$PATCH" == '1' ]; then
	git diff > clang_format.patch

	# Delete if 0 size
	if [ ! -s clang_format.patch ]
	then
		rm clang_format.patch
	fi
fi
