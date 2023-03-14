#!/bin/sh -l
set -e

echo "Have these files: $1"
echo "ecs_output=$(/composer/vendor/bin/pint $1 --test --preset=psr12 -v --format=json)" >> "$GITHUB_OUTPUT" 
