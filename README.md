# compute_task
C, Rust, Java, JS, Python naive folded loop based prime numbers calculation written in different languages to compare performance in somewhat real world scenario.

# TL;DR - Rust is awesome ;-).  

It was not designed to be as efficient as possible, and I know there are much more efficient algorithms fot the task. The main point is to write essentially the same processing logic and compare performance depending on language.

For my Dell Latitude 5590 Intel Core i7 8750u laptop I got next results for numbers between 1 and 100000:  
C - 937.1ms. single core.  
Rust - 937.6ms single core / 267.5ms all cores (4).    
Java - 991.6(JDK Runtime) 1008(JRE Img)ms single core / 352.2(JDK Runtime) 356.5(JRE Img)ms all cores (4)  
JS - 1.3...1.4sec. single core / 0.5...0.65 all cores (4)  
Python - 21...22sec. / 7...8.5 all cores (4)  

gcc - 9.3.0, Rust 1.64.0, Java - Azul 19, Node - 15, Python 3.8.5, Arch Linux - Linux 5.19.6-arch1-1

For my MacBook Pro 16 2021 M1 Max/64G I got next results for numbers between 1 and 100000:  
C - 285.5ms single core.  
Rust - 286.8ms single core. / 59.2ms all cores (10)
Java - 342.8(JDK runtime) 361.3(JRE image)ms single core / 114.8(JDK runtime) 138(JRE image)ms all cores (10)   
JS - 531.7ms single core / 188.1ms all cores (10)  
Python - 14.050sec. / 2.871sec  all cores (10)

gcc - clang 13.1.6 (arm64), rustc 1.64.0, Java - 18 (arm64), Node - 18.4, Python 3.9.7 (miniforge3-4.10.3-10), MacOS Monterey 12.4

Inspired by https://www.youtube.com/watch?v=hGyJTcdfR1E
Thanks https://github.com/sharkdp/hyperfine for great benchmark tool!

Usage is straitforward just clone and use build.sh, run.sh, benchmark.sh etc. scriprs in which lang module dir.

