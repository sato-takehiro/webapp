<%-- 担当：田羅鋤祐果 --%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8"%>
<%@ page import="java.io.*,java.util.*,java.net.*" %>

<%!
String escapeCell(String s) { //空白文字に対するエスケープ処理を行う関数
    if (s == null || s.equals("")) { //文字列sがnull,空白であるなら、空白文字&nbsp;を返す
	return "&nbsp;";
    }
    return s; //それ以外のとき、文字列sを返す
}

%>
<%
//リクエスト・レスポンスとも文字コードをUTF-8に
request.setCharacterEncoding("UTF-8");
response.setCharacterEncoding("UTF-8");

//変数定義
String msg = ""; // 結果メッセージ

%>
<!DOCTYPE html>
<html>
	<head>
		<meta charset="UTF-8">
		<title>緯度・経度入力</title>
	</head>
	<body>
	<form action=result.jsp method=post>
	<p>緯度経度を入力してください。<br></p>
		 <p>緯度：<input type="number" name="X" max="180" min="0" required><br>
		 経度：<input type="number" name="Y" max="180" min="0"required><br></p>
		 <p><input type="submit" value="住所検索"></p>
		 </form>
		<%= msg %>
	</body>
</html>
