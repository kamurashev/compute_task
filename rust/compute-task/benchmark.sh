#!/usr/bin/env bash

source ./build.sh

echo && echo "rust"
echo "One core:"
hyperfine -w 8 -r 25 ./target/release/compute-task

echo "All cores:"
mcore=true hyperfine -w 10 -r 75 ./target/release/compute-task