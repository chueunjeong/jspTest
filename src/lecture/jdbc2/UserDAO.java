package lecture.jdbc2;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;
import lecture1.DB;
import lecture.jdbc2.User;

public class UserDAO {

	public static List<User> findAll(int currentPage, int pageSize) throws Exception {
        String sql = "SELECT u.*, d.departmentName" +
                     " FROM user u LEFT JOIN department d ON u.departmentId = d.id" +
                     " LIMIT ?, ?";
        try (Connection connection = DB.getConnection("student1");
             PreparedStatement statement = connection.prepareStatement(sql)) {
            statement.setInt(1, (currentPage - 1) * pageSize);
            statement.setInt(2, pageSize);
            try (ResultSet resultSet = statement.executeQuery()) {
                ArrayList<User> list = new ArrayList<User>();
                while (resultSet.next()) {
                	 User user = new User();
                     user.setId(resultSet.getInt("id"));
                     user.setUserid(resultSet.getString("userid"));
                     user.setPassword(resultSet.getString("password"));
                     user.setName(resultSet.getString("name"));
                     user.setEmail(resultSet.getString("email"));
                     user.setDepartmentId(resultSet.getInt("departmentId"));
                     user.setDepartmentName(resultSet.getString("departmentName"));
                     user.setUserType(resultSet.getString("userType"));
                     list.add(user);
                }
                return list;
            }
        }
    }

    public static int count() throws Exception {
        String sql = "SELECT COUNT(*) FROM user";
        try (Connection connection = DB.getConnection("student1");
             PreparedStatement statement = connection.prepareStatement(sql);
             ResultSet resultSet = statement.executeQuery()) {
                if (resultSet.next())
                    return resultSet.getInt(1);
        }
        return 0;
    }

}
