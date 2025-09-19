#!/usr/bin/env bash

#SDKMann is a dependency
source "$HOME/.sdkman/bin/sdkman-init.sh"

#install and apply GraalVM to current session
SDK_GRAAL_VM_VERSION_ID=${1:-22.3.r19-grl}
sdk install java "$SDK_GRAAL_VM_VERSION_ID"
sdk use java "$SDK_GRAAL_VM_VERSION_ID"
#install GraalVM native-image utility
gu install native-image

#build
rm -rf ./graalvm-build ./native-image
mkdir ./native-image
javac -d build --module-source-path . compute_task/compute_task/ComputeTask.java -d ./graalvm-build
native-image --module-path ./graalvm-build --module compute_task/compute_task.ComputeTask -o ./native-image/computetask
