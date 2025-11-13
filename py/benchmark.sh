#!/usr/bin/env bash

echo && echo "Python 3.13.3"
pyenv local 3.13.3
echo "One core:"
hyperfine -w 1 -r 3 "python ./src/computeTask.py"

echo "All cores:"
mcore=true hyperfine -w 2 -r 5 "python ./src/computeTask.py"

echo && echo "Python 3.15-dev"
pyenv local 3.15-dev
echo "One core:"
hyperfine -w 1 -r 3 "python ./src/computeTask.py"

echo "All cores:"
mcore=true hyperfine -w 2 -r 5 "python ./src/computeTask.py"

echo && echo "PyPy 3.11-7.3.19"
pyenv local pypy3.11-7.3.19
echo "One core:"
hyperfine -w 1 -r 3 "python ./src/computeTask.py"

echo "All cores:"
mcore=true hyperfine -w 2 -r 5 "python ./src/computeTask.py"