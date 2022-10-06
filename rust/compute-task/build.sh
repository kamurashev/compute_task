#!/usr/bin/env bash

echo "removing \"build\" directory..."
rm -rf target
cargo build --release
echo "Done, happy hacking!"