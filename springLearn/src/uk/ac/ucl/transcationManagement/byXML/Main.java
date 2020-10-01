package uk.ac.ucl.transcationManagement.byXML;

import org.springframework.context.ApplicationContext;
import org.springframework.context.support.ClassPathXmlApplicationContext;

public class Main {
    public static void main(String[] args) {
        ApplicationContext context =
                new ClassPathXmlApplicationContext(
                        "uk/ac/ucl/transcationManagement/byXML/beans.xml");
        UserService user = (UserService) context.getBean("userService");
        user.save();
    }
}
