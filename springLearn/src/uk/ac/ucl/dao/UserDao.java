package uk.ac.ucl.dao;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.core.RowMapper;
import org.springframework.stereotype.Component;
import uk.ac.ucl.aop.manually.IUser;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.List;

@Component
public class UserDao implements IUser {
    @Autowired
    private JdbcTemplate template;

    @Override
    public void save() {
        String sql = "insert into Category(id, name) values (10, 'ENTERTAINMENT')";
        template.update(sql);
    }

    public void query(int id) {
        String sql = "select * from category where id = ? or id = ?";
        List<User> query = template.query(sql, new RowMapper<User>() {
            @Override
            public User mapRow(ResultSet resultSet, int i) throws SQLException {
                User user = new User();
                user.setID(resultSet.getInt("id"));
                user.setCategory(resultSet.getString("name"));
                return user;
            }
        }, id, 18);

        System.out.println(query);

    }
}
