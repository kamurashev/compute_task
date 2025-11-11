#!/usr/bin/env bash

source ./set-java-version.sh
source ./build-native-graal-runtime.sh
source ./make-runtime.sh

echo && echo "Java"
echo "One core,"
echo "jre:"
hyperfine -w 8 -r 25 ./jre-image/bin/launcher
echo "jvm:"
hyperfine -w 8 -r 25 "java --module-path ./build --module compute_task/compute_task.ComputeTask"
echo "graal:"
hyperfine -w 8 -r 25 ./native-image/computetask

echo "All cores,"
echo "jre:"
mcore=true hyperfine -w 10 -r 75 ./jre-image/bin/launcher
echo "jvm:"
mcore=true hyperfine -w 10 -r 75 "java --module-path ./build --module compute_task/compute_task.ComputeTask"
echo "graal:"
mcore=true hyperfine -w 10 -r 75 ./native-image/computetask