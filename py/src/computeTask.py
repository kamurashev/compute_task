import os
import multiprocessing
from multiprocessing import Pool, Value
import ctypes

start_number = 2
end_number = int(os.getenv('endnum', 100000))
mcore = os.getenv('mcore', 'false').strip().lower() == 'true'


def is_prime(number):
    if number == 1:
        return False
    for div in range(2, number):
        if number % div == 0:
            return False
    return True


def find_primes_single_core():
    result = []
    for number in range(start_number, end_number):
        if is_prime(number):
            result.append(number)
    return result


# Global atomic counter for multicore processing
next_number = None


def init_worker(counter):
    global next_number
    next_number = counter


def worker_process(_):
    local_primes = []
    while True:
        with next_number.get_lock():
            number = next_number.value
            next_number.value += 1

        if number >= end_number:
            break

        if is_prime(number):
            local_primes.append(number)

    return local_primes


def find_primes_multi_core():
    num_cores = multiprocessing.cpu_count()
    counter = Value(ctypes.c_int, start_number)

    with Pool(processes=num_cores, initializer=init_worker, initargs=(counter,)) as pool:
        results = pool.map(worker_process, range(num_cores))

    # Flatten results
    primes = []
    for result in results:
        primes.extend(result)

    return primes


if __name__ == '__main__':
    primes = find_primes_multi_core() if mcore else find_primes_single_core()
    print(f"Processed {end_number} numbers, found {len(primes)} prime numbers")
