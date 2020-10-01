package uk.ac.ucl.beanPostProcessor;

import org.springframework.context.support.AbstractApplicationContext;
import org.springframework.context.support.ClassPathXmlApplicationContext;

public class BeanPostProcessorMain {
    public static void main(String[] args) {
        AbstractApplicationContext context = new ClassPathXmlApplicationContext(
                "uk/ac/ucl/beanPostProcessor/BeanPostProcessorConfig.xml");
        Country country = (Country) context.getBean("country");
        System.out.println("Country is " + country.getCountryName());
        context.registerShutdownHook();
    }
}
