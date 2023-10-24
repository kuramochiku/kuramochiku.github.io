# TERASOLUNAチュートリアル
以下チュートリアルについての情報を記す。  
http://terasolunaorg.github.io/guideline/5.7.0.RELEASE/ja/Tutorial/TutorialTodo.html  

## 環境構築
### Spring Tool Suite(STS)
1,インストール
IDEとして「Spring Tool Suite」をインストールする。  
公式サイトからzipファイルをダウンロードし、任意のフォルダに解凍する。  
今回は「C:\zyuku」配下とする。  

2,起動

### Apache Maven
1,インストール  
Build Toolとして「Apache Maven」をインストールする。  
公式サイトからバイナリのzipファイルをダウンロードし、任意のフォルダに解凍する。  
今回は「C:\zyuku」配下とする。  

2,環境変数  
以下フォルダに解凍した場合は  
「C:\zyuku」  
以下を環境変数に追加する。  
```
C:\zyuku\apache-maven-3.9.5-bin\apache-maven-3.9.5\bin
```

コマンドプロンプトを開き、以下コマンドを実行し、パスが通っていることを確認する。  
```
mvn -version
```

環境変数「JAVA_HOME」が設定されていない場合はエラーとなるため注意すること。  
パスはbinまで通す必要はなく、今回は「C:\Program Files\Java\jdk-21」とする。  