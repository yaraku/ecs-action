#!/bin/sh -l
set -e

# Run three times to make sure we get everything
/composer/vendor/bin/ecs check $1 --fix --clear-cache --output-format=json > json_one.json
/composer/vendor/bin/ecs check $1 --fix --clear-cache --output-format=json > json_two.json
/composer/vendor/bin/ecs check $1 --fix --clear-cache --output-format=json > json_thr.json
OUTPUT=$(jq -s '.[0] * .[1] * .[2]' json_one.json json_two.json json_thr.json)

OUTPUT="${OUTPUT//'%'/'%25'}"
OUTPUT="${OUTPUT//$'\n'/'%0A'}"
OUTPUT="${OUTPUT//$'\r'/'%0D'}"

echo "JSON FILES:"
echo "ONE"
cat json_one.json
echo "TWO"
cat json_two.json
echo "THR"
cat json_thr.json

rm json_one.json json_two.json json_thr.json
echo "::set-output name=ecs_output::$OUTPUT"