#!/usr/bin/env bash

source ./build.sh

hyperfine -r 100 ./target/release/compute-task