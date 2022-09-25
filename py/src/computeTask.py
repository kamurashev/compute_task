import time
import os
import sys

startTime = time.time()
startNumber = 1
endNumber = int(os.getenv('endNumber', 100000))


def find_primes():
    result = []
    for number in range(startNumber, endNumber, 1):
        if is_prime(number):
            result.append(number)
    return result


def is_prime(number):
    for div in range(2, number):
        if number % div == 0:
            return False
    return True


primes = find_primes()
completionTime = round(time.time() - startTime, 2)

print(f"Processed {endNumber} numbers, found {len(primes)} prime numbers, completion time {completionTime} s")
