#!/bin/sh -l
set -e

# Run three times to make sure we get everything
echo $(/composer/vendor/bin/ecs check $1 --clear-cache --output-format=json > output.json)

cat output.json
OUTPUT="$(cat output.json)"

OUTPUT="${OUTPUT//'%'/'%25'}"
OUTPUT="${OUTPUT//$'\n'/'%0A'}"
OUTPUT="${OUTPUT//$'\r'/'%0D'}"

rm output.json
echo "::set-output name=ecs_output::$OUTPUT"