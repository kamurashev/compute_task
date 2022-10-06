use std::ops::Range;

fn main() {
    let start_num = 1;
    let end_num = 100000;
    let primes = get_primes(start_num..end_num);

    println!("Processed {} numbers, found {} prime numbers", end_num, primes.len());
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
