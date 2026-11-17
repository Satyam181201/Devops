public class HelloWorld {
    public static void main(String[] args) {
        System.out.println("Hello from Java!");
        System.out.println("This is a single-stage Docker build");
        
        // Simple loop to keep container running for testing
        System.out.println("Java application is running...");
        System.out.println("Press Ctrl+C to stop");
        
        try {
            Thread.sleep(Long.MAX_VALUE);
        } catch (InterruptedException e) {
            System.out.println("Application stopped");
        }
    }
}
