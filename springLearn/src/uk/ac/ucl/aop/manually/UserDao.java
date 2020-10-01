package uk.ac.ucl.aop.manually;

import org.springframework.stereotype.Component;

@Component
public class UserDao implements IUser {
    public void save() {
        System.out.println("Saving.......");
    }
}
