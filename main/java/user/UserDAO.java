package user;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

public class UserDAO {

	// 실제로 mySQL에 접속하는 부분
	private Connection conn; // 데이터베이스에 접근할 객체
	private PreparedStatement pstmt; // 쿼리저장해 놓는 곳 ?사용
	private ResultSet rs; // 불러온 자료를 담을 수 있는 객체

	// 생성자
	public UserDAO() {
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

	// 로그인 하는 함수
	public int login(String userID, String userPassword) {
		String SQL = "SELECT userPassword FROM USER WHERE userID = ? ";
		try {
			pstmt = conn.prepareStatement(SQL); // pstmt에 미리짜둔 쿼리를 데이터베이스에 삽입. sql injection 방지.
			pstmt.setString(1, userID); // 쿼리에 ?를 사용해서 1번째 물음표에 userID를 넣고 쿼리를 완성해서 pstmt에 넣는다
			rs = pstmt.executeQuery(); // pstmt의 쿼리를 실행한 결과를 rs에 넣는다
			if (rs.next()) {
				// rs.getString(1)-> userPassword를 구하는 거임(SELECT userPassword FROM USER WHERE
				// userID = ?
				if (rs.getString(1).equals(userPassword)) {
					return 1; // 로그인 성공
				} else
					return 0; // 비밀번호 불일치. rs.getString(1)에서 가져온 비밀번호랑 userPassword가 같지 않음
			}
			return -1; // rs.next()가 없으면 아이디가 없음
		} catch (Exception e) {
			e.printStackTrace();
		}
		return -2; // 데이터베이스 오류
	}

	// 회원가입 함수
	public int join(User user) { // User클래스를 이용해서 만들어진 인스턴스
		String SQL = "INSERT INTO USER VALUES (?, ?, ?, ?, ?)"; //user 테이블에 값을 넣기
		try {
			pstmt = conn.prepareStatement(SQL); // 위에서 정의한 insert SQL 문장 넣기
			pstmt.setString(1, user.getUserID()); // 물음표 5개 중에 1번 
			pstmt.setString(2, user.getUserPassword());
			pstmt.setString(3, user.getUserName());
			pstmt.setString(4, user.getUserGender());
			pstmt.setString(5, user.getUserEmail());
			return pstmt.executeUpdate(); // 쿼리를 넣은 pstmt를 실행
		} catch (Exception e) {
			e.printStackTrace();
		}
		return -1; // 데이터베이스 오류
	}
}
