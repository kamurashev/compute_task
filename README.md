# Compute Task - Multi-Language Prime Number Benchmark

A naive O(n²) prime number calculation benchmark to compare raw compute performance across programming languages.

## About

This benchmark implements the same prime number calculation algorithm across different languages. The implementation intentionally uses a simple algorithm (not the most efficient) to focus on language performance rather than algorithmic optimization.

**Task:** Find all prime numbers between 1 and 100,000 using trial division.

## Getting Started

Each language directory contains setup and build scripts:

```bash
cd <language>     # e.g., cd rust/compute-task
./setup.sh        # Install compiler/runtime and dependencies
./build.sh        # Compile the program (if needed)
./benchmark.sh    # Run benchmarks
```

Supports: macOS (brew), Ubuntu/Debian (apt), Arch Linux (pacman)

---

## Benchmark Results

### Dell Latitude 5590 - Intel Core i7-8750H

**Single Core Performance** (1-100,000 primes)

| Rank | Language/Runtime | Time | vs. Best |
|------|-----------------|------|----------|
| 1 | C (clang 21.1.5) | 941.6 ms | — |
| 2 | Rust 1.91.0 | 942.2 ms | 1.00x |
| 3 | Zig 0.15.2 | 942.6 ms | 1.00x |
| 4 | V 0.4.12 | 949.1 ms | 1.01x |
| 5 | Java JDK 25.0.1 | 998.0 ms | 1.06x |
| 6 | Java JRE Image 25.0.1 | 1,032.0 ms | 1.10x |
| 7 | Java GraalVM 25.0.1 | 1,055.0 ms | 1.12x |
| 8 | Bun 1.3.2 | 1,175.0 ms | 1.25x |
| 9 | Deno 2.5.6 | 1,533.0 ms | 1.63x |
| 10 | Node.js 25.2.0 | 1,651.0 ms | 1.75x |
| 11 | Go 1.25.4 | 3,476.0 ms | 3.69x |
| 12 | PyPy 3.11-7.3.19 | 4,880.0 ms | 5.18x |
| 13 | Python 3.15-dev | 20,800.0 ms | 22.09x |
| 14 | Python 3.13.3 | 27,200.0 ms | 28.89x |

**Multi-Core Performance** (4 cores)

| Rank | Language/Runtime | Time | vs. Best |
|------|-----------------|------|----------|
| 1 | Zig 0.15.2 | 179.6 ms | — |
| 2 | Rust 1.91.0 | 182.0 ms | 1.01x |
| 3 | C (clang 21.1.5) | 185.9 ms | 1.04x |
| 4 | Java GraalVM 25.0.1 | 192.0 ms | 1.07x |
| 5 | V 0.4.12 | 223.8 ms | 1.25x |
| 6 | Java JDK 25.0.1 | 285.0 ms | 1.59x |
| 7 | Java JRE Image 25.0.1 | 316.0 ms | 1.76x |
| 8 | Bun 1.3.2 | 405.0 ms | 2.25x |
| 9 | Deno 2.5.6 | 559.0 ms | 3.11x |
| 10 | Node.js 25.2.0 | 581.0 ms | 3.23x |
| 11 | Go 1.25.4 | 669.0 ms | 3.72x |
| 12 | PyPy 3.11-7.3.19 | 1,300.0 ms | 7.24x |
| 13 | Python 3.15-dev | 7,950.0 ms | 44.27x |
| 14 | Python 3.13.3 | 8,743.0 ms | 48.68x |

**System:** Arch Linux 6.13.1-arch1-1

---

### MacBook Pro 16" 2021 - Apple M1 Max

**Single Core Performance** (1-100,000 primes)

