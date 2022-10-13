package main

import "fmt"

func main() {
	startNum, endNum := 1, 100_000
	primes := getPrimes(startNum, endNum)

	fmt.Printf("Processed %v numbers, found %v primes", endNum-startNum, len(primes))
}

func getPrimes(startNum int, endNum int) []int {
	var result []int
	for i := startNum; i <= endNum; i++ {
		if isPrime(i) {
			result = append(result, i)
		}
	}
	return result
}

func isPrime(num int) bool {
	for div := 2; div < num; div++ {
		if num%div == 0 {
			return false
		}
	}
	return true
}
