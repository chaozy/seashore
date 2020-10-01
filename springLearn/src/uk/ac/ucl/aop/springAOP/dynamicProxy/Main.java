package uk.ac.ucl.aop.springAOP.dynamicProxy;

import org.springframework.context.ApplicationContext;
import org.springframework.context.support.ClassPathXmlApplicationContext;
import uk.ac.ucl.aop.manually.IUser;

public class Main {
    public static void main(String[] args) {
        ApplicationContext context =
                new ClassPathXmlApplicationContext(
                        "uk/ac/ucl/aop/springAOP/beans.xml");
        IUser iUser = (IUser)context.getBean("userDAO");
        System.out.println(iUser.getClass());
        iUser.save();
    }
}