| Rank | Language/Runtime | Time | vs. Best |
|------|-----------------|------|----------|
| 1 | Zig 0.15.2 | 288.8 ms | — |
| 2 | C (clang 20.1.8) | 288.8 ms | 1.00x |
| 3 | Rust 1.91.0 | 288.9 ms | 1.00x |
| 4 | V 0.4.12 | 289.3 ms | 1.00x |
| 5 | Java GraalVM 25.0.1 | 310.1 ms | 1.07x |
| 6 | Bun 1.3.2 | 311.9 ms | 1.08x |
| 7 | Java JDK 25.0.1 | 341.1 ms | 1.18x |
| 8 | Java JRE Image 25.0.1 | 377.0 ms | 1.31x |
| 9 | Go 1.25.4 | 400.0 ms | 1.39x |
| 10 | Node.js 24.11.0 | 596.1 ms | 2.06x |
| 11 | Deno 2.5.6 | 630.8 ms | 2.18x |
| 12 | PyPy 3.11-7.3.19 | 792.8 ms | 2.75x |
| 13 | Python 3.15-dev | 9,651.0 ms | 33.42x |
| 14 | Python 3.13.3 | 14,050.0 ms | 48.65x |

**Multi-Core Performance** (10 cores)

| Rank | Language/Runtime | Time | vs. Best |
|------|-----------------|------|----------|
| 1 | Zig 0.15.2 | 39.0 ms | — |
| 2 | Rust 1.91.0 | 39.2 ms | 1.01x |
| 3 | C (clang 20.1.8) | 40.4 ms | 1.04x |
| 4 | Java GraalVM 25.0.1 | 44.9 ms | 1.15x |
| 5 | Go 1.25.4 | 53.6 ms | 1.37x |
| 6 | V 0.4.12 | 53.9 ms | 1.38x |
| 7 | Bun 1.3.2 | 87.4 ms | 2.24x |
| 8 | Java JDK 25.0.1 | 94.3 ms | 2.42x |
| 9 | Java JRE Image 25.0.1 | 123.9 ms | 3.18x |
| 10 | Node.js 24.11.0 | 126.7 ms | 3.25x |
| 11 | Deno 2.5.6 | 188.2 ms | 4.83x |
| 12 | PyPy 3.11-7.3.19 | 342.0 ms | 8.77x |
| 13 | Python 3.15-dev | 2,018.0 ms | 51.74x |
| 14 | Python 3.13.3 | 2,871.0 ms | 73.62x |

**System:** macOS 15.6

---

## Key Takeaways

- **C/Rust/Zig** deliver virtually identical performance
  - Intel: ~942ms single-core, ~183ms multi-core (4 cores)
  - M1: ~289ms single-core, ~39ms multi-core (10 cores)
- **Java GraalVM** is nearly as fast as C/Rust/Zig, significantly outperforms standard JDK
  - Intel: 1,055ms vs 998ms single-core (1.06x slower), 192ms vs 285ms multi-core (1.48x faster)
  - M1: 310ms vs 341ms single-core (1.10x faster), 45ms vs 94ms multi-core (2.09x faster)
- **Go** performs surprisingly poorly on Intel despite being a compiled language
  - Intel: 3,476ms single-core (3.7x slower than C), 669ms multi-core (3.6x slower)
  - M1: 400ms single-core (1.4x slower than C), 54ms multi-core (1.4x slower)
- **Bun** is fastest JS runtime, significantly faster than Node.js
  - Intel: 1,175ms vs 1,651ms single-core (1.4x faster), 405ms vs 581ms multi-core (1.4x faster)
  - M1: 312ms vs 596ms single-core (1.9x faster), 87ms vs 127ms multi-core (1.5x faster)
- **PyPy** dramatically outperforms CPython
  - Intel: 4,880ms vs 27,200ms single-core (5.6x faster), 1,300ms vs 8,743ms multi-core (6.7x faster)
  - M1: 793ms vs 14,050ms single-core (17.7x faster), 342ms vs 2,871ms multi-core (8.4x faster)
- **M1 Max** is significantly faster than i7-8750H
  - Single-core: 3.3x faster, Multi-core: 4.6x faster

## Credits

Inspired by [Tsoding's performance comparison](https://www.youtube.com/watch?v=hGyJTcdfR1E)
Benchmarking: [hyperfine](https://github.com/sharkdp/hyperfine)

