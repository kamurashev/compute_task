/*
*  Ref: https://www.youtube.com/watch?v=hGyJTcdfR1E&t=53s
*  @author is @Snowbat Snowbat YouTube member, copy-pasted from https://pastepin.com/fAjwP61f
*  Version in C with the following mods
*  - Does not store Primes in an array (Python version does but print statement is commented out). As the size of an array needs to be specified when declaring in C, I dropped this for simplicity. I also commented-out the array code in the Python version to check the performance and the change was not huge (66.54 with array populating vs 54.03 without on this box).
*  - The Python version incorrectly counts 1 as Prime. The sample C code I found checks for this so I left the check in.
*/

#include <time.h>
#include <stdio.h>
#include <stdbool.h>

#define startNumber 1
#define endNumber 100000

bool isPrime(int);
void findPrimes(void);

int primes[endNumber];
int primesIndex = 0;

int main()
{
    clock_t tic = clock();

    findPrimes();

    clock_t toc = clock();
    printf("Processed %d numbers, found %d prime numbers, completion time %f s\n",
    endNumber, primesIndex, (double)(toc - tic) / CLOCKS_PER_SEC);

    return 0;
}

void findPrimes()
{
    for(int number = startNumber; number <= endNumber; number++)
    {
       if(isPrime(number))
       {
          primes[primesIndex] = number;
          primesIndex++;
       }
    }
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