# ECS入門  
## Amazon ECS 入門ハンズオン  
AWSが用意しているハンズオンをベースに学習する。  
以下のように様々なハンズオンがあるため、自分に合ったハンズオンを選択すること。  
https://aws-samples.github.io/jp-contents-hub/#containers  

本ハンズオンの作業ステップは以下となる。  
* AWS Cloud9 上で Dockerfile からコンテナイメージを作成  
* Amazon Elastic Container Registry(Amazon ECR) に作成したコンテナイメージをアップロード  
* コンテナオーケストレーションサービスである、Amazon Elastic Container Service(Amazon ECS) と、コンテナ向けのサーバレス実行環境である AWS Fargate を使ってコンテナを実行  
* 動かしたコンテナイメージに、内部踏み台からアクセス  
* Amazon ECS によるコンテナのスケジューリング、スケーリングを体験  

## 構成メモ
自分用のECSの各パーツについてのメモ。  
|  サービス名  |  説明  |
| ---- | ---- |
| コンテナイメージ | 事前に作成しておき、ECRにプッシュする。コンテナはどこでも作れる。|
| ECR | リポジトリ。コンテナイメージを格納しておく場所。|
| ECSクラスタ | 入れ物？サービスやタスクを実行するための大枠設定。共通で使うケース、分けるケースはどういう時だろう。|
| ECSタスク定義 | どのコンテナを使うかなどの定義。|
| ECSタスク | 実行するコンテナのこと。タスクを実行することでコンテナを起動できる。スケジュールでの起動も可能。バッチ処理はこちらか。|
| ECRサービス | タスクをオートスケーリングを絡めて起動する。タスクが異常状態の場合は新しいタスクが起動する。LBと連携することも可能。オンライン処理はこちら。|

### 作業環境の作成(AWS Cloud9)  
コンテナイメージを作成する作業環境として、AWS Cloud9 を利用します。  
AWS Cloud9は、ブラウザ経由でコードを記述、実行、デバッグが出来るクラウドベースのIDEです。  
SpringBootの執筆環境としても利用可能らしい。  

今回は下部にあるターミナルからdocekerを利用する。(dockerは初期インストール済み)  
ターミナル画面が無い場合は「Window」→「New Terminal」   

## ECS エラー 
### ECSタスク作成時 
指定したVPCがインターネット接続が可能でないといけない。  

```
CannotPullContainerError: ref pull has been retried 5 time(s): failed to copy: httpReadSeeker: failed open: failed to do request: Get 626394096352.dkr.ecr.ap-northeast-1.amazonaws.com/ma-kuramochiku-ecs-helloworld:0.0.1: dial tcp 52.219.199.138:443: i/o timeout
```

エンドポイントも用意されており、以下エンドポイントでも代用可能である。  
ECR用エンドポイント  
* com.amazonaws.region.ecr.dkr  
* com.amazonaws.region.ecr.api
* com.amazonaws.region.s3（ゲートウェイ型）

構築するリソースによって必要なエンドポイントは異なる。詳細は以下などを参照すること。  
https://dev.classmethod.jp/articles/vpc-endpoints-for-ecs-2022/#toc-1  

## 設定するIAMロール
◆タスク実行ロール  
⇒タスク実行時にアクセスしたいAWSリソースの権限を管理。無いと起動しないはず。主に以下のような権限が必要。  
* コンテナイメージをECRからgetしてpullするためにECRの権限諸々を付与(AmazonECSTaskExecutionRolePolicyにあり)  
* ログの出力先の作成と出力のためにCloudWatchLogsの権限諸々を付与(AmazonECSTaskExecutionRolePolicyにあり)  
* タスク定義の環境変数に AWS System Manager パラメータストアの値を利用する場合、SecretsManageの権限を付与  

◆タスクロール  
⇒タスク実行して起動したコンテナがアクセスしたいAWSリソースの権限を管理。EC2に設定するIAMロールのようなイメージ。AWSリソースを使用しない場合は無くても良い。  

# Docker入門  
Dockerとは、軽量で高速に動作するコンテナ型仮想環境用のプラットフォームです。  
Dockerを使うことで、1台のサーバー上で様々なアプリケーションを手軽に仮想化・実行できるようになります。  
従来の仮想化では仮想マシンごとに1つのゲストOSをインストールし、あたかも1台の独立したサーバーのように利用していました。  
一方でDockerではホストOSのカーネルを共有して利用することで、従来の仮想化と違いゲストOSを必要としません。  
その分だけDockerは軽快に動作するのが特徴です。  

