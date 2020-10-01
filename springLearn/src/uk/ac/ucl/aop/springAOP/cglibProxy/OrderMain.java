package uk.ac.ucl.aop.springAOP.cglibProxy;

import org.springframework.context.ApplicationContext;
import org.springframework.context.support.ClassPathXmlApplicationContext;

public class OrderMain {
    public static void main(String[] args) {
        ApplicationContext context =
                new ClassPathXmlApplicationContext(
                        "uk/ac/ucl/aop/springAOP/cglibProxy/cglibBeans.xml");
        OrderDao order = (OrderDao)context.getBean("orderDao");
        System.out.println(order.getClass());
        order.save();
    }
}
