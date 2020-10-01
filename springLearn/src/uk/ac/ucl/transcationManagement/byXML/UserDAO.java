package uk.ac.ucl.transcationManagement.byXML;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Component;

@Component
public class UserDAO implements IUser {
    @Autowired
    private JdbcTemplate template;

    @Override
    public void save(int id) {
        String sql = "insert into category(id, name) values ('" + id + "', 'RENT')";
        template.update(sql);
    }
}
