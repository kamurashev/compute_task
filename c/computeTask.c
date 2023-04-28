#include <time.h>
#include <stdio.h>
#include <stdbool.h>
#include <stdlib.h>
#include <omp.h>

int startNumber = 1;
int endNumber = 100000;

int *primes;
int primesCount = 0;

bool isPrime(int);

int main()
{
    clock_t tic = clock();

    primes = malloc(endNumber * sizeof(int));
    #pragma omp parallel for schedule(dynamic)
    for (int number = startNumber; number <= endNumber; number++)
    {
        if (isPrime(number))
        {
            #pragma omp critical
            {
                primes[primesCount++] = number;
            }
        }
    }

    for(int i = 0; i < primesCount; i++)
    {
        printf("%d ", primes[i]);
    }

    clock_t toc = clock();
    printf("Processed %d numbers, found %d prime numbers, completion time %f s\n",
    endNumber, primesCount, (double)(toc - tic) / CLOCKS_PER_SEC);

    free(primes);
    return 0;
}

bool isPrime(int number)
{
    for (int div = 2; div < number; div++)
    {
        if(number % div == 0)
        {
            return false;
        }
    }
    return true;
}
