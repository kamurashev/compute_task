package main

import (
	"fmt"
	"runtime"
	"sort"
	"sync"
)

func main() {
	startNum, endNum := 1, 100_000

	// Determine the number of CPUs available
	numCPU := runtime.NumCPU()

	// Calculate the range size for each worker
	rangeSize := (endNum - startNum + 1) / numCPU

	// Create a channel with a buffer size to collect prime numbers
	channel := make(chan int, rangeSize)

	// Launch workers
	var wg sync.WaitGroup
	for i := 0; i < numCPU; i++ {
		wg.Add(1)
		go worker(i, numCPU, startNum, endNum, rangeSize, channel, &wg)
	}

	// Wait for workers to finish and close channel
	wg.Wait()
	close(channel)

	// Collect results
	primes := make([]int, 0, endNum-startNum)
	for prime := range channel {
		primes = append(primes, prime)
	}

	// Print results
	fmt.Printf("Processed %v numbers, found %v primes\n", endNum-startNum, len(primes))
	sort.Ints(primes)
	fmt.Println(primes)
}

func worker(id, numWorkers, startNum, endNum, rangeSize int, channel chan<- int, wg *sync.WaitGroup) {
	defer wg.Done()

	// Determine the range of numbers to check for primality
	start := startNum + id*rangeSize
	end := start + rangeSize - 1
	if id == numWorkers-1 {
		end = endNum
	}

	// Check for primality and send primes to channel
	for i := start; i <= end; i++ {
		if isPrime(i) {
			channel <- i
		}
	}
}

func isPrime(num int) bool {
	if num < 2 {
		return false
	}
	for div := 2; div <= num; div++ {
		if num%div == 0 {
			return false
		}
	}
	return true
}
