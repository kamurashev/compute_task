const { Worker, isMainThread, parentPort, workerData } = require('worker_threads');
const os = require('os');

const startNumber = 2;
const endNumber = Number(process.env.endnum || 100000);
const mCore = process.env.mcore === 'true';

if (isMainThread) {
    (async () => {
        const primes = mCore ? await findPrimesMultiCore() : findPrimesSingleCore();
        console.log(`Processed ${endNumber} numbers, found ${primes.length} prime numbers`);
    })();
} else {
    const { sharedBuffer, endNumber } = workerData;
    const nextNumber = new Int32Array(sharedBuffer);
    const primes = [];

    while (true) {
        const number = Atomics.add(nextNumber, 0, 1);
        if (number >= endNumber) {
            break;
        }
        if (isPrime(number)) {
            primes.push(number);
        }
    }
    parentPort.postMessage(primes);
}

function findPrimesSingleCore() {
    const primes = [];
    // const primes = [...Array(endNumber).keys()].slice(startNumber).filter(number => isPrime(number));
    for (let number = startNumber; number < endNumber; number++) {
        if (isPrime(number)) {
            primes.push(number);
        }
    }
    return primes;
}

async function findPrimesMultiCore() {
    const numCores = os.cpus().length;
    const sharedBuffer = new SharedArrayBuffer(4);
    const nextNumber = new Int32Array(sharedBuffer);
    nextNumber[0] = startNumber;

    const results = await Promise.all(
        Array.from({ length: numCores }, () =>
            new Promise((resolve, reject) => {
                const worker = new Worker(__filename, {
                    workerData: { sharedBuffer, endNumber }
                });
                worker.on('message', resolve);
                worker.on('error', reject);
            })
        )
    );
    return results.flat();
}

function isPrime(number) {
    // return ![...Array(number - 1).keys()].slice(2).some(div => number % div === 0);
    if (number === 1) return false;
    for (let div = 2; div < number; div++) {
        if(number % div === 0) {
            return false;
        }
    }
    return true;
}