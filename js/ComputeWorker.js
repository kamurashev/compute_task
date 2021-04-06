const { parentPort, workerData } = require('worker_threads');

parentPort.on('message', (message) => {
    isPrime(message) && parentPort.postMessage(message);
    if (message > workerData.endNumber - workerData.threads) {
        parentPort.postMessage('finish');
    }
});

const isPrime = (number) => {
    // return ![...Array(number - 1).keys()].slice(2).some(div => number % div === 0);
    for (let div = 2; div < number; div++) {
        if(number % div === 0) {
            return false;
        }
    }
    return true;
}