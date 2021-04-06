# compute_task
C, Java, JS, Python folded loop based prime numbers calculation written in different languages to compare performance in somewhat real world scenario.

The code is written in simplest possible way and not utilizes multi-threded (multi-cpu) processing, it is executed by one cpu core for all the languages.

It was not designed to be as efficient as possible and I know there are much more efficient algorithms fot the task. The main point is to write essentially
the same processing logic and compare performance depending on language.

For my Dell Latitude 5590 Intel Core i7 8750u laptop I got next results for numbers betwen 1 and 100000:
C - 0.94..1.06sec. single core.
Java - 1.04...1.2sec. single core / 0.31...0.4sec all cores (4)
JS - 1.3...1.4sec. single core / 0.5...0.65 all cores (4)
Python - 21...22sec. / 7...8.5 all cores (4)

gcc - 9.3.0, Java - 16, Node - 15, Python 3.8.5, Ubuntu 20.04

<strong>Inspired by</strong> https://www.youtube.com/watch?v=hGyJTcdfR1E

