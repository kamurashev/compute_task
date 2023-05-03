# compute_task
C, Rust, Java, JS, Python naive folded loop based prime numbers calculation written in different languages to compare performance in somewhat real world scenario.

# TL;DR - Rust is awesome ;-).  

It was not designed to be as efficient as possible, and I know there are much more efficient algorithms fot the task. The main point is to write essentially the same processing logic and compare performance depending on language.

For my Dell Latitude 5590 Intel Core i7 8750u laptop I got next results for numbers between 1 and 100000:  
C - 936.5ms. single core, 175.7ms all cores (4) - omp.h for multithreading  
Rust - 937.2ms single core / 267.5ms all cores (4)  
Java - 991.6(JDK Runtime) 1008(JRE Img)ms single core / 352.2(JDK Runtime) 356.5(JRE Img)ms all cores (4)  
JS - 1.3...1.4sec. single core / 0.5...0.65 all cores (4)  
Python - 21...22sec. / 7...8.5 all cores (4)

gcc - 12.2.1 20230201, Rust 1.69.0, Java - Oracle 20.0.1/GraalVM 22.3.r19, GO - go1.19.1 darwin/arm64, Node - 15, Python 3.8.5, Arch Linux - Linux 5.19.6-arch1-1  

For my MacBook Pro 16 2021 M1 Max/64G I got next results for numbers between 1 and 100000:  
C - 285.5ms single core. / 39.8 all cores (10) - omp.h for multithreading  
Java GraalVM native 20.0.1 - 339ms single core / 48.5ms all cores (10)   
Rust - 286.8ms single core. / 59.2ms all cores (10)  
Java Oracle 20.0.1 JDK runtime - 353.1ms single core / 114.6ms all cores (10)   
Java Oracle 20.0.1 JRE Image - 364ms single core / 143ms all cores (10)  
GO - 397.7ms single core / TBD all cores (10)  
JS - 531.7ms single core / 188.1ms all cores (10)  
Python3.9.7 - 14.050sec. / 2.871sec  all cores (10)  
Python3.12-dev - 9.651sec. / 2.018sec  all cores (10)  
PyPy3.9-7.3.11 - 792.8ms / 342ms  all cores (10)  

llvm clang version 16.0.26 (arm64), rustc 1.69.0, Java - Java - Oracle 20.0.1/GraalVM 22.3.r19 (arm64), GO - go1.19.1 darwin/arm64, Node - 18.4, Python 3.9.7/3.12-dev/PyPy3.9-7.3.11, MacOS Ventura 13.1

Inspired by https://www.youtube.com/watch?v=hGyJTcdfR1E
Thanks https://github.com/sharkdp/hyperfine for great benchmark tool!

Usage is straightforward just clone and use build.sh, run.sh, benchmark.sh etc. scripts in which lang module dir.

