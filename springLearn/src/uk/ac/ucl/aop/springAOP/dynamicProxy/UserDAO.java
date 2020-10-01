package uk.ac.ucl.aop.springAOP.dynamicProxy;

import org.springframework.stereotype.Component;
import uk.ac.ucl.aop.manually.IUser;

@Component
public class UserDAO implements IUser {

    @Override
    public void save() {
        System.out.println("Saving....");
    }

}
