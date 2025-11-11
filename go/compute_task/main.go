package main

import (
	"fmt"
	"os"
	"runtime"
	"strconv"
	"sync"
	"sync/atomic"
)

func main() {
	startNum, endNum := 1, 100_000
	// Read endnum environment variable
	if endNumEnv, err := strconv.Atoi(os.Getenv("endnum")); err == nil && endNumEnv > 0 {
		endNum = endNumEnv
	}

	// Read mcore environment variable
	mcore := false
	if mcoreEnv := os.Getenv("mcore"); mcoreEnv == "true" {
		mcore = true
	}

	var primes []int
	if mcore {
		primes = getPrimesMultiCore(startNum, endNum)
	} else {
		primes = getPrimesSingleCore(startNum, endNum)
	}

	fmt.Printf("Processed %v numbers, found %v primes\n", endNum, len(primes))
}

func getPrimesSingleCore(startNum int, endNum int) []int {
	var result []int
	for i := startNum; i < endNum; i++ {
		if isPrime(i) {
			result = append(result, i)
		}
	}
	return result
}

func getPrimesMultiCore(startNum int, endNum int) []int {
	numWorkers := runtime.NumCPU()
	chunkResults := make([][]int, numWorkers)
	var wg sync.WaitGroup
	var nextNum atomic.Int64
	nextNum.Store(int64(startNum))

	for w := 0; w < numWorkers; w++ {
		wg.Add(1)
		go func(workerID int) {
			defer wg.Done()
			localPrimes := []int{}
			for {
				num := nextNum.Add(1) - 1
				if num >= int64(endNum) {
					break
				}
				if isPrime(int(num)) {
					localPrimes = append(localPrimes, int(num))
				}
			}
			chunkResults[workerID] = localPrimes
		}(w)
	}

	wg.Wait()

	var primes []int
	for _, chunk := range chunkResults {
		primes = append(primes, chunk...)
	}
	return primes
}

/*
func getPrimesMultiCoreChannel(startNum int, endNum int) []int {
	numWorkers := runtime.NumCPU()
	jobs := make(chan int, endNum-startNum)
	results := make(chan int, endNum-startNum)
	var wg sync.WaitGroup

	for w := 0; w < numWorkers; w++ {
		wg.Add(1)
		go func() {
			defer wg.Done()
			for job := range jobs {
				if isPrime(job) {
					results <- job
				}
			}
		}()
	}

	for i := startNum; i < endNum; i++ {
		jobs <- i
	}
	close(jobs)

	wg.Wait()
	close(results)

	var primes []int
	for prime := range results {
		primes = append(primes, prime)
	}
	return primes
}
*/

func isPrime(num int) bool {
	if num == 1 {
		return false
	}
	for div := 2; div < num; div++ {
		if num%div == 0 {
			return false
		}
	}
	return true
}
