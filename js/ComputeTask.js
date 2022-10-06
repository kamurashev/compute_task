//for thread workers multiprocessing on my i7 8750u it takes 0.5-0.65s for the range of 100 000.

const { performance } = require('perf_hooks');
const { Worker, isMainThread } = require('worker_threads');
const os = require('os');

const startTime = performance.now();
const threads = os.cpus().length;
const startNumber = 1;
const endNumber = Number(process.env.endNumber || 100000);

const workers = [];
const primes = [];

const finish = () => {
    const completionTime = (performance.now() - startTime) / 1000.0;
    console.log(`Processed ${endNumber} numbers, found ${primes.length} prime numbers, completion time ${completionTime} s`);

    workers.forEach(worker => {
      worker.unref();
    });
}

(() => {
    if(isMainThread) {
        let finished = 0;
        for (let i = 1; i <= threads; i++) {
            const computeWorker = new Worker('./ComputeWorker.js', { workerData: {endNumber: endNumber, threads: threads} });
            computeWorker.on('error', (err => console.error(err)));
            computeWorker.on('message', res => {
                if(res === 'finish') {
                    ++finished === threads && finish();
                    return;
                }
                primes.push(res);
            });
            workers.push(computeWorker);
        }

        for (let i = startNumber, n = 0; i <= endNumber; i++, n++) {
            workers[n].postMessage(i);
            if (n === threads - 1) {
                n = 0;
            }
        }
    }
})();
