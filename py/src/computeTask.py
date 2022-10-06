import time
import os
import multiprocessing as mp

startTime = time.time()
startNumber = 1
endNumber = int(os.getenv('endNumber', 100000))
processes = int(os.getenv('processes', mp.cpu_count()))


def chunks(numbers, parts):
    size = len(numbers)
    start = 0
    for i in range(1, parts + 1):
        stop = i * size // parts
        yield numbers[start:stop]
        start = stop


def find_primes(numbers):
    result = []
    for number in numbers:
        if is_prime(number):
            result.append(number)
    return result


def is_prime(number):
    for div in range(2, number):
        if number % div == 0:
            return False
    return True


def main():
    with mp.Pool(processes) as pool:
        primes = sum((pool.map(find_primes, chunks(range(startNumber, endNumber), processes))), [])

    completion_time = round(time.time() - startTime, 2)
    print(f"Processed {endNumber} numbers, found {len(primes)} prime numbers, completion time {completion_time} s")


if __name__ == "__main__":
    main()
