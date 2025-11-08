#!/usr/bin/env bash

echo "removing \"zig-out\" directory..."
rm -rf zig-out
zig build -Doptimize=ReleaseFast
echo "Done, happy hacking!"