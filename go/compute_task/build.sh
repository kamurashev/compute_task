#!/usr/bin/env bash

echo "removing previous executable..."
rm -f compute_task
echo "building Go executable..."
go build -o compute_task
echo "built as ./compute_task"
echo "Done, happy hacking!"