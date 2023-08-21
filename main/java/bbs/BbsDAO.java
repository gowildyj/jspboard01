package bbs;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;

public class BbsDAO {
	// 실제로 mySQL에 접속하는 부분
	private Connection conn; // 데이터베이스에 접근할 객체
	private ResultSet rs; // 불러온 자료를 담을 수 있는 객체

	// 생성자
	public BbsDAO() {
		try {
			String dbURL = "jdbc:mysql://localhost:3306/BBS";
			String dbID = "root";
			String dbPassword = "";
			Class.forName("com.mysql.cj.jdbc.Driver"); // mySQL 드라이버 찾는 라이브러리 추가
			conn = DriverManager.getConnection(dbURL, dbID, dbPassword); // dbURL에 dbID와 비번을 이용해서 접속하고, conn 객체에 접속한 정보를
																			// 담는다
		} catch (Exception e) {
			e.printStackTrace(); // 오류나면 오류메시지 출력
		}
	}

	public String getDate() { // 게시판 글 작성시 현재시간 가져오기
		// 여러가지 함수가 사용되기 때문에 데이터베이스 접근이 마찰이 일어나지 않게 PreparedStatement 를 안에서 구현한다
		String SQL = "SELECT NOW()";
		try {
			PreparedStatement pstmt = conn.prepareStatement(SQL); // conn 현재연결되어 있는 객체 이용
			rs = pstmt.executeQuery();
			if (rs.next()) {
				return rs.getString(1); // 현재 날짜 반환
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		return ""; // 데이터베이스 오류
	}

	public int getNext() { // 게시글 번호 가져오기
		String SQL = "SELECT bbsID FROM BBS ORDER BY bbsID DESC"; // 내림차순해서 가장 마지막 게시글 번호 가져오기
		try {
			PreparedStatement pstmt = conn.prepareStatement(SQL);
			rs = pstmt.executeQuery();
			if (rs.next()) {
				return rs.getInt(1) + 1; // 마지막 게시글 번호 +1
			}
			return 1; // 첫 번째 게시물인 경우(첫번째글)
		} catch (Exception e) {
			e.printStackTrace();
		}
		return -1; // 데이터베이스 오류
	}

	public int write(String bbsTitle, String userID, String bbsContent) { // 글 작성하기
		String SQL = "INSERT INTO BBS VALUES(?, ?, ?, ?, ?, ?)";
		try {
			PreparedStatement pstmt = conn.prepareStatement(SQL);
			pstmt.setInt(1, getNext()); // 첫번째 물음표 ? 게시글아이디
			pstmt.setString(2, bbsTitle);
			pstmt.setString(3, userID);
			pstmt.setString(4, getDate());
			pstmt.setString(5, bbsContent);
			pstmt.setInt(6, 1); // available (1)삭제 안된 상태
			return pstmt.executeUpdate();
		} catch (Exception e) {
			e.printStackTrace();
		}
		return -1; // 데이터베이스 오류
	}

	public ArrayList<Bbs> getList(int pageNumber) {
		String SQL = "SELECT * FROM BBS WHERE bbsID < ? AND bbsAvailable = 1 ORDER BY bbsID DESC LIMIT 10";
		ArrayList<Bbs> list = new ArrayList<Bbs>();
		try {
			PreparedStatement pstmt = conn.prepareStatement(SQL);
			pstmt.setInt(1, getNext() - (pageNumber - 1) * 10);
			rs = pstmt.executeQuery();
			while (rs.next()) {
				Bbs bbs = new Bbs();
				bbs.setBbsID(rs.getInt(1));
				bbs.setBbsTitle(rs.getString(2));
				bbs.setUserID(rs.getString(3));
				bbs.setBbsDate(rs.getString(4));
				bbs.setBbsContent(rs.getString(5));
				bbs.setBbsAvailable(rs.getInt(6));
				list.add(bbs);
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		return list;
	}

	public boolean nextPage(int pageNumber) {
		String SQL = "SELECT * FROM BBS WHERE bbsID < ? AND bbsAvailable = 1";
		try {
			PreparedStatement pstmt = conn.prepareStatement(SQL);
			pstmt.setInt(1, getNext() - (pageNumber - 1) * 10);
			rs = pstmt.executeQuery();
			if (rs.next()) {
				return true;
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		return false;
	}

	public Bbs getBbs(int bbsID) { // 아이디에 해당하는 게시글 불러오
		String SQL = "SELECT * FROM BBS WHERE bbsID = ?";
		try {
			PreparedStatement pstmt = conn.prepareStatement(SQL);
			pstmt.setInt(1, bbsID);
			rs = pstmt.executeQuery();
			if (rs.next()) {
				Bbs bbs = new Bbs();
				bbs.setBbsID(rs.getInt(1));
				bbs.setBbsTitle(rs.getString(2));
				bbs.setUserID(rs.getString(3));
				bbs.setBbsDate(rs.getString(4));
				bbs.setBbsContent(rs.getString(5));
				bbs.setBbsAvailable(rs.getInt(6));
				return bbs;
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		return null;
	}

	public int update(int bbsID, String bbsTitle, String bbsContent) {
		String SQL = "UPDATE BBS SET bbsTitle = ?, bbsContent = ? WHERE bbsID = ?";
		try {
			PreparedStatement pstmt = conn.prepareStatement(SQL);
			pstmt.setString(1, bbsTitle);
			pstmt.setString(2, bbsContent);
			pstmt.setInt(3, bbsID);
			return pstmt.executeUpdate();
		} catch (Exception e) {
			e.printStackTrace();
		}
		return -1; // 데이터베이스 오류
	}

	public int delete(int bbsID) { // bbsAvailable = 0 하면 삭제처리됨
		String SQL = "UPDATE BBS SET bbsAvailable = 0 WHERE bbsID = ?";
		try {
			PreparedStatement pstmt = conn.prepareStatement(SQL); // conn객체를 이용 SQL문장을 실행준비로 만듬
			pstmt.setInt(1, bbsID);
			return pstmt.executeUpdate(); // 성공적으로 수행시 0이상의 값을 반환
		} catch (Exception e) {
			e.printStackTrace();
		}
		return -1; // 데이터베이스오류
	}

}