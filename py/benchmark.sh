#!/usr/bin/env bash

hyperfine -r 10 "python3 ./src/computeTask.py"