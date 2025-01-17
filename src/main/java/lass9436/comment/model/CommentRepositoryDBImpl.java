package lass9436.comment.model;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;

import lass9436.config.Database;

public class CommentRepositoryDBImpl implements CommentRepository {

	@Override
	public Comment save(Comment comment) {
		String sqlInsert = "INSERT INTO comments (userSeq, questionSeq, writer, contents) VALUES (?, ?, ?, ?)";
		String sqlUpdate = "UPDATE comments SET userSeq = ?, questionSeq = ?, writer = ?, contents = ? WHERE commentSeq = ?";
		boolean isInsert = comment.getCommentSeq() == 0;

		try (Connection conn = Database.getConnection();
			 PreparedStatement ps = isInsert ?
				 conn.prepareStatement(sqlInsert, Statement.RETURN_GENERATED_KEYS) :
				 conn.prepareStatement(sqlUpdate)) {

			ps.setLong(1, comment.getUserSeq());
			ps.setLong(2, comment.getQuestionSeq());
			ps.setString(3, comment.getWriter());
			ps.setString(4, comment.getContents());

			if (!isInsert) {
				ps.setLong(5, comment.getCommentSeq());
			}

			ps.executeUpdate();

			if (isInsert) {
				try (ResultSet generatedKeys = ps.getGeneratedKeys()) {
					if (generatedKeys.next()) {
						comment.setCommentSeq(generatedKeys.getLong(1));
					}
				}
			}
		} catch (SQLException e) {
			e.printStackTrace();
		}

		return comment;
	}

	@Override
	public Comment findByCommentSeq(long commentSeq) {
		String sql = "SELECT * FROM comments WHERE commentSeq = ? AND useYn = 'Y'";
		Comment comment = null;

		try (Connection conn = Database.getConnection();
			 PreparedStatement ps = conn.prepareStatement(sql)) {
			ps.setLong(1, commentSeq);

			try (ResultSet rs = ps.executeQuery()) {
				if (rs.next()) {
					comment = mapRow(rs);
				}
			}
		} catch (SQLException e) {
			e.printStackTrace();
		}

		return comment;
	}

	@Override
	public List<Comment> findAll() {
		String sql = "SELECT * FROM comments WHERE useYn = 'Y'";
		List<Comment> comments = new ArrayList<>();

		try (Connection conn = Database.getConnection();
			 PreparedStatement ps = conn.prepareStatement(sql);
			 ResultSet rs = ps.executeQuery()) {

			while (rs.next()) {
				comments.add(mapRow(rs));
			}
		} catch (SQLException e) {
			e.printStackTrace();
		}

		return comments;
	}

	@Override
	public void deleteByCommentSeq(long commentSeq) {
		String sql = "UPDATE comments SET useYn = 'N' WHERE commentSeq = ?";

		try (Connection conn = Database.getConnection();
			 PreparedStatement ps = conn.prepareStatement(sql)) {
			ps.setLong(1, commentSeq);
			ps.executeUpdate();
		} catch (SQLException e) {
			e.printStackTrace();
		}
	}

	@Override
	public List<Comment> findByQuestionSeq(long questionSeq) {
		String sql = "SELECT * FROM comments WHERE questionSeq = ? AND useYn ='Y'";
		List<Comment> comments = new ArrayList<>();

		try (Connection conn = Database.getConnection();
			 PreparedStatement ps = conn.prepareStatement(sql)) {
			ps.setLong(1, questionSeq);

			try (ResultSet rs = ps.executeQuery()) {
				while (rs.next()) {
					comments.add(mapRow(rs));
				}
			}
		} catch (SQLException e) {
			e.printStackTrace();
		}

		return comments;
	}

	@Override
	public List<Comment> findRangeByQuestionSeq(long questionSeq, long startCommentSeq, int count) {
		String sql = "SELECT * FROM comments WHERE questionSeq = ? AND commentSeq < ? AND useYn = 'Y' ORDER BY commentSeq DESC LIMIT ?";
		List<Comment> comments = new ArrayList<>();

		try (Connection conn = Database.getConnection();
			 PreparedStatement ps = conn.prepareStatement(sql)) {

			ps.setLong(1, questionSeq);
			ps.setLong(2, startCommentSeq);
			ps.setInt(3, count);

			try (ResultSet rs = ps.executeQuery()) {
				while (rs.next()) {
					comments.add(mapRow(rs));
				}
			}
		} catch (SQLException e) {
			e.printStackTrace();
		}

		return comments;
	}

	@Override
	public long countByQuestionSeq(long questionSeq) {
		String query = "SELECT COUNT(*) FROM comments WHERE questionSeq = ? and useYn = 'Y'";
		long count = 0;

		try (Connection connection = Database.getConnection();
			 PreparedStatement ps = connection.prepareStatement(query);) {

			ps.setLong(1, questionSeq);
			ResultSet resultSet = ps.executeQuery();

			if (resultSet.next()) {
				count = resultSet.getLong(1);
			}

		} catch (SQLException e) {
			e.printStackTrace();
		}

		return count;
	}

	private Comment mapRow(ResultSet rs) throws SQLException {
		Comment comment = new Comment();
		comment.setCommentSeq(rs.getLong("commentSeq"));
		comment.setUserSeq(rs.getLong("userSeq"));
		comment.setQuestionSeq(rs.getLong("questionSeq"));
		comment.setWriter(rs.getString("writer"));
		comment.setContents(rs.getString("contents"));
		comment.setUseYn(rs.getString("useYn"));
		return comment;
	}
}
