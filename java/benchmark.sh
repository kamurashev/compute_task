#!/usr/bin/env bash

hyperfine -r 100 ./jre-image/bin/launcher
sleep 2
hyperfine -r 100 "java --module-path ./build --module compute_task/compute_task.ComputeTask"