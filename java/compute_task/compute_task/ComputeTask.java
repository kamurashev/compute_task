package compute_task;

import java.util.ArrayList;
import java.util.List;
//import java.util.concurrent.Callable;
//import java.util.concurrent.ExecutionException;
//import java.util.concurrent.ExecutorService;
//import java.util.concurrent.Executors;
//import java.util.concurrent.Future;
import java.util.concurrent.atomic.AtomicInteger;
//import java.util.stream.Collectors;
//import java.util.stream.IntStream;

public class ComputeTask {
    private static final int START_NUMBER = 1;
    private static final int END_NUMBER =
            System.getenv("endnum") == null ? 100000 : Integer.parseInt(System.getenv("endnum"));
    private static final boolean M_CORE =
            System.getenv("mcore") != null && Boolean.parseBoolean(System.getenv("mcore"));

    private List<Integer> findPrimesMultiCore() throws InterruptedException {
        int cores = Runtime.getRuntime().availableProcessors();
        AtomicInteger nextNumber = new AtomicInteger(START_NUMBER);
        List<List<Integer>> chunkResults = new ArrayList<>(cores);
        List<Thread> threads = new ArrayList<>(cores);

        for (int i = 0; i < cores; i++) {
            List<Integer> localResult = new ArrayList<>(END_NUMBER - START_NUMBER);
            chunkResults.add(localResult);
            Thread thread = new Thread(() -> {
                while (true) {
                    int number = nextNumber.getAndIncrement();
                    if (number >= END_NUMBER) {
                        break;
                    } 
                    if (isPrime(number)) {
                        localResult.add(number);
                    }
                }
            });
            threads.add(thread);
            thread.start();
        }

        for (Thread thread : threads) {
            thread.join();
        }

        List<Integer> result = new ArrayList<>(END_NUMBER - START_NUMBER);
        for (List<Integer> chunk : chunkResults) {
            result.addAll(chunk);
        }
        return result;
    }

//    private List<Integer> findPrimesMultiCoreParallelStream() {
//        return IntStream.range(START_NUMBER, END_NUMBER)
//                .parallel()
//                .filter(this::isPrime)
//                .boxed()
//                .collect(Collectors.toList());
//    }
//
//    private List<Integer> findPrimesWithThreadPoolDynamic() throws InterruptedException, ExecutionException {
//        int cores = Runtime.getRuntime().availableProcessors();
//        ExecutorService executor = Executors.newFixedThreadPool(cores);
//        AtomicInteger nextNumber = new AtomicInteger(START_NUMBER);
//        List<Callable<List<Integer>>> tasks = new ArrayList<>(cores);
//
//        for (int i = 0; i < cores; i++) {
//            tasks.add(() -> {
//                List<Integer> primes = new ArrayList<>(END_NUMBER - START_NUMBER);
//                while (true) {
//                    int number = nextNumber.getAndIncrement();
//                    if (number >= END_NUMBER) {
//                        break;
//                    }
//                    if (isPrime(number)) {
//                        primes.add(number);
//                    }
//                }
//                return primes;
//            });
//        }
//
//        List<Future<List<Integer>>> futures = executor.invokeAll(tasks);
//        List<Integer> result = new ArrayList<>(END_NUMBER - START_NUMBER);
//        for (Future<List<Integer>> future : futures) {
//            result.addAll(future.get());
//        }
//
//        executor.shutdown();
//        return result;
//    }

    private List<Integer> findPrimesSingleCore() {
        List<Integer> result = new ArrayList<>(END_NUMBER - START_NUMBER);
        for (int number = START_NUMBER; number < END_NUMBER; number++) {
            if (isPrime(number)) {
                result.add(number);
            }
        }
        return result;
    }

    private boolean isPrime(int number) {
        if (number == 1) {
            return false;
        }
        for (int div = 2; div < number; div++) {
            if(number % div == 0) {
                return false;
            }
        }
        return true;
    }

    public static void main(String[] args) throws InterruptedException {
        ComputeTask computeTask = new ComputeTask();
//        List<Integer> primes = M_CORE ? computeTask.findPrimesWithThreadPoolDynamic() : computeTask.findPrimesSingleCore();
//        List<Integer> primes = M_CORE ? computeTask.findPrimesMultiCoreParallelStream() : computeTask.findPrimesSingleCore();
         List<Integer> primes = M_CORE ? computeTask.findPrimesMultiCore() : computeTask.findPrimesSingleCore();
        System.out.printf("Processed %d numbers, found %d prime numbers", END_NUMBER - START_NUMBER, primes.size());
    }
}
