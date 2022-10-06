#! /bin/bash

echo "removing previous executable..."
rm computeTask
gcc -Wall -O3 computeTask.c -o computeTask
echo "built as ./computeTask"
echo "Done, happy hacking!"
