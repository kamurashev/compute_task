#!/usr/bin/env bash

source ./build.sh

echo && echo "Go"
echo "One core:"
hyperfine -w 8 -r 25 ./compute_task

echo "All cores:"
mcore=true hyperfine -w 10 -r 75 ./compute_task