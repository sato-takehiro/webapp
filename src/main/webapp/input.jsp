<%-- 担当：田羅鋤祐果 --%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8"%>
<%@ page import="java.io.*,java.util.*,java.net.*" %>

<%
//リクエスト・レスポンスとも文字コードをUTF-8に
request.setCharacterEncoding("UTF-8");
response.setCharacterEncoding("UTF-8");

//変数定義
String msg = ""; // 結果メッセージ

msg += "<script type=text/javascript src=https://ajax.googleapis.com/ajax/libs/jquery/1.4.2/jquery.min.js></script>";
msg += "<script type=text/javascript src=http://geoapi.heartrails.com/api/geoapi.js></script>";

%>
<!DOCTYPE html>
<html>
	<head>
		<meta charset="UTF-8">
		<title>緯度・経度入力</title>
	</head>
	<body>
	<p>Webアプリケーションの概要：GPSの仕組みなど子供達に緯度経度に興味をもってもらうためのゲーム的Webアプリケーション<br>
	“緯度経度から自分の住んでいる地区を当ててみよう！”<br>
	使用したAPI：https://geoapi.heartrails.com/api/xml?method=searchByGeoLocation<br>
				 https://ajax.googleapis.com/ajax/libs/jquery/1.4.2/jquery.min.js<br>
	             javascript src=http://geoapi.heartrails.com/api/geoapi.js<br>
	作成者：佐藤健丈、田羅鋤祐果<br></p>
	<hr width="100%">
	<p>緯度とは：赤道を0度として、北極までと南極までをそれぞれ90度に分けたもの<br></p>
	<p>経度とは：本初子午線から東側と西側をそれぞれ180度ずつに分けたもの<br></p>
	<hr width="100%">
	<p>例<br></p>
	<p>北海道 (経度：141 緯度：43), 東京 (経度：139.6 緯度：35.7), 愛知 (経度：136.7 緯度：35.2),<br>
	大阪 (経度：139.6 緯度：34.4), 福岡 (経度：130.5 緯度：33.3), 沖縄 (経度：127.4 緯度：26.1)<br></p>
	<hr width="100%">
	<p>目的地を入力してください。<br></p>
	<form action=result.jsp method=post>
	<%= msg %>
	<select id="geoapi-prefectures" name="prefectures">
      <option value="都道府県を選択してください">都道府県を選択してください</option>
    </select>
	<select id="geoapi-cities" name="cities">
  	  <option value="市区町村名を選択してください">市区町村名を選択してください</option>
	</select>
	<p>緯度経度を入力してください。<br>
		 経度：<input type="number" step="0.01" name="X" max="180" min="0" required><br>
		 緯度：<input type="number" step="0.01" name="Y" max="180" min="0"required><br></p>
		 <p><input type="submit" value="住所検索"></p>
		 </form>
	</body>
</html>
