#!/bin/sh -l
set -e

# Run three times to make sure we get everything
ecs check $1 --fix --clear-cache --output-format=json > one.json
ecs check $1 --fix --clear-cache --output-format=json > two.json
ecs check $1 --fix --clear-cache --output-format=json > thr.json

FILES=""

if [ ! "$(echo $ONE | jq '.totals|add')" = "0" ]; then
    FILES="one.json"
fi

if [ ! "$(echo $TWO | jq '.totals|add')" = "0" ]; then
    FILES="$FILES two.json"
fi

if [ ! "$(echo $THR | jq '.totals|add')" = "0" ]; then
    FILES="$FILES thr.json"
fi

# Merge json
if [ ! "$FILES" = "" ]; then
    OUTPUT=$(jq -s 'def f(x;y): reduce y[] as $item (x; reduce ($item | keys_unsorted[]) as $key (.; $item[$key] as $val | ($val | type) as $type | .[$key] = if ($type == "object") then f({};[if .[$key] == null then {} else .[$key] end, $val]) elif ($type == "array") then (.[$key] + $val | unique) else $val end)); f({};.)' $FILES)
else
    OUTPUT="$(cat one.json)"
fi

OUTPUT="${OUTPUT//'%'/'%25'}"
OUTPUT="${OUTPUT//$'\n'/'%0A'}"
OUTPUT="${OUTPUT//$'\r'/'%0D'}"

cat $FILES
rm $FILES
echo "::set-output name=ecs_output::$OUTPUT"