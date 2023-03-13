#!/bin/sh -l
set -e

OUTPUT=$(./vendor/bin/pint $1 --test --preset=psr12 -v --format=json)

echo "OUTPUT: $OUTPUT"
echo "ecs_output=$OUTPUT" >> "$GITHUB_OUTPUT"

echo "::set-output name=ecs_output::$OUTPUT"
