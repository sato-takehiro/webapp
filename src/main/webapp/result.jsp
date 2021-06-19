<%-- 担当：佐藤健丈 --%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8"%>
<%@ page import="java.io.*,java.util.*,java.sql.*" %>

<%!
import java.net.HttpURLConnection;
import java.net.URL;

//緯度経度情報からHMTLを得る関数
String coordinatesToHTML(String[] coordinates_contents) {
	//変数定義
	String msg = ""; //画面に表示する文字列を格納する変数
	String urlFormat = "https://geoapi.heartrails.com/api/xml?method=searchByGeoLocation";//APIのURLフォーマット
	
	StringBuffer bf = new StringBuffer();
	try{
		String url = String.format(urlFormat,coordinates_contents[0],coordinates_contents[1]);
		BufferedReader br = null;
		
		HttpURLConnection con = (HttpURLConnection)new URL(url).openConnection();
        con.setRequestMethod("GET");
        br = new BufferedReader(new InputStreamReader(con.getInputStream(), "UTF-8"));
        String str;
        while((str = br.readLine()) != null){
            bf.append(str);
        }
        br.close();
	} catch (Exception e) {
		System.out.println("e");
		msg += "エラーが発生しました";
	}
	
	return msg;
}

%>

<%
//日本語が含まれるパラメータを処理
request.setCharacterEncoding("UTF-8");
response.setCharacterEncoding("UTF-8");

//変数定義
String msg = ""; //画面に表示する文字列を格納する変数
String coordinates_contents[] = {""};//緯度経度を格納する変数

coordinates_contents = request.getParameterValues("column_contents"); //リクエストパラメータを取得する

/*//String → double に変換し、coordinates_contents[]に緯度経度情報を格納する
for(int i = 0; i < tmp.length; i++) {
	coordinates_contents[i] = Double.parseDouble(tmp[i]);
}*/

//緯度経度情報を元に、住所を取得し、HTMLを得る
msg += coordinatesToHTML(coordinates_contents);

%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>緯度経度情報からの結果画面</title>
</head>
<body>
	<h1>緯度経度情報からの結果画面</h1>
	<%= msg %>
</body>
</html>