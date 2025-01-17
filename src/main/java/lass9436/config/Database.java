package lass9436.config;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.sql.Connection;
import java.sql.SQLException;
import java.sql.Statement;

import com.mysql.cj.jdbc.MysqlConnectionPoolDataSource;

public class Database {

	private static final String url = "jdbc:mysql://host.docker.internal:3306/jsp_cafe";
	private static final String user = "user";
	private static final String password = "1234";
	private static final MysqlConnectionPoolDataSource ds = new MysqlConnectionPoolDataSource();

	static {
		try {
			Class.forName("com.mysql.cj.jdbc.Driver");
			ds.setDatabaseName("jsp_cafe");
			ds.setUser(user);
			ds.setPassword(password);
			ds.setUrl(url);
			try (Connection connection = getConnection();
				 Statement statement = connection.createStatement()) {
				executeSqlFile(statement, "schema.sql");
			}
		} catch (ClassNotFoundException e) {
			throw new RuntimeException("Failed to load MySQL driver", e);
		} catch (SQLException | IOException e) {
			throw new RuntimeException("Failed to SQL", e);
		}
	}

	public static Connection getConnection() throws SQLException {
		return ds.getConnection();
	}

	private static void executeSqlFile(Statement statement, String fileName) throws SQLException, IOException {
		try (BufferedReader reader = new BufferedReader(new InputStreamReader(
			Database.class.getClassLoader().getResourceAsStream(fileName)))) {
			String line;
			StringBuilder sql = new StringBuilder();
			while ((line = reader.readLine()) != null) {
				sql.append(line).append("\n");
			}
			for (String sqlStatement : sql.toString().split(";")) {
				if (!sqlStatement.trim().isEmpty()) {
					statement.execute(sqlStatement);
				}
			}
		}
	}
}
