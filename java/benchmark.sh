#!/usr/bin/env bash

#source ./build-native-graal-runtime.sh
#source ./make-runtime.sh

hyperfine -r 100 ./jre-image/bin/launcher
sleep 2
hyperfine -r 100 "java --module-path ./build --module compute_task/compute_task.ComputeTask"
sleep 2
hyperfine -r 100 ./native-image/computetask