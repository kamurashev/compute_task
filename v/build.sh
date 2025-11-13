#! /bin/bash

echo "removing previous executable..."
rm -f computeTask
echo "building V executable..."
v -prod -o computeTask main.v
echo "built as ./computeTask"
echo "Done, happy hacking!"