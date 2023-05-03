#!/usr/bin/env bash

source ./set-java-version.sh

javac -d build --module-source-path . compute_task/compute_task/ComputeTask.java