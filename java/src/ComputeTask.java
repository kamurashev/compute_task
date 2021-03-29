import java.time.Duration;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;


/**
 * commented out lambda style code is taking approx. 50-100% more time to execute, though it looks nicer,
 * e.g. 1.5...2.1s vs 1.06...1.2s on my Dell latitude 5590 i7 8750u
 * so when you write your code you can choose either performance or younger look huh?)
 * @Author Kirill Murashev <krill.murashev@gmail.com>
 */
public class ComputeTask {
    private static final LocalDateTime START_TIME = LocalDateTime.now();
    private static final int START_NUMBER = 1;
    private static final int END_NUMBER =
            System.getenv("startNumber") == null ? 10000 : Integer.parseInt(System.getenv("startNumber"));

    private final List<Integer> primes;
    private final long completionTime;

    public ComputeTask() {
        primes = findPrimes();
        completionTime = Duration.between(START_TIME, LocalDateTime.now()).toMillis();
    }

    private List<Integer> findPrimes() {
        final List<Integer> result = new ArrayList<>(END_NUMBER);
//        result = IntStream.rangeClosed(START_NUMBER, END_NUMBER).boxed().filter(this::isPrime).toList();
        for (int number = START_NUMBER; number <= END_NUMBER; number++) {
            if (isPrime(number)) {
                result.add(number);
            }
        }
        return result;
    }

    private boolean isPrime(int number) {
//        return IntStream.range(2, number).noneMatch(div -> number % div == 0);
        for (int div = 2; div < number; div++) {
            if(number % div == 0) {
                return false;
            }
        }
        return true;
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
        return completionTime;
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
