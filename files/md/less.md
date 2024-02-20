本項ではサーバレスに関わる内容について記載する。  

# API Gateway(AWS)とは
API GatewayとはAWSが提供する「APIの作成及び管理を簡易的に行えるフルマネージドサービス」である。  
HTTP API、REST API、WebSocket APIが利用可能である。今回はREST APIを利用する。  

API Gatewayは以下の設定から成り立っている。例として以下のようなURLで接続する。  
https://[API GatewayID].execute-api.ap-northeast-1.amazonaws.com/[ステージ名]/[リソース名]  

* リソース
いわゆるパス名である。リソース単位で後続処理を分けることができる。  

* メソッド
HTTPメソッドを設定する。GETやPUTなどである。  

* ステージ
開発環境や検証環境といった形で環境を分けることが可能である。FQDNの後にステージ名が入る。  

## プライベート接続
API Gatewayにはプライベート接続というものがある。(REST APIのみ？)  
しかしこれはAPI GatewayをVPC内に作成するというものではない。  
API GatewayはAWS領域に作成されるが、こちらにパブリックから接続できないというだけである。  
プライベート接続するためにはVPCエンドポイント(com.amazonaws.ap-northeast-1.execute-api)を作成する必要がある。  

この時、API Gatewayのリソースポリシーを設定する必要がある。以下が設定例である。  
デプロイし直さないとリソースポリシーが反映されないため注意！！！  
```
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": "*",
      "Action": "execute-api:Invoke",
      "Resource": "arn:aws:execute-api:ap-northeast-1:[アカウントID]:[API GatewayID]/[ステージ名]/*",
      "Condition": {
        "StringEquals": {
          "aws:sourceVpce": "VPCエンドポイントID"
        }
      }
    }
  ]
}
```

## ログ管理
API Gatewayではログをcloudwatchlogsに出力することが可能である。  
「ステージ」→「ログとトレース 」から設定可能である。  
ただし、API Gateway側にIAMロールの設定が必要である。  
API単位ではなく、全体でのロール設定となっているようであり、「設定」→「ログ記録」から設定可能である。  

