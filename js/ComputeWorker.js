const { parentPort } = require('worker_threads');

parentPort.on('message', (message) => {
    parentPort.postMessage(findPrimes(message[0], message[1]));
    parentPort.unref();
});

const findPrimes = (startNumber, endNumber) => {
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