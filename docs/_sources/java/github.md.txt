# GitHub入門  
## GitHubとは
「GitHub」は、ソフトウェア開発プロジェクトのバージョン管理を共有できるWebサービス。  
GitHubは、「Git」の「ハブ：拠点、中心、集まり」という意味に基づいて名付けられました。  

GitHubでは、世界中の人々が自分の作ったソースコードやデザインデータなどを保存、公開できます。  

## GitHubのアカウント作成
1,GitHubサイト(https://github.co.jp/)へアクセス  
2,登録情報を入力  
3,メールに送信されたパスコードを入力し、アカウント作成完了  

## クライアント端末準備
### Windows
Windowsでgitを使用するための準備を行う。(Amazon Linux Workspacesではデフォルトでインストール済みであった)  

参考手順  
https://www.curict.com/item/60/60bfe0e.html  

1,以下公式サイトからインストーラをダウンロードする。  
https://gitforwindows.org/  

2,exeを実行し、インストールを行う。基本はデフォルトのままで良いが今回は以下を変更した。  
```
＞新しいリポジトリ作成時のブランチ名  
・デフォルトリポジトリ名  
Override the default name →　main  
・改行コード  
Checkout as-is, commit as-is  
```

3,power shellを起動し、以下コマンドで確認する。  
```
git --version  
git -v  
```

## GitHub Pagesのクイックスタート  
GitHub Pagesを用いることで簡単にWEBページを作成することができる。  

### 概要手順
1,リポジトリを[username].github.ioで作成することで可能となる。 　今回は「kuramochiku.github.io」で作成する。  
※2以降はリポジトリをプッシュしてから実施する。  

2,リポジトリ名の下にある「Settings」から「Code and automation」の「Pages」を選択する。  

3,「Build and deployment」の「Branch」からリポジトリを選択しSaveする。今回は「main」とする。  

4,必要に応じて、リポジトリの README.md ファイルを開きます。  
README.md ファイルは、サイトのコンテンツを記述する場所です。  
このファイルを編集することも、あるいはとりあえずデフォルトの内容をそのままにしておくこともできます。  
※サイトに対する変更は、その変更を GitHub にプッシュしてから公開されるまで、最大 10 分かかることがある。  
https://docs.github.com/ja/pages/quickstart  

・更新には結構時間かかる。最大10分は待つこと。  
・ローカルhtmlだと正常なのにgit経由でアクセスするとページが崩れる。  
github Pagesからブランチの設定をmainブランチの「/」配下で「https://kuramochiku.github.io/docs/」でアクセスするのではなく
「docs」を設定しておき、「https://kuramochiku.github.io/」でアクセスすると直った。

### 実際に作成する
コマンドラインからローカルリポジトリを作成してプッシュ  
```
cd C:\zyuku\work  
echo "# kuramochiku.github.io" >> README.md   
git init  #ローカルリポジトリ作成  
git add README.md  #README.mdをgit管理登録  
git commit -m "first commit"  #コミット。保存みたいなもの。-mでコメントをつける  
git branch -M main  #現在のブランチ名をmainに強制変更  
git remote add origin https://github.com/kuramochiku/kuramochiku.github.io.git  #「git remote add origin リモートリポジトリの場所」で、現在のローカルリポジトリに指定したリモートリポジトリを追加する。  
git push -u origin main  #リモートリポジトリに保存  
```

### README.md以外の追加分をプッシュする。
```
git add .  #配下の全ファイルをgit登録する 
git commit -m "test commit" 
git push origin main
```

## GitHub ActionsによるGitHub Pagesへのデプロイを自動化　→　保留
GitHub Actions を用いて HTML ファイルの生成とデプロイを自動化する。  
GitHub Actionsを利用するためには「.github/workflows」配下にYAMLファイルが必要となる。フォルダ構成は以下となる。  

```
PS C:\zyuku\work> tree /f
フォルダー パスの一覧
ボリューム シリアル番号は 9034-2121 です
C:.
├─docs
│
└─files
    │  conf.py
    │  github.md
    │  index.rst
    │  make.bat
    │  Makefile
    │  shpinx.md
    │  spring.md
    │  TERASOLUNA.md
    │  その他.md
    │
    ├─.github
    │  └─workflows
    │          main.yml
    │
    ├─_build
    ├─_static
    └─_templates
```

## GitHub参考手順
### リポジトリ作成 
緑色の「NEW」画面から作成  

### リポジトリ削除の方法 
・ローカルリポジトリ削除  
プロジェクトフォルダの直下にある.gitファイルを削除する。  

・リモートリポジトリ削除  
githubの該当リポジトリ画面の「Settings」の一番下  
「Danger Zone」にある「Delete this repository」から削除する。  

### リポジトリの公開範囲の変更 
githubの該当リポジトリ画面の「Settings」の一番下「Danger Zone」にある  
「Change repository visibility」から変更する。  

## Gitトラブル
### 初回コミットエラー
commit時に以下エラーが出力。認証情報が端末に保存されていないためエラーとなった。  
```
Author identity unknown

*** Please tell me who you are.

Run

  git config --global user.email "you@example.com"
  git config --global user.name "Your Name"

to set your account's default identity.
Omit --global to set the identity only in this repository.

fatal: unable to auto-detect email address (got 'okmjy@kohei.(none)')
```

対処方法  
git config --global user.email ここに自分のアドレス  
git config --global user.name ここに自分の名前  
