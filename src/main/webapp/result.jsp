<%-- 担当：佐藤健丈 --%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="java.net.HttpURLConnection"%>
<%@ page import="java.net.URL"%>
<%!
//XMLをHTMLに変換する関数
public String xmlToHTML(String msg) {//引数：xmlファイルの内容
	
	return msg.replace("&", "&amp;")
			.replace("\"", "&quot;")
			.replace("<", "&lt;")
			.replace(">", "&gt;")
			.replace("'", "&#39;")
			.replace("\n", "<br>\n")
			.replace("response", "div")
			.replace("location", "ul")
			.replace("city", "li")
			.replace("city-kana", "li")
			.replace("town", "li")
			.replace("town-kana", "li")
			.replace("x type=&quot;decimal&quot;", "li")
			.replace("y type=&quot;decimal&quot;", "li")
			.replace("distance type=&quot;float&quot;", "li")
			.replace("prefecture", "li")
			.replace("postal", "li");
}

//緯度経度情報からHMTLを得る関数
public String coordinatesToHTML(String X, String Y) {
	//変数定義
	String msg = ""; //画面に表示する文字列を格納する変数
	String urlFormat = "https://geoapi.heartrails.com/api/xml?method=searchByGeoLocation";//APIのURLフォーマット
	
	//StringBuffer bf = new StringBuffer();//文字列を格納するためのクラス
	try{
		String url = String.format(urlFormat, X, Y);
		BufferedReader br = null;//ファイルをまとめて読み込むためのクラス
		
		// URL(url) → 「url/」
		//.oprnConnection() URLが参照するリモートオブジェクトへの接続を表すURLConnectionオブジェクトを返す
		//connectionのインスタンス
		HttpURLConnection con = (HttpURLConnection)new URL(url).openConnection();
        con.setRequestMethod("GET");//リクエストのメソッドを指定
        br = new BufferedReader(new InputStreamReader(con.getInputStream(), "UTF-8")); // テキストを取得する
        //1行ずつまとめてテキストを読み込む
        String str;
        while((str = br.readLine()) != null){//1行のテキストを読み込む
            msg += str;//文字列を追加する
        }
        br.close();//メモリを解放する
        
        //受け取ったテキスト（XML）をHTMLに変換する
        msg = xmlToHTML(msg);
        
	} catch (Exception e) {//エラー時処理
		System.out.println("e");
		msg += "coordinatesToHTMLでエラーが発生しました";
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
String X;//緯度経度を格納する変数
String Y;//経度を格納する変数

X = request.getParameter("X"); //リクエストパラメータを取得する
Y = request.getParameter("Y"); //リクエストパラメータを取得する

//緯度経度情報を元に、住所を取得し、HTMLを得る
msg += coordinatesToHTML(X,Y);

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