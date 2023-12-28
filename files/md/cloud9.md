# Cloud9入門
## Cloud9について   
### Cloud9とは
AWS Cloud9は、ブラウザ経由でコードを記述、実行、デバッグが出来るクラウドベースのIDEです。  
今回はSpringBootの執筆環境としても利用する。  

なお、実態はEC2であり、作成時にVPCを選択する必要がある。(選択画面は隠れていて、デフォルトはデフォルトVPC)  
Cloud9を利用するためにはEC2からインターネット接続が必要である。(IGWがあるサブネットかNATGateway経由のアクセスかVPCエンドポイント)   

### Cloud9の長所
* インターネット環境があればどこからでも作業可能である。  
* ブラウザアクセス可能であれば、ローカル端末の環境依存度は低い。

### Cloud9の短所
* インターネット接続が必要である。
* インスタンス費用がかかる。

### Cloud9の始め方
「Cloud9」サービスから「環境の作成」を押下し、設定を行う。特に難しい項目はなく、直感的に設定が可能である。  
設定を入れて「作成」を押下するとClouformationが実行され、SGとEC2が作成される。  

閉域VPCからのSSM接続を選択する場合はSSM接続に必要なエンドポイントを作成する必要がある。  
また、Nameタグは作成できない仕様。  

### 初期セットアップ
必要なミドルウェアをインストールする必要がある。(javaやdockerはインストール済み)  

* mavenインストール
```
sudo wget http://repos.fedorapeople.org/repos/dchen/apache-maven/epel-apache-maven.repo -O /etc/yum.repos.d/epel-apache-maven.repo
sudo sed -i s/\$releasever/6/g /etc/yum.repos.d/epel-apache-maven.repo
sudo yum install -y apache-maven
```

### サンプルコード
以下のサンプルコードを試してみる。  
https://spring.pleiades.io/guides/gs/validating-form-input/  

分からないまま、ソースコードをダウンロードし、各ファイルを作成して以下実行してjarファイル作成してjava実行  
```
cd gs-validating-form-input-main/initial/
chmod 755 mvnw
./mvnw clean package
java -jar target/validating-form-input-initial-0.0.1-SNAPSHOT.jar 
別ターミナルを開いて
curl -v http://localhost:8080/
```

## 操作情報まとめ
### ファイル/フォルダ作成、削除
左側にはこの開発環境で作られているファイル一覧が表示されている。  
作成したい親フォルダを右クリックして「NewFile」「NewFolder」を選択すれば作成。  
削除したいファイル/フォルダを右クリックして「Delete」を選択すれば削除。  

### ファイルアップロード
ドラッグアンドドロップで配置したいフォルダを選択すればアップロード可能。  
メニューバーの「File」「Upload Local Files」を選択しても可能。  

## トラブル系
### Cloud9でメニューバーが消えた時の対処
上の部分に隠れているという扱いらしく、隙間をクリックするとメニューバーが表示される。  
