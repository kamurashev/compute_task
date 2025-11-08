#include <time.h>
#include <stdio.h>
#include <stdbool.h>
#include <stdlib.h>
#include <string.h>
#include <omp.h>

int startNumber = 2;
int endNumber = 100000;

int *primes;
int primesCount = 0;

bool isPrime(int);

int main()
{
    // Read endnum environment variable
    char *endnum_env = getenv("endnum");
    if (endnum_env != NULL) {
        int parsed = atoi(endnum_env);
        if (parsed > 0) {
            endNumber = parsed;
        } else {
            printf("endnum env value is invalid: %s, using default: %d\n", endnum_env, endNumber);
        }
    }

    // Read mcore environment variable
    bool mcore = false;
    char *mcore_env = getenv("mcore");
    if (mcore_env != NULL) {
        // Trim whitespace and check if it's "true"
        while (*mcore_env == ' ' || *mcore_env == '\t' || *mcore_env == '\r' || *mcore_env == '\n') {
            mcore_env++;
        }
        if (strcmp(mcore_env, "true") == 0) {
            mcore = true;
        } else {
            printf("mcore env value is invalid: %s, using default: false\n", mcore_env);
        }
    }

    clock_t tic = clock();

    primes = malloc(endNumber * sizeof(int));

    if (mcore) {
        // Multi-core path with OpenMP
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
    } else {
        // Single-core path
        for (int number = startNumber; number <= endNumber; number++)
        {
            if (isPrime(number))
            {
                primes[primesCount++] = number;
            }
        }
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