## Dockerfile
DocekrはDockerfileという、コンテナイメージ作成で使う命令が書かれているファイルにより構成されます。  
本ファイルは書かれている内容が上から順に解釈され、コンテナイメージをどのように作成するか指定できます。  
dockerのマニュアルページは以下となる。詳細はこちらを調べること。  
https://docs.docker.jp/engine/reference/builder.html  

spring用のサンプルは以下となる。今回は～/TestRest/initial配下にDockerfileを作成する。
※ただし、ユーザ設定するとログ出力部分でエラーとなってしまった。本筋ではなくコメントアウトとした。指定しない場合はrootとなる。  
```
FROM eclipse-temurin:21　# eclipseをベースとする
# RUN groupadd spring && useradd spring -g spring　#　springユーザ、グループの作成
# USER spring:spring　# ユーザをspringとする
ARG JAR_FILE=target/*.jar　# 構築時build-time にユーザが渡せる変数を定義する。
COPY ${JAR_FILE} app.jar　# Docker クライアントで操作しているディレクトリから、ファイルを（コンテナのレイヤに）追加
ENTRYPOINT ["java","-jar","/app.jar"]  # コンテナ起動時にjavaを実行する
```

## Docker基本コマンド
### イメージの確認  
保有イメージは以下で確認する。-aで停止中のイメージ含めて表示する。  
```
xxxx:~/environment/TestRest/initial $ docker images -a
REPOSITORY           TAG       IMAGE ID       CREATED             SIZE
springio/testrest2   latest    a50af4fa259c   5 minutes ago       456MB
springio/testrest    latest    c3b373a153b2   28 minutes ago      456MB
<none>               <none>    3c833b85c252   About an hour ago   124MB
xxxx:~/environment/TestRest/initial $ 
```

### Current Directory内のDockerfileをビルドしてイメージ作成
dockerイメージの作成には以下のようにbulidコマンドを使用する。  
-tでタグを付けられる。  

```
xxxx:~/environment/TestRest/initial $ docker build -t springio/testrest2 .
[+] Building 1.6s (7/7) FINISHED                                                                                          docker:default
 => [internal] load build definition from Dockerfile                                                                                0.0s
 => => transferring dockerfile: 282B                                                                                                0.0s
 => [internal] load .dockerignore                                                                                                   0.0s
 => => transferring context: 2B                                                                                                     0.0s
 => [internal] load metadata for docker.io/library/eclipse-temurin:21                                                               1.3s
 => [internal] load build context                                                                                                   0.0s
 => => transferring context: 214B                                                                                                   0.0s
 => CACHED [1/2] FROM docker.io/library/eclipse-temurin:21@sha256:18f800a7a9b4e69567694315d7abba066ef33ed321642d872b324f171864e85e  0.0s
 => [2/2] COPY target/*.jar app.jar                                                                                                 0.1s
 => exporting to image                                                                                                              0.1s
 => => exporting layers                                                                                                             0.1s
 => => writing image sha256:a50af4fa259cc4867103b3efc6d5bae742cfacb2b22b4f70f34f2e8b0c105c36                                        0.0s
 => => naming to docker.io/springio/testrest2                                                                                       0.0s
xxxx:~/environment/TestRest/initial $ 
```

### イメージからコンテナの起動
-dをつけるとバックグラウンドで起動する。  バックグラウンド起動時に停止する場合はstopコマンドを使用する。  
```
 $  docker run -p 8080:8080 springio/testrest2
省略
  .   ____          _            __ _ _
 /\\ / ___'_ __ _ _(_)_ __  __ _ \ \ \ \
( ( )\___ | '_ | '_| | '_ \/ _` | \ \ \ \
 \\/  ___)| |_)| | | | | || (_| |  ) ) ) )
  '  |____| .__|_| |_|_| |_\__, | / / / /
 =========|_|==============|___/=/_/_/_/
 :: Spring Boot ::                (v3.2.0)

