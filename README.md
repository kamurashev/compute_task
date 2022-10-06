# compute_task
C, Rust, Java, JS, Python naive folded loop based prime numbers calculation written in different languages to compare performance in somewhat real world scenario.

It was not designed to be as efficient as possible, and I know there are much more efficient algorithms fot the task. The main point is to write essentially the same processing logic and compare performance depending on language.

For my Dell Latitude 5590 Intel Core i7 8750u laptop I got next results for numbers between 1 and 100000:  
C - 0.94..1.06sec. single core.  
Rust - ? TBD  
Java - 1.04...1.2sec. single core / 0.31...0.4sec all cores (4)  
JS - 1.3...1.4sec. single core / 0.5...0.65 all cores (4)  
Python - 21...22sec. / 7...8.5 all cores (4)  

gcc - 9.3.0, Java - 16, Node - 15, Python 3.8.5, Ubuntu 20.04

For my MacBook Pro 16 2021 M1 Max I got next results for numbers between 1 and 100000:  
C - 283.3 msec. single core.  
Rust - 285.8 msec. single core.  
Java - 349.5(JDK runtime) 361.3(JRE image) msec. single core / 0.050...0.079sec all cores (10)   
JS - 521.9 msec. single core / 0.153...0.162 all cores (10)  
Python - 14.62...14.67sec. / 3.03...3.32 all cores (10)

gcc - clang 13.1.6 (arm64), rustc 1.64.0, Java - 18 (arm64), Node - 18.4, Python 3.9.7 (miniforge3-4.10.3-10), MacOS Monterey 12.4

Inspired by https://www.youtube.com/watch?v=hGyJTcdfR1E



