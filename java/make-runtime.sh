#!/usr/bin/env bash

OUT_DIR='jre-image'
rm -rf ${OUT_DIR}
jlink --strip-debug \
      --no-header-files \
      --no-man-pages \
      --compress=2 \
      --module-path ./build \
      --add-modules compute_task \
      --output ${OUT_DIR} \
      --launcher launcher=compute_task/compute_task.ComputeTask