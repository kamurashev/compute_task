#!/usr/bin/env bash

echo "removing \"target\" directory..."
rm -rf target
echo "building rust executable..."
cargo build --release
echo "built as ./target/release/compute-task"
echo "Done, happy hacking!"