[INFO ] TestKK.logStarting:50 - Starting TestKK v0.0.1-SNAPSHOT using Java 21.0.2 with PID 1 (/app.jar started by root in /)
[DEBUG] TestKK.logStarting:51 - Running with Spring Boot v3.2.0, Spring v6.1.1
[INFO ] TestKK.logStartupProfileInfo:659 - The following 1 profile is active: "develop"
[INFO ] TomcatWebServer.initialize:108 - Tomcat initialized with port 8080 (http)
[INFO ] ServletWebServerApplicationContext.prepareWebApplicationContext:296 - Root WebApplicationContext: initialization completed in 3028 ms
[INFO ] TomcatWebServer.start:221 - Tomcat started on port 8080 (http) with context path ''
[INFO ] TestKK.logStarted:56 - Started TestKK in 6.837 seconds (process running for 8.457)
```

### 起動中コンテナの一覧表示
```
 $ docker ps 
CONTAINER ID   IMAGE                COMMAND                CREATED         STATUS         PORTS                                       NAMES
7ac48ae76172   springio/testrest2   "java -jar /app.jar"   3 minutes ago   Up 3 minutes   0.0.0.0:8080->8080/tcp, :::8080->8080/tcp   agitated_almeida
```

### 起動中コンテナへ接続
NAMESは毎回変わる？ため、psで確認してから接続を行う。  
```
$ docker exec -i -t agitated_almeida bash
root@7ac48ae76172:/#
```

## Dockerエラー 
### docker bulid時 
どのファイルからdockerを構成するかのパスやURLの指定が無い時のエラー。引数不足。  
「 .」と指定した場合、このローカルディレクトリにある全てのファイルはtar化され、Dockerデーモンに送られます。  

``` 
"docker build" requires exactly 1 argument. 
See 'docker build --help'.

Usage: docker build [OPTIONS] PATH | URL | -  

Build an image from a Dockerfile 
```

### docker runした後にcurlするもエラー
dockerイメージ作成後、runでイメージ起動し、接続確認をするためにcurlを実行するが以下のようにエラーとなった。  
※-dなしでの起動やexecでコンテナに入っているターミナルが別にある場合は通信可能。この辺のロジックは不明。
```
xxxx:~/environment/TestRest/initial $ curl  http://localhost:8080/api/data
curl: (56) Recv failure: Connection reset by peer
```
原因は、containerの外からリクエストが来るのにアプリがlocalhostでLISTENしているためである。  
ホストサーバのlocalhost(127.0.0.1)8080ポート通信をコンテナ(172.17.0.x)の8080ポートに転送される。  
(172.17.0.xはcontainerのbridgeネットワークのインターフェースに自動で与えられたIPアドレス)  
しかしコンテナ上のAPは127.0.0.1でListenしているためエラーとなる。  
ポートのListenを0.0.0.0にすれば良い。springはどうやるんだろ・・・？  

## コンテナのログ管理
コンテナのログには大きく2種類が存在する。nginxとtomcatである。  
nginxで生成されるログファイルはaccess.logとerror.logだが、nginxのDockerfileはaccess.logとerror.logをそれぞれSTDOUTとSTDERRにリダイレクトする。　　
一方Tomcat は catalina.log、access.log、manager.log、host-manager.log など複数のログファイルを生成するが、tomcat Dockerfile はこれらのログを標準出力にリダイレクトしせず、コンテナ内に保存される。  

### 標準出力
コンテナの標準出力は、Logging Driverで処理される。デフォルトはjson形式であり、  
「/var/lib/docker/containers/<container-id>/<container-id>-json.log」にあるホストファイルに出力する。  

## 小技
### ECS Execでコンテナログイン
ECS Execという機能を使って起動中のコンテナへログインすることができる。  

1,SSM権限を付与したIAMロールを準備する。  
2,1で用意したIAMロールを用いて、ECSタスク定義を新規作成または更新する。(タスク実行ロールではなくタスクロールに設定する)  
3,ECSサービスで「enableExecuteCommand」の設定を有効にし、タスクを更新する。(GUIでは設定不可？今回はcloudformationから設定する)  
4,Cloudshellなどから以下のようなAWSCLIを実行する。  
```
aws ecs execute-command --cluster クラスタ名 --task タスクID --container コンテナ名 --interactive --command "/bin/sh"
```
