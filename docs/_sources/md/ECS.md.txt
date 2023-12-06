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

なお、実態はEC2であり、作成時にVPCを選択する必要がある。(選択画面は隠れていて、デフォルトはデフォルトVPC)  
Cloud9を利用するためにはEC2からインターネット接続が必要である。(IGWがあるサブネットかNATGateway経由のアクセス)  

## ECS エラー 
### ECSタスク作成時 
指定したVPCがインターネット接続が可能でないといけないかも。  

# Docker入門  
Dockerとは、軽量で高速に動作するコンテナ型仮想環境用のプラットフォームです。  
Dockerを使うことで、1台のサーバー上で様々なアプリケーションを手軽に仮想化・実行できるようになります。  
従来の仮想化では仮想マシンごとに1つのゲストOSをインストールし、あたかも1台の独立したサーバーのように利用していました。  
一方でDockerではホストOSのカーネルを共有して利用することで、従来の仮想化と違いゲストOSを必要としません。  
その分だけDockerは軽快に動作するのが特徴です。  

DocekrはDockerfileという、コンテナイメージ作成で使う命令が書かれているファイルにより構成されます。  
本ファイルは書かれている内容が上から順に解釈され、コンテナイメージをどのように作成するか指定できます。  
dockerのマニュアルページは以下となる。詳細はこちらを調べること。  
https://docs.docker.jp/engine/reference/builder.html  

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