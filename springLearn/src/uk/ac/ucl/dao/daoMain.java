package uk.ac.ucl.dao;

import org.springframework.context.ApplicationContext;
import org.springframework.context.support.ClassPathXmlApplicationContext;

public class daoMain {
    public static void main(String[] args) {
        ApplicationContext context =
                new ClassPathXmlApplicationContext("uk/ac/ucl/dao/daoBeans.xml");
        UserDao dao = (UserDao)context.getBean("userDao");
        //dao.save();
        dao.query(10);
    }
}
