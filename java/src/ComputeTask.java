import java.util.stream.Collectors;
import java.util.stream.IntStream;

/**
 * For parallel execution best performance is achieved using parallel stream
 * it is better then for loop + CompletableFeature for a negligible amount (about 0.02sec)
 * but look at that short beautiful code...
 * 0.31-0.4sec for 100 000 range on my Dell latitude 5590 i7 8750u
 * @author Kirill Murashev <krill.murashev@gmail.com>
 */
public class ComputeTask {
    private static final long START_TIME = System.currentTimeMillis();
    private static final int START_NUMBER = 1;
    private static final int END_NUMBER = System.getenv("endNumber") == null ?
            100000 : Integer.parseInt(System.getenv("endNumber"));

    public static void main(String[] args) {
        var primes = IntStream.rangeClosed(START_NUMBER, END_NUMBER).boxed()
                              .parallel().filter(ComputeTask::isPrime).collect(Collectors.toList());

        System.out.printf("Processed %d numbers, found %d prime numbers, completion time %f s%n",
                          END_NUMBER, primes.size(), (System.currentTimeMillis() - START_TIME) / 1000.0);
    }

    private static boolean isPrime(int number) {
        for (int div = 2; div < number; div++) {
            if (number % div == 0) {
                return false;
            }
        }
        return true;
    }
}