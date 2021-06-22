<%-- 担当：佐藤健丈 --%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="java.net.HttpURLConnection"%>
<%@ page import="java.net.URL"%>
<%@ page import="java.io.*,java.util.*,java.net.*" %>
<%!

//XMLのいくつかの文字をエスケープし，改行の前に<br>を付ける
String prettyPrintXML(String s) {
	if (s == null)
		return "";
	return s.replace("&", "&amp;")
			.replace("\"", "&quot;")
			.replace("<", "&lt;")
			.replace(">", "&gt;")
			.replace("'", "&#39;")
			.replace("\n", "<br>\n");
}

//XML、タグ名が指定されているとき、
//XMLの中のタグ名の中のコンテンツを取得する
String url_tag_name_XML(String xml, String tag_name){
	//変数定義
	String msg = "";//返り値として返却する文字列
	int pos1 = -1;
	int pos2 = -1;
	int j = 0;//タグの「<」「>」の文字数
	
	try {
		pos1 = xml.indexOf("<" + tag_name + " type=\"decimal\">");//開始タグが先頭から何文字目かを格納する
		pos2 = xml.indexOf("</" + tag_name + ">");//終了タグが先頭から何文字目かを格納する
		
		if(pos1 == -1 || pos2 == -1) {//もしタグがなかったら処理を変更する
			msg += "タグ名が存在していません。<br>";
			return msg;
		}
		
		msg += xml.substring(pos1 + tag_name.length() + 17 , pos2);//タグの中に含まれる文字列を格納する
		
	} catch(Exception e) {//それ以外のエラー時
		msg += "tag_name_HTMLで不具合が発生しました。";
		return msg;
	}
	
	return msg;
}

//都道府県・市区町村名から、その緯度経度情報を得る関数
//引数：都道府県・市区町村名 返り値：緯度経度情報
public String[] GetCoordinates(String Prefectures, String Municipality) {
	//変数定義
	String[] Coordinates = {"",""};//緯度経度情報を格納する配列
	String msg = ""; //APIから得たXMLを格納する変数
	String urlFormat = "http://geoapi.heartrails.com/api/xml?method=getTowns";//APIのURLフォーマット
	
	StringBuilder bf = new StringBuilder();//文字列結合するためのクラス
	try{
		//文字列結合(Format + "&x=" + Prefectures)を行う
		bf.append(urlFormat);
		bf.append("&prefecture=" + Prefectures);
		String url = bf.toString();
		
		BufferedReader br = null;//ファイルをまとめて読み込むためのクラス
		
		// URL(url) → 「url/」
		//.oprnConnection() URLが参照するリモートオブジェクトへの接続を表すURLConnectionオブジェクトを返す
		//connectionのインスタンス
		HttpURLConnection con = (HttpURLConnection)new URL(url).openConnection();
      con.setRequestMethod("GET");//リクエストのメソッドを指定
      br = new BufferedReader(new InputStreamReader(con.getInputStream(), "UTF-8")); // テキストを取得する
      
      String tmp = "";//一時的に文字列を格納する
      //Municipality を 一文字ずつ読み取り、10進数の実体文字参照に変換
      for(int j = 0; j < Municipality.length(); j++) {
    	  tmp += "&#" +Municipality.codePointAt(j) + ";";
      }
      Municipality = tmp;
      System.out.println("Municipality:" + Municipality);
      
      System.out.println("1");
    //1行ずつまとめてテキストを読み込む
      String str;
      int i = 0;
      boolean flag = false;
      while((str = br.readLine()) != null){//1行のテキストを読み込む
    	  if(str.contains(Municipality) && flag == false) {
        	  i = 6;
        	  flag = true;
         }
       	 if(i-- > 0) {
     		msg += str;//文字列を追加する
     	 }
      }
      br.close();//メモリを解放する
      
      System.out.println("5");
      System.out.println("msg:" + msg);
      System.out.println("flag:" + flag);
      
      //受け取ったテキスト（XML）の必要な部分(緯度経度情報)を取る関数
      Coordinates[0] = url_tag_name_XML(msg, "x");//緯度を取得
      System.out.println("Coordinates[0]:" + Coordinates[0]);
      Coordinates[1] = url_tag_name_XML(msg, "y");//経度を取得
      System.out.println("Coordinates[1]:" + Coordinates[1]);
      
      System.out.println("6");
      System.out.println("msg:" + msg);
      System.out.println("Coordinates[0]:" + Coordinates[0]);
      System.out.println("Coordinates[1]:" + Coordinates[1]);
      
	} catch (Exception e) {//エラー時処理
		System.out.println("e");
		System.out.println("GetCoordinatesでエラーが発生しました");
	}
	
	return Coordinates;
}

