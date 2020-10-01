package uk.ac.ucl.lifecycle;

public class Lifecycle {
    private void init() {
        System.out.println("This is the init process of a bean");
    }

    private void destroy() {
        System.out.println("This is the destroy process");
    }
}
