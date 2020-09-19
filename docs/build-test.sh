#!/bin/bash
# build-test.sh - test 'make html' and filter out messages I'm currently ignoring

make html 2>&1 | grep -v "nonexisting" | grep -v "undefined label"

NONEXISTING_COUNT=$(make html 2>&1 | grep "nonexisting" | wc -l)
UNDEFINED_COUNT=$(make html 2>&1 | grep "undefined label" | wc -l)

echo "$NONEXISTING_COUNT 'nonexisting document' warnings"
echo "$UNDEFINED_COUNT 'undefined label' warnings"
