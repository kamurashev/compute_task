const { performance } = require('perf_hooks');

const startTime = performance.now();
const startNumber = 1;
const endNumber = Number(process.env.endNumber || 10000);

let primes;
let completionTime;

const findPrimes = () => {
    primes = [...Array(endNumber).keys()].slice(startNumber).filter(number => isPrime(number));
    completionTime = (performance.now() - startTime) / 1000.0;
}

const isPrime = (number) => {
    return ![...Array(number - 1).keys()].slice(2).some(div => number % div === 0);
}

(() => {
    findPrimes();
    console.log(`Processed ${endNumber} numbers, found ${primes.length} prime numbers, completion time ${completionTime} s`);
})();


