#! /bin/bash

source ./build.sh

echo && echo "zig"
echo "One core:"
hyperfine -w 8 -r 25 ./zig-out/bin/zig

echo "All cores:"
mcore=true hyperfine -w 10 -r 75 ./zig-out/bin/zig
