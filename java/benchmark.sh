#!/usr/bin/env bash

source ./build-native-graal-runtime.sh
source ./make-runtime.sh

hyperfine -r 100 --warmup 10 ./jre-image/bin/launcher
sleep 2
hyperfine -r 100 --warmup 10 "java --module-path ./build --module compute_task/compute_task.ComputeTask"
sleep 2
hyperfine -r 100 --warmup 10 ./native-image/computetask