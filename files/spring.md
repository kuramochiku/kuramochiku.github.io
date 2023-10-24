# SpringBoot入門
## SpringBootとは

## IntelliJとは
IntelliJ IDEAは、JetBrains社が開発したJavaなどの言語に対応した統合開発環境である。  

なお、IDE(統合開発環境)とはプログラマーがソフトウェアコードを効率的に開発するのに役立つソフトウェアアプリケーションであり、IDEには以下のようなメリットがある。  
・コード編集のオートメーション  
・構文の強調表示  
・インテリジェントなコード補完  
・リファクタリングのサポート  
・ローカルビルドのオートメーション  
・コンパイル  
・テスト  
・デバッグ  


## IntelliJ IDEAインストール(Windows)
1,以下サイトの右上の「ダウンロード」をクリックする。  
JetBrains：IntelliJ IDEA　https://www.jetbrains.com/ja-jp/idea/  

2,保存したexeファイルを実行し、インストールを行う。  
インストールオプションの詳細は以下となる。今回はショートカットと環境変数を追加する。  
```
Create Desktop Shortcut：IntelliJ IDEAのランチャーデスクトップショートカットを作成する
Update PATH variable：IntelliJ IDEAコマンドラインランチャーを含むディレクトリを環境変数に追加する
Update context menu：コンテキストメニューに「プロジェクトとしてフォルダーを開く」を追加する
Create Associations：特定のファイル拡張子をIntelliJ IDEAに関連付けて開く
```
3,IntelliJ IDEAの起動
スタートメニューやショートカットから「IntelliJ IDEA」を起動する。  
初回起動時にはユーザー規約画面が出るので、合意のチェックボックスにチェックを入れ、「Continue」をクリックする。  

4,ユーザ認証
初回起動時は認証を求められるため「Log in to JetBrains Account」をクリックし、ブラウザでユーザ認証を行う。

5,日本語化
「Plugins」をクリックし、検索テキストボックスに「japanese」と入力し、一覧に出てきた「Japanese Language Pack / 日本語言語パック」をインストールする。  
インストールが完了すると、IntelliJ IDEAの再起動を求められるので、再起動する。  
再起動後、日本語化されていることを確認する。  

## IntelliJ IDEAプロジェクトの作成
1,Javaプロジェクトを作成する場合は、左側の「Javaモジュール」を選択し、プロジェクトで使用するSDKのバージョンを選択して「次へ」をクリックする。  
※JDKをインストールしていない場合はプロジェクトSDKの一覧に表示されないため、JDKを別途ダウンロード（AoptOpenJDKのダウンロード）するか、プロジェクトSDKの選択「Download JDK...」から対象のバージョンのJDKをインストールすること。  

2,プロジェクト名を設定し、作成をクリックする。  