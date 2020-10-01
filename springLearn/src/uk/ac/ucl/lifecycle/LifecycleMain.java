package uk.ac.ucl.lifecycle;

import org.springframework.context.support.AbstractApplicationContext;
import org.springframework.context.support.ClassPathXmlApplicationContext;

public class LifecycleMain {
    public static void main(String[] args) {
        AbstractApplicationContext context = new ClassPathXmlApplicationContext("uk/ac/ucl/lifecycle/lifecycleBeans.xml");
        Lifecycle lifecycle = (Lifecycle) context.getBean("lifecycle");
        System.out.println("-----------------------------------------");
        context.registerShutdownHook();
        // Here you need to register a shutdown hook registerShutdownHook() method
        // that is declared on the AbstractApplicationContext class.
        // This will ensures a graceful shutdown and calls the relevant destroy methods
    }
}
