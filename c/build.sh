#! /bin/bash
#brew install llvm libomp
#export LDFLAGS="-L/opt/homebrew/opt/libomp/lib"
#export CPPFLAGS="-I/opt/homebrew/opt/libomp/include"
#xport LDFLAGS="-L/opt/homebrew/opt/llvm/lib"
#export CPPFLAGS="-I/opt/homebrew/opt/llvm/include"
#export CC=/usr/local/opt/llvm/bin/clang

echo "removing previous executable..."
rm computeTask
#gcc -I/opt/homebrew/opt/libomp/include -Wall -O3 computeTask.c -fopenmp -o computeTask
/opt/homebrew/opt/llvm/bin/clang -Wall -O3 computeTask.c -fopenmp -o computeTask
echo "built as ./computeTask"
echo "Done, happy hacking!"
