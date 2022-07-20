#!/bin/sh -l
set -e

# Run three times to make sure we get everything
/composer/vendor/bin/ecs check $1 --fix --clear-cache --output-format=json > one.json
/composer/vendor/bin/ecs check $1 --fix --clear-cache --output-format=json > two.json
/composer/vendor/bin/ecs check $1 --fix --clear-cache --output-format=json > thr.json

FILES=""

if [ ! "$(cat one.json | jq '.totals|add')" = "0" ]; then
    FILES="one.json"
fi

if [ ! "$(cat two.json | jq '.totals|add')" = "0" ]; then
    FILES="$FILES two.json"
fi

if [ ! "$(cat thr.json | jq '.totals|add')" = "0" ]; then
    FILES="$FILES thr.json"
fi

cat $FILES

# Merge json
if [ ! "$FILES" = "" ]; then
    OUTPUT=$(jq -s 'def f(x;y): reduce y[] as $item (x; reduce ($item | keys_unsorted[]) as $key (.; $item[$key] as $val | ($val | type) as $type | .[$key] = if ($type == "object") then f({};[if .[$key] == null then {} else .[$key] end, $val]) elif ($type == "array") then (.[$key] + $val | unique) else $val end)); f({};.)' $FILES)
else
    OUTPUT="$(cat one.json)"
fi

OUTPUT="${OUTPUT//'%'/'%25'}"
OUTPUT="${OUTPUT//$'\n'/'%0A'}"
OUTPUT="${OUTPUT//$'\r'/'%0D'}"

rm one.json two.json thr.json
echo "::set-output name=ecs_output::$OUTPUT"