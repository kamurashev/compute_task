#!/usr/bin/env bash

echo && echo "JS"
echo "One core:"
hyperfine -w 5 -r 15 "node ./ComputeTask.js"

echo "All cores:"
mcore=true hyperfine -w 8 -r 50 "node ./ComputeTask.js"