//答えの緯度経度情報とユーザの緯度経度情報から、反応を変える
public String ChangeReaction(String X, String Y, String anser_X, String anser_Y) {
	//変数定義
	String msg = ""; //返り値として渡す文字列を格納する変数
	double x, y, anser_x, anser_y;//型変換した後に格納する箱
	double x_distance, y_distance, distance;//x(緯度)の差分,y(経度)の差分,距離
	
	//String → double に型変換
	x = Double.parseDouble(X);
	y = Double.parseDouble(Y);
	anser_x = Double.parseDouble(anser_X);
	anser_y = Double.parseDouble(anser_Y);
	
	x_distance = x - anser_x;
	y_distance = y - anser_y;
	distance = Math.sqrt(Math.pow(x_distance, 2) + Math.pow(y_distance, 2));
	
	if (distance > 1) {//誤差が大きい時、ヒントを表示
		msg += "<h2>ちょっと誤差が大きい！</h2>";
		
		//ヒント画面
		if(x_distance > 0) {
			msg += "<p>もうちょっと西に移動しよう！</p>";
		} else {
			msg += "<p>もうちょっと東に移動しよう！</p>";
		}
		
		if(y_distance > 0) {
			msg += "<p>もうちょっと南に移動しよう！</p>";
		} else {
			msg += "<p>もうちょっと北に移動しよう！</p>";
		}
	} else {//誤差が小さい時、ゲームクリア画面を表示
		msg += "<p>ゲームクリア！</p>";
		msg += "<p>これで緯度経度はばっちりだ！</p>";
		msg += "<p>誤差：" + distance + "</p>";
	}
	
	//リトライ画面
	msg += "<p>もう一度トライしてみよう！</p>";
	msg += "<p><a href=\"input.jsp\">リトライする</a></p>";
	
	return msg;
}

%>

<%
//日本語が含まれるパラメータを処理
request.setCharacterEncoding("UTF-8");
response.setCharacterEncoding("UTF-8");

//変数定義
String msg = ""; //画面に表示する文字列を格納する変数
String X;//ユーザの入力した緯度を格納する変数
String Y;//ユーザの入力した経度を格納する変数
String anser_X;//答えの緯度を格納する変数
String anser_Y;//答えの経度を格納する変数
String Prefectures;//都道府県名を格納する変数
String Municipality;//市区町村名を格納する変数
String tmp[];//一時変数

X = request.getParameter("X"); //リクエストパラメータを取得する
Y = request.getParameter("Y"); //リクエストパラメータを取得する
Prefectures = request.getParameter("prefectures"); //リクエストパラメータを取得する
Municipality = request.getParameter("cities"); //リクエストパラメータを取得する
System.out.println("X:" + X);
System.out.println("Y:" + Y);
System.out.println("Prefectures:" + Prefectures);
System.out.println("Municipality:" + Municipality);

//都道府県・市区町村名から、その緯度経度情報を得る
System.out.println("a");
tmp = GetCoordinates(Prefectures, Municipality);
System.out.println("b");
anser_X = tmp[0];
System.out.println("c");
anser_Y = tmp[1];
System.out.println("d");

//答えの緯度経度情報とユーザの緯度経度情報から、反応を変える
msg += ChangeReaction(X, Y, anser_X, anser_Y);

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