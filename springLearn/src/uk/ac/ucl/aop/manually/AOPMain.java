package uk.ac.ucl.aop.manually;

import org.springframework.context.ApplicationContext;
import org.springframework.context.support.ClassPathXmlApplicationContext;

public class AOPMain {
    public static void main(String[] args) {
        ApplicationContext context =
                new ClassPathXmlApplicationContext("uk/ac/ucl/aop/manually/beans.xml");
        IUser iUser = (IUser)context.getBean("proxy");
        iUser.save();
    }
}
