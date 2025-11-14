# compute_task
Multilang naive loop based On2 prime numbers calculation
to compare raw compute performance in (somewhat) real world scenario.

It was not designed to be as efficient as possible,
and I know there are much more efficient algorithms fot the task.
The main point is to write essentially the same processing logic
and compare performance depending on language.

For my Dell Latitude 5590 Intel Core i7 8750u laptop I got next results for numbers between 1 and 100000:  
Zig - 942.6ms single core. / 179.6ms all cores (4)  
Rust - 942.2ms single core / 182.0ms all cores (4)  
C - 941.6ms. single core, 185.9ms all cores (4) - omp.h for multithreading  
Java GraalVM - 1055ms single core / 192ms all cores (4)  
V - 949.1ms single core. / 223.8ms all cores (10)  
Java JDK runtime - 998ms single core / 285ms all cores (4)  
Java JRE Image - 1032ms single core / 316ms all cores (4)  
GO - 3476ms single core / 669ms all cores (4)  
JS - 1.3...1.4sec. single core / 0.5...0.65 all cores (4)  
Python - 21...22sec. / 7...8.5 all cores (4)  

clang 21.1.5, zig 0.15.2, rustc 1.91.0, v 0.4.12, Java 25.0.1-oracle/25.0.1-graal, GO - go1.25.4,
Bun - 1.3.2, Node - 24.11.0, Deno - 2.5.6, Python 3.13.3/3.15-dev/PyPy3.11-7.3.19, Arch Linux 6.13.1-arch1-1  

For my MacBook Pro 16 2021 M1 Max/64G I got next results for numbers between 1 and 100000:  
Zig - 288.8ms single core. / 39.0ms all cores (10)  
Rust - 288.9ms single core. / 39.2ms all cores (10)  
C - 288.8ms single core. / 40.4 all cores (10) - omp.h for multithreading  
Java GraalVM - 310.1ms single core / 44.9ms all cores (10)  
V - 289.3ms single core. / 53.9ms all cores (10)  
GO - 400ms single core / 53.6ms all cores (10)  
JS (Bun) - 311.9ms single core / 87.4ms all cores (10)  
Java JDK runtime - 341.1ms single core / 94.3ms all cores (10)  
Java JRE Image - 377ms single core / 123.9ms all cores (10)  
JS (Node) - 596.1ms single core / 126.7ms all cores (10)  
JS (Deno) - 630.8ms single core / 188.2ms all cores (10)  
PyPy3.11-7.3.19 - 792.8ms / 342ms  all cores (10)  
Python3.15-dev - 9.651sec. / 2.018sec  all cores (10)  
Python3.13.3 - 14.050sec. / 2.871sec  all cores (10)  

clang 20.1.8, zig 0.15.2, rustc 1.91.0, v 0.4.12, Java 25.0.1-oracle/25.0.1-graal, GO - go1.25.4,
Bun - 1.3.2, Node - 24.11.0, Deno - 2.5.6, Python 3.13.3/3.15-dev/PyPy3.11-7.3.19, MacOS 15.6 

Inspired by https://www.youtube.com/watch?v=hGyJTcdfR1E
Thanks https://github.com/sharkdp/hyperfine for great benchmark tool!

Usage is straightforward just clone and use build.sh, run.sh, benchmark.sh etc. scripts in the lang module dir.

