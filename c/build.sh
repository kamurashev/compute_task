#!/usr/bin/env bash

echo "removing previous executable..."
rm -f computeTask
echo "building C executable..."

# Detect OS and set appropriate compiler flags
if [[ "$OSTYPE" == "darwin"* ]]; then
    # macOS with Homebrew
    if [ -d "/opt/homebrew/opt/libomp" ]; then
        LIBOMP_PATH="/opt/homebrew/opt/libomp"
    elif [ -d "/usr/local/opt/libomp" ]; then
        LIBOMP_PATH="/usr/local/opt/libomp"
    else
        echo "Error: libomp not found. Run ./setup.sh first."
        exit 1
    fi

    clang -Wall -O3 computeTask.c -Xpreprocessor -fopenmp -lomp \
      -I${LIBOMP_PATH}/include \
      -L${LIBOMP_PATH}/lib \
      -o computeTask
else
    # Linux (Arch, Ubuntu, Debian, etc.)
    clang -Wall -O3 computeTask.c -fopenmp -o computeTask
fi

echo "built as ./computeTask"
echo "Done, happy hacking!"
