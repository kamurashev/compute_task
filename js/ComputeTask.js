//I really like functional approach but
//funny enough commented out code is taking whopping 190 times more time to execute, e.g. on my i7 8750u it takes 250 vs 1.32 s.

const { performance } = require('perf_hooks');

const startTime = performance.now();
const startNumber = 1;
const endNumber = Number(process.env.endNumber || 100000);

let primes;
let completionTime;

const findPrimes = () => {
    const result = [];
    // result = [...Array(endNumber).keys()].slice(startNumber).filter(number => isPrime(number));
    for (let number = startNumber; number <= endNumber; number++) {
        isPrime(number) && (result.push(number));
    }
    return result;
}

const isPrime = (number) => {
    // return ![...Array(number - 1).keys()].slice(2).some(div => number % div === 0);
    for (let div = 2; div < number; div++) {
        if(number % div === 0) {
            return false;
        }
    }
    return true;
}

(() => {
    primes = findPrimes();
    completionTime = (performance.now() - startTime) / 1000.0;
    console.log(`Processed ${endNumber} numbers, found ${primes.length} prime numbers, completion time ${completionTime} s`);
})();
