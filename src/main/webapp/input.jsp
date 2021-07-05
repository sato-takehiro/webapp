<%-- 担当：田羅鋤祐果 --%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8"%>
<%@ page import="java.io.*,java.util.*,java.net.*" %>

<%!

//都道府県を得る関数
//返り値：都道府県名
public String[] GetPrefectures() {
	//変数定義
	String[] Prefectures;//都道府県名を格納する配列
	String msg = ""; //APIから得たXMLを格納する変数
	String url = "https://geoapi.heartrails.com/api/xml?method=getPrefectures";//APIのURLフォーマット
	
	StringBuilder bf = new StringBuilder();//文字列結合するためのクラス
	try{	
		BufferedReader br = null;//ファイルをまとめて読み込むためのクラス
		
		// URL(url) → 「url/」
		//.oprnConnection() URLが参照するリモートオブジェクトへの接続を表すURLConnectionオブジェクトを返す
		//connectionのインスタンス
		HttpURLConnection con = (HttpURLConnection)new URL(url).openConnection();
    	con.setRequestMethod("GET");//リクエストのメソッドを指定
    	br = new BufferedReader(new InputStreamReader(con.getInputStream(), "UTF-8")); // テキストを取得する
    
  		//1行ずつまとめてテキストを読み込む
    	String str;
    	boolean flag = false;
    	while((str = br.readLine()) != null){//1行のテキストを読み込む
  	     	msg += str;//文字列を追加する
   	 	}
    	br.close();//メモリを解放する
    
    	//受け取ったテキスト（XML）の必要な部分(都道府県名)を取る関数
    	Prefectures[0] = url_tag_name_XML(msg, "x");//都道府県名を取得
    
	} catch (Exception e) {//エラー時処理
		System.out.println("e");
		System.out.println("GetCoordinatesでエラーが発生しました");
	}
	
	return Coordinates;
}


%>


<%
//リクエスト・レスポンスとも文字コードをUTF-8に
request.setCharacterEncoding("UTF-8");
response.setCharacterEncoding("UTF-8");

//変数定義
String msg = "";//画面に表示する文字列を格納する変数
String prefectures = request.getParameter("prefectures");//都道府県名を格納する変数
String cities;//市区町村名を格納する変数
String X;//ユーザの入力した緯度を格納する変数
String Y;//ユーザの入力した経度を格納する変数

//都道府県名が入力されているかどうかで、表示画面を変える
if(prefectures != null && !prefectures.equals("")) {
	//プログラムの説明
	msg += "<p>Webアプリケーションの概要：GPSの仕組みなど子供達に緯度経度に興味をもってもらうためのゲーム的Webアプリケーション<br>“緯度経度から自分の住んでいる地区を当ててみよう！”<br>使用したAPI：https://geoapi.heartrails.com/api/xml?method=searchByGeoLocation<br>作成者：佐藤健丈、田羅鋤祐果<br></p>";
	msg += "<hr width=\"100%\">";
	msg += "<p>緯度とは：赤道を0度として、北極までと南極までをそれぞれ90度に分けたもの<br></p>";
	msg += "<p>経度とは：本初子午線から東側と西側をそれぞれ180度ずつに分けたもの<br></p>";
	msg += "<hr width=\"100%\">";
	//緯度経度の例
	msg += "<p>例<br></p>";
	msg += "<p>北海道 (経度：141 緯度：43), 東京 (経度：139.6 緯度：35.7), 愛知 (経度：136.7 緯度：35.2),<br>";
	msg += "大阪 (経度：139.6 緯度：34.4), 福岡 (経度：130.5 緯度：33.3), 沖縄 (経度：127.4 緯度：26.1)<br></p>";
	msg += "<hr width=\"100%\">";
	//都道府県名を入力するフォーム
	msg += "<p>目的地を入力してください。<br></p>";
	msg += "<form action=input.jsp method=post>";
	msg += "";
	msg += "";
	msg += "";
} else {
	
}

%>
<!DOCTYPE html>
<html>
	<head>
		<meta charset="UTF-8">
		<title>緯度・経度入力</title>
	</head>
	<body>
	
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
