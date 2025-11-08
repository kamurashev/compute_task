#!/usr/bin/env bash

echo "removing \"zig-out\" directory..."
rm -rf zig-out
echo "building zig executable..."
zig build -Doptimize=ReleaseFast
echo "built as ./zig-out/bin/zig"
echo "Done, happy hacking!"