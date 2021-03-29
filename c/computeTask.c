/*
*  Ref: https://www.youtube.com/watch?v=hGyJTcdfR1E&t=53s
*  @author is @Snowbat Snowbat YouTube member, copy-pasted from https://pastepin.com/fAjwP61f
*  Version in C with the following mods
*  - Does not store Primes in an array (Python version does but print statement is commented out). As the size of an array needs to be specified when declaring in C, I dropped this for simplicity. I also commented-out the array code in the Python version to check the performance and the change was not huge (66.54 with array populating vs 54.03 without on this box).
*  - The Python version incorrectly counts 1 as Prime. The sample C code I found checks for this so I left the check in.
*/

#include <time.h>
#include <stdio.h>

int main()
{
        clock_t tic = clock();

        int end_number = 100000;
        int div_number, candidate_number, count, noPrimes = 0;

        printf("Prime numbers from 1 to %d\n", end_number);
        for(candidate_number = 1; candidate_number <= end_number; candidate_number++) {
                count = 0;
                for (div_number = 2; div_number < candidate_number; div_number++) {
                        if(candidate_number%div_number == 0) {
                                count++;
                                break;
                        }
                }
                if(count == 0 && candidate_number != 1 ) {
                        //printf(" %d ", candidate_number);
                        noPrimes++;
                }
        }
        printf("Number of primes is %d\n", noPrimes);

        clock_t toc = clock();
        printf("Time elapsed: %f seconds\n", (double)(toc - tic) / CLOCKS_PER_SEC);

        return 0;
}