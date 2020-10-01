package uk.ac.ucl.aop.springAOP.cglibProxy;

import org.springframework.stereotype.Component;

@Component
public class OrderDao {
    public void save() {
        System.out.println("Order is Saving.......");
    }
}
