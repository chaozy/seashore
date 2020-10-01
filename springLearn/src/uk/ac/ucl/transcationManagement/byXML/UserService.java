package uk.ac.ucl.transcationManagement.byXML;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

@Service
public class UserService {
    @Autowired
    private UserDAO dao;

    public void save() {
        dao.save(3);
        int i = 1 / 0;
        dao.save(3);
    }
}
