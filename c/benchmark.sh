#! /bin/bash

source ./build.sh

echo && echo "C"
echo "One core:"
hyperfine -w 8 -r 25 ./computeTask

echo "All cores:"
mcore=true hyperfine -w 10 -r 75 ./computeTask