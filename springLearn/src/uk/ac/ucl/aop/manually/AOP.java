package uk.ac.ucl.aop.manually;

import org.springframework.stereotype.Component;

@Component
public class AOP {
    public void begin() {
        System.out.println("Event begins......");
    }

    public void end() {
        System.out.println("Event finishes.......");
    }
}
