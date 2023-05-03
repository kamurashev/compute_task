#!/usr/bin/env bash

echo "removing old binary..."
rm -f compute_task
echo "executing 'go build'..."
go build
echo "Done, happy hacking!"