import os
import sync

fn main() {
	start_number := 1
	mut end_number := 100000

	// Read endnum environment variable
	endnum_env := os.getenv('endnum')
	if endnum_env != '' {
		parsed := endnum_env.int()
		if parsed > 0 {
			end_number = parsed
		} else {
			println('endnum env value is invalid: ${endnum_env}, using default: ${end_number}')
		}
	}

	// Read mcore environment variable
	mut mcore := false
	mcore_env := os.getenv('mcore')
	if mcore_env != '' {
		trimmed := mcore_env.trim_space()
		if trimmed == 'true' {
			mcore = true
		} else {
			println('mcore env value is invalid: ${mcore_env}, using default: false')
		}
	}

	// Pre-allocate array with capacity
	mut primes := []int{len: end_number - start_number}

	primes_count := if mcore {
		get_primes_multi_core(start_number, end_number, mut primes)
	} else {
		get_primes_single_core(start_number, end_number, mut primes)
	}

	println('Processed ${end_number} numbers, found ${primes_count} prime numbers')
}

fn get_primes_single_core(start_number int, end_number int, mut primes []int) int {
	mut count := 0
	for number in start_number .. end_number {
		if is_prime(number) {
			primes[count] = number
			count++
		}
	}
	return count
}

fn get_primes_multi_core(start_number int, end_number int, mut primes []int) int {
	results_ch := chan int{cap: 10000}
	work_ch := chan int{cap: 10000}

	num_workers := 10
	mut wg := sync.new_waitgroup()

	// Spawn workers
	for _ in 0 .. num_workers {
		wg.add(1)
		spawn fn [work_ch, results_ch, mut wg] () {
			defer {
				wg.done()
			}
			for {
				number := <-work_ch or { break }
				if is_prime(number) {
					results_ch <- number
				}
			}
		}()
	}

	// Feed numbers
	for number in start_number .. end_number {
		work_ch <- number
	}
	work_ch.close()

	// Wait for all workers to finish, then close the results channel
	go fn [mut wg, results_ch] () {
		wg.wait()
		results_ch.close()
	}()

	mut count := 0
	for {
		prime := <-results_ch or { break }
		primes[count] = prime
		count++
	}

	return count
}

fn is_prime(number int) bool {
	if number == 1 {
		return false
	}
	for div in 2 .. number {
		if number % div == 0 {
			return false
		}
	}
	return true
}
