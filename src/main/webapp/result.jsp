<%-- 担当：佐藤健丈 --%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="java.net.HttpURLConnection"%>
<%@ page import="java.net.URL"%>
<%!
//XMLをHTMLに変換する関数
public String xmlToHTML(String msg) {//引数：xmlファイルの内容
	
	return msg.replace("\n", "<br>\n")
			.replace("response", "div")
			.replace("location", "ul")
			.replace("city>", "li>")
			.replace("city-kana>", "li>")
			.replace("town>", "li>")
			.replace("town-kana>", "li>")
			.replace("<x type=\"decimal\">", "<li>")
			.replace("<y type=\"decimal\">", "<li>")
			.replace("</x>", "</li>")
			.replace("</y>", "</li>")
			.replace("<distance type=\"float\">", "<li>")
			.replace("</distance>", "</li>")
			.replace("prefecture>", "li>")
			.replace("postal>", "li>")
			.replace("error>", "li>");
}

//緯度経度情報からHMTLを得る関数
public String coordinatesToHTML(String X, String Y) {
	//変数定義
	String msg = ""; //画面に表示する文字列を格納する変数
	String urlFormat = "https://geoapi.heartrails.com/api/xml?method=searchByGeoLocation";//APIのURLフォーマット
	
	StringBuilder bf = new StringBuilder();//文字列結合するためのクラス
	try{
		//文字列結合(Format + "&x=" + X + "&y=" + Y)を行う
		bf.append(urlFormat);
		bf.append("&x=" + X);
		bf.append("&y=" + Y);
		String url = bf.toString();
		
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
String X;//緯度を格納する変数
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