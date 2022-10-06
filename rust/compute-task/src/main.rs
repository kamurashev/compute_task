use std::ops::Range;
use std::thread::available_parallelism;
use std::thread;

fn main() {
    const START_NUM: i32 = 1;
    const END_NUM: i32 = 100000;
    let parallelism = available_parallelism().unwrap().get();

    let mut handles = Vec::with_capacity(parallelism);
    for chunk in get_chunks(START_NUM..END_NUM, parallelism as i32) {
        let handle = thread::spawn(move || {
            return get_primes(chunk);
        });
        handles.push(handle);
    }

    let mut result = Vec::with_capacity(9593);
    for handle in handles {
        let result_chunk = handle.join().unwrap();
        result.extend(result_chunk);
    }

    println!("Processed {} numbers, found {} prime numbers", END_NUM, result.len());
}

fn get_chunks(range: Range<i32>, chunks: i32) -> Vec<Range<i32>> {
    let mut result = Vec::with_capacity(chunks as usize);
    let size = range.len() as i32 + 1;
    let mut start :i32 = range.start;
    let mut end :i32;
    for chunk in 1..chunks + 1 {
        end = chunk * size / chunks;
        result.push(start..end);
        start = end + 1;
    }
    return result
}

fn get_primes(range: Range<i32>) -> Vec<i32> {
    let mut result: Vec<i32> = Vec::with_capacity(9593);
    for num in range {
        if is_prime(num) {
            result.push(num);
        }
    }
    return result;
}

fn is_prime(num: i32) -> bool {
    for div in 2..(num - 1)  {
        if num % div == 0 {
            return false;
        }
    }
    return true;
}
