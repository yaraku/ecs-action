#!/bin/sh -l
set -e

# Run three times to make sure we get everything
OUTPUT=$(/composer/vendor/bin/ecs check $1 --fix --clear-cache)
OUTPUT="$OUTPUT $(/composer/vendor/bin/ecs check $1 --fix --clear-cache)"
OUTPUT="$OUTPUT $(/composer/vendor/bin/ecs check $1 --fix --clear-cache)"
OUTPUT="${OUTPUT//'%'/'%25'}"
OUTPUT="${OUTPUT//$'\n'/'%0A'}"
OUTPUT="${OUTPUT//$'\r'/'%0D'}"

echo "OUTPUT: $OUTPUT"
echo "::set-output name=ecs_output::$OUTPUT"