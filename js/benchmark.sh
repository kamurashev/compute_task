#!/usr/bin/env bash

source "$(dirname "$0")/setup.sh"

echo && echo "JS (Node)"
echo "One core:"
hyperfine -w 4 -r 12 "node ./ComputeTask.js"

echo "All cores:"
mcore=true hyperfine -w 8 -r 25 "node ./ComputeTask.js"

echo && echo "JS (Bun)"
echo "One core:"
hyperfine -w 4 -r 12 "bun ./ComputeTask.js"

echo "All cores:"
mcore=true hyperfine -w 8 -r 25 "bun ./ComputeTask.js"

echo && echo "JS (Deno)"
echo "One core:"
hyperfine -w 4 -r 12 "deno run --unstable-detect-cjs --allow-read --allow-env --allow-sys ./ComputeTask.js"

echo "All cores:"
mcore=true hyperfine -w 8 -r 25 "deno run --unstable-detect-cjs --allow-read --allow-env --allow-sys ./ComputeTask.js"
