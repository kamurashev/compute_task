#include <stdio.h>
#include <stdbool.h>
#include <stdlib.h>
#include <string.h>
#include <omp.h>

bool isPrime(int);
void getPrimesSingleCore(int, int, int*, int*);
void getPrimesMultiCore(int, int, int*, int*);

int main()
{
    int start_number = 2;
    int end_number = 100000;

    // Read endnum environment variable
    char *endnum_env = getenv("endnum");
    if (endnum_env != NULL) {
        int parsed = atoi(endnum_env);
        if (parsed > 0) {
            end_number = parsed;
        } else {
            printf("endnum env value is invalid: %s, using default: %d\n", endnum_env, end_number);
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

    int *primes = malloc((end_number - start_number) * sizeof(int));
    int primes_count = 0;

    if (mcore) {
        getPrimesMultiCore(start_number, end_number, primes, &primes_count);
    } else {
        getPrimesSingleCore(start_number, end_number, primes, &primes_count);
    }

    printf("Processed %d numbers, found %d prime numbers\n", end_number, primes_count);

    free(primes);
    return 0;
}

void getPrimesSingleCore(int start_number, int end_number, int *primes, int *primes_count)
{
    for (int number = start_number; number < end_number; number++)
    {
        if (isPrime(number))
        {
            primes[(*primes_count)++] = number;
        }
    }
}

void getPrimesMultiCore(int start_number, int end_number, int *primes, int *primes_count)
{
    #pragma omp parallel for schedule(dynamic)
    for (int number = start_number; number < end_number; number++)
    {
        if (isPrime(number))
        {
            #pragma omp critical
            {
                primes[(*primes_count)++] = number;
            }
        }
    }
}

bool isPrime(int number)
{
    for (int div = 2; div < number; div++)
    {
        if (number % div == 0)
        {
            return false;
        }
    }
    return true;
}