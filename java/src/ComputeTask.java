import java.time.Duration;
import java.time.LocalDateTime;
import java.util.List;
import java.util.stream.IntStream;

public class ComputeTask {
    private static final int START_NUMBER = 1;
    private static final int END_NUMBER =
            System.getenv("startNumber") == null ? 10000 : Integer.parseInt(System.getenv("startNumber"));
    private static final LocalDateTime START_TIME = LocalDateTime.now();

    private List<Integer> primes;
    private Duration completionTime;

    public ComputeTask() {
        findPrimes();
    }

    private void findPrimes() {
        primes = IntStream.rangeClosed(START_NUMBER, END_NUMBER).boxed().filter(this::isPrime).toList();
        completionTime = Duration.between(START_TIME, LocalDateTime.now());
    }

    private boolean isPrime(int current) {
        return IntStream.range(2, current).noneMatch(div -> current % div == 0);
    }

    public int getProcessedNumbers() {
        return END_NUMBER;
    }

    public List<Integer> getPrimes() {
        return primes;
    }

    public int getPrimesCount() {
        return primes.size();
    }

    public long getCompletionTimeMillis() {
        return completionTime.toMillis();
    }

    public static void main(String[] args) {
        ComputeTask computeTask = new ComputeTask();
        System.out.printf(
                "Processed %d numbers, found %d prime numbers, completion time %f s%n",
                computeTask.getProcessedNumbers(),
                computeTask.getPrimesCount(),
                computeTask.getCompletionTimeMillis() / 1000.0);
    }
}
