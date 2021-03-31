//I really like functional approach but
//funny enough commented out code is taking whopping 190 times more time to execute, e.g. on my i7 8750u it takes 250 vs 1.32 s.

const { performance } = require('perf_hooks');
const { Worker, isMainThread } = require('worker_threads');
const os = require('os');

const startTime = performance.now();
const threads = os.cpus().length;
const startNumber = 1;
const endNumber = Number(process.env.endNumber || 10000);
const range = Math.round(endNumber / threads);

(() => {
    let primes = [];

    if(isMainThread) {
        let finished = 0;
        for (let i = 1; i <= threads; i++) {
            const startFrom = range * (i - 1) + startNumber;
            const endAt = i === threads ? endNumber : range * i;

            const computeWorker = new Worker('./ComputeWorker.js');
            computeWorker.on('message', res => {
                console.log(`Worker id: ${computeWorker.threadId} delivered result of ${res.length}, time spent ${(performance.now() - startTime) / 1000.0}`);
                primes = [...primes, ...res];
                if (++finished === threads) {
                    const completionTime = (performance.now() - startTime) / 1000.0;
                    console.log(`Processed ${endNumber} numbers, found ${primes.length} prime numbers, completion time ${completionTime} s`);
                }
            });
            computeWorker.on('error', (err => console.log(err)));

            computeWorker.postMessage([startFrom, endAt]);
        }
    }
})();
