import java.util.ArrayList;
import java.util.List;
import java.util.concurrent.CompletableFuture;
import java.util.function.Supplier;

/**
 * commented out lambda style code is taking approx. 50-100% more time to execute, though it looks nicer,
 * e.g. 1.5...2.1s vs 1.06...1.2s on my Dell latitude 5590 i7 8750u
 * so when you write your code you can choose either performance or younger look huh?)
 *
 * @author Kirill Murashev <krill.murashev@gmail.com>
 */
public class ComputeTask {
    private static final long START_TIME = System.currentTimeMillis();
    private static final int THREADS = System.getenv("threads") == null ?
            Runtime.getRuntime().availableProcessors() : Integer.parseInt(System.getenv("threads"));
    private static final int START_NUMBER = 1;
    private static final int END_NUMBER = System.getenv("endNumber") == null ?
            10000 : Integer.parseInt(System.getenv("endNumber"));
    private static final int RANGE = END_NUMBER / THREADS;

    private static class AsyncComputeTask implements Supplier<List<Integer>> {
        private final int startNumber;
        private final int endNumber;

        public AsyncComputeTask(int startNumber, int endNumber) {
            this.startNumber = startNumber;
            this.endNumber = endNumber;
        }

        @Override
        public List<Integer> get() {
            final List<Integer> result = new ArrayList<>(endNumber);
            for (int number = startNumber; number <= endNumber; number++) {
                if (isPrime(number)) {
                    result.add(number);
                }
            }
            System.out.printf("Worker id: %s delivered result of %d, time spent %f s%n",
                              Thread.currentThread().getId(), result.size(), getExecutionTime());
            return result;
        }

        private boolean isPrime(int number) {
            for (int div = 2; div < number; div++) {
                if (number % div == 0) {
                    return false;
                }
            }
            return true;
        }
    }

    public static void main(String[] args) {
        ArrayList<CompletableFuture<List<Integer>>> asyncTasks = new ArrayList<>(THREADS);
        for (int i = 1; i <= THREADS; i++) {
            int endNumber = i == THREADS ? END_NUMBER : RANGE * i;
            int startFrom = RANGE * (i - 1) + START_NUMBER;
            asyncTasks.add(CompletableFuture.supplyAsync(new AsyncComputeTask(startFrom, endNumber)));
        }

        List<Integer> primes = new ArrayList<>(END_NUMBER);
        for (CompletableFuture<List<Integer>> asyncTask : asyncTasks) {
            primes.addAll(asyncTask.join());
        }

        System.out.printf("Processed %d numbers, found %d prime numbers, completion time %f s%n",
                          END_NUMBER, primes.size(), getExecutionTime());
    }

    private static Double getExecutionTime() {
        return  (System.currentTimeMillis() - START_TIME) / 1000.0;
    }
}
