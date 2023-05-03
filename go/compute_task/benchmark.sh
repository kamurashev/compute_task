#!/usr/bin/env bash

source ./build.sh

hyperfine -r 100 --warmup 10 ./compute_task