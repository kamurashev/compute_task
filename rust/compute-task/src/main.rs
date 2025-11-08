use std::env;
use std::sync::atomic::{AtomicUsize, Ordering};
use std::sync::Arc;
use std::thread;

fn main() {
    let start_num = 2;
    let mut end_num: usize = 100000;

    // Read endnum environment variable
    if let Ok(endnum_env) = env::var("endnum") {
        match endnum_env.parse::<usize>() {
            Ok(parsed) if parsed > 0 => end_num = parsed,
            _ => println!("endnum env value is invalid: {}, using default: {}", endnum_env, end_num),
        }
    }

    // Read mcore environment variable
    let mut mcore = false;
    if let Ok(mcore_env) = env::var("mcore") {
        if mcore_env.trim() == "true" {
            mcore = true;
        } else {
            println!("mcore env value is invalid: {}, using default: false", mcore_env);
        }
    }

    let primes = if mcore {
        get_primes_multi_core(start_num, end_num)
    } else {
        get_primes_single_core(start_num, end_num)
    };

    println!("Processed {} numbers, found {} prime numbers", end_num, primes.len());
}

fn get_primes_single_core(start_num: usize, end_num: usize) -> Vec<usize> {
    let mut result: Vec<usize> = Vec::with_capacity(end_num - start_num);
    for num in start_num..end_num {
        if is_prime(num) {
            result.push(num);
        }
    }
    result
}

fn get_primes_multi_core(start_num: usize, end_num: usize) -> Vec<usize> {
    let num_threads = thread::available_parallelism()
        .map(|n| n.get())
        .unwrap_or(1);

    // Atomic counter for dynamic work distribution
    let next_number = Arc::new(AtomicUsize::new(start_num));
    let mut handles = vec![];

    for _ in 0..num_threads {
        let next_number = Arc::clone(&next_number);
        let handle = thread::spawn(move || {
            let mut local_primes = Vec::new();
            loop {
                // Atomically get the next number to check
                let number = next_number.fetch_add(1, Ordering::Relaxed);
                if number >= end_num {
                    break;
                }
                if is_prime(number) {
                    local_primes.push(number);
                }
            }
            local_primes
        });
        handles.push(handle);
    }

    // Collect results from all threads
    let mut result = Vec::new();
    for handle in handles {
        result.extend(handle.join().unwrap());
    }

    result
}

fn is_prime(num: usize) -> bool {
    for div in 2..num {
        if num % div == 0 {
            return false;
        }
    }
    true
}
