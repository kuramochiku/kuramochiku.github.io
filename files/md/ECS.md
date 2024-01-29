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

## docker bulid
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

保有イメージは以下で確認する。-aで停止中のイメージ含めて表示する。  
```
xxxx:~/environment/TestRest/initial $ docker images -a
REPOSITORY           TAG       IMAGE ID       CREATED             SIZE
springio/testrest2   latest    a50af4fa259c   5 minutes ago       456MB
springio/testrest    latest    c3b373a153b2   28 minutes ago      456MB
<none>               <none>    3c833b85c252   About an hour ago   124MB
xxxx:~/environment/TestRest/initial $ 
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
