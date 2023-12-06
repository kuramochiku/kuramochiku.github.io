# CloudFormation入門  
CloudFormation(CF)とは、AWSリソースを自動作成するサービスである。  
JSONやYAML形式のファイルに設定値を記載する。  

## 書式サンプル(VPC作成)  
``` 
AWSTemplateFormatVersion: 2010-09-09 # テンプレートフォーマットのバージョン。1つしか無いらしい。  
Description: Template for VPC  

Resources:
  TESTVPC: # CF内で使用する論理ID。  
    Type: AWS::EC2::VPC # 何のリソースかの定義  
    Properties: # 必要な設定を入れる  
      CidrBlock: 192.168.1.0/24  
      InstanceTenancy: default
      EnableDnsSupport: true
      EnableDnsHostnames: true
      Tags: # 付与したいタグを入れる  
        - Key: Name  
          Value: TEST-vpc  
          
  PrivateSubnet:  
    Type: AWS::EC2::Subnet  
      Properties:  
        CidrBlock: 192.168.1.0/25  
        MapPublicIpOnLaunch: false  
        VpcId: !Ref TESTVPC # 上記でVPCを作成しないとVPCIDが分からないため、変数的な記載となる。  
        AvailabilityZone: "ap-northeast-1a"  
        Tags:  
          - Key: Name  
            Value: private-1a  
```  
## パラメータ定義  
Cloudformationでは以下のようにパラメータを定義し、代入することが可能である。  

```
Parameters:  
 BucketNameShizai: #パラメータ名。何でもOKと思われる。  
  Type: String # パラメータのタイプ定義。  
  Description: Name for Shizai BucketName # パラメータの説明文。何でもOKと思われるが分かりやすい説明が良い。  
  Default: ma-kuramochiku-shizai # デフォルト値。特に設定しなくても良い。  
  
Resources:  
  S3BucketShizai:  
    Type: AWS::S3::Bucket  
    Properties:  
      AccessControl: Private  
      BucketName: !Ref BucketNameShizai # 事前に定義したパラメータの利用。 
```  
なお、実際にパラメータの値に何を入れるかはAWSマネジメントコンソールからスタックを作成するタイミングでパラメータ画面が表示される。  
デフォルト設定している場合は本画面表示時に値が入っている。  

### 入力パラメータの限定  
``` 
Parameters:  
  Env:  
    Type: String  
    Default: dev  
    AllowedValues: # 入力値を以下に限定する  
      - dev  
      - prod  
    Description: "Enter an environment name" 
```  
AllowedValuesを用いることで入力値を限定することができる。スタック作成時にはドロップダウンリストで表示される。  

## !Refと!Subの使い分け  
CloudFormationの組み込み関数として、!Refと!Subがあります。  
これらは基本的には同一であり、論理名を参照し、規定の値に変換する。  

### 使い方注意  
!Refは論理名を直接表記するのに対し、!Subは論理名を${}でくくって使用する。  
なお、!Ref で参照する論理名を${}でくくると、CloudFormationはエラーを返す。  
!Subで${}を忘れた場合、エラーは発生しないが後述の文字列を結合する作用の関係で論理名が文字列として認識されるため、変換が行われない。  

### 文字列との結合  
!Subは、そのまま変数と文字列を結合可能である。!Refでは文字列の結合は行えない。  

```
      BucketName: !Sub ${BucketNameShizai}-test
      
      BucketName: !Sub ${BucketNameShizai}-test-${Env} 
      
```  

## Outputsの使い方  
Cloudformationでは、Outputsセクションを定義することでクロススタック(他スタックに値を引き渡)したり、値をマネジメントコンソール上に表示することができる。  
以下では値の引き渡しについて記載する。サンプルコードは以下となる。  

```
エクスポート元.yaml  
Outputs:  
  VpcId:  
    Value: !Ref VPC # 省略しているが、本スタック内で作成したVPCの情報をエクスポート対象とする。  
    Export: # 渡す値をExportで出力する  
      Name: VpcId # VpcIdというパラメータ名でエクスポートする。  
      
インポート先.yaml  
  Properties:  
    VpcId: !ImportValue VpcId # 事前にエクスポートしていたVpcIdというパラメータを利用する。  
    CidrBlock: 10.250.251.0/28  
```  
クロススタック参照には以下の制限があります。  
* AWS アカウントごとに、Export 名前がリージョン内で一意である必要があります。  
* リージョン間でクロススタック参照を作成することはできません。組み込み関数 Fn::ImportValue を使用して、同じリージョン内にエクスポートされた値のみをインポートできます。  
* 出力の場合、Export の Name プロパティの値は、リソースに依存する Ref または GetAtt の関数を使用できません。  
* 同様に、ImportValue 関数にリソースに依存する Ref または GetAtt 関数を含めることはできません。  
* 別のスタックがその出力の 1 つを参照している場合、スタックを削除することはできません。  
* 別のスタックによって参照されている出力値を変更または削除することはできません。  

## 発生したエラーのメモ  
### 論理ID定義ミス  
``` 
Template format error: Unresolved resource dependencies [PublicRouteTable, PublicSubnet1C] in the Resources block of the template 
``` 
単純な論理IDのミス。定義していない論理IDを設定したことによるエラー。名前を修正することで解決。  

### 論理IDに使用してはいけない文字を使用 
``` 
CloudFormation:: Parameter is non alphaNumeric 
``` 
論理IDに使えない文字を使用したことによるエラー。ハイフンもNGとのこと。  

### 論路IDの重複  
論理 ID が重複する複数のリソースを作成すると、そのうち 1 つのリソースのみが作成される。  
論理 ID が重複するリソースを CloudFormation テンプレートで定義した場合には、意図した設定のリソースが作成されない可能性がある。  

### 何かが違う・・・？  
ELBのリソース作成時に以下エラーが出力  
マニュアルを見てもStringが入るべき場所なのに「JSONArray」を想定しているというエラー  
``` 
Properties validation failed for resource ALBName with message: #/SecurityGroups: expected type: JSONArray, found: String 
```
意味が分からなかったが、以下のように記載の仕方を変えてみたら通った。謎・・・。  

```
      SecurityGroups: !Ref ALBSG 
↓
      SecurityGroups: 
        - !Ref ALBSG 
```  
### 設定値の大文字、小文字によるエラー  
ELB作成時に以下エラーが発生した。 
「internal」にしているはずだよな、スペルミスかなと確認したところ「Internal」となっていた。  
これだけで動かないのかと思いつつ、変更して実行したところ正常に動作した。  
なお、エラーの直接的な意味としては「設定された値が想定されているものと違うから確認してね」といったところである。  

``` 
Resource handler returned message: "1 validation error detected: Value 'Internal' at 'scheme' failed to satisfy constraint: Member must satisfy enum value set: [internet-facing, internal] (Service: ElasticLoadBalancingV2, Status Code: 400, Request ID: 62e736d4-648f-4056-9f86-e6f9c04b0f0d)" (RequestToken: 87e3adf8-9100-9416-23a5-dae97f4295e0, HandlerErrorCode: InvalidRequest)  
```
### よく分からない系  
ちゃんとメモしていなかったが、スタックを実行しようとするが実行前に構文エラー。  
デザインページで構文チェックするも問題なし。  
何度かファイルを読み直すと、そのまま通ったためスタック実行して特にエラーなく終了。  

似た話でインポートした変数が存在しないというエラーで、スタックの実行ができないことがあった。  
エクスポート元のスタックでは変数出力出来ているようにしか見えないず、ググってもよく分からず。  
試しに変数部分をハードコーディングに変更し、他にあったエラーを解消してから再度インポート変数化したところ、問題なく実行できた。  
マネコン実行前のチェックによるエラーはよく分からない。(別のエラーとかに引っ張られた？)  

## 小技  
### VPC Cidr関数  
Subnet作成時にVPC Cidrの範囲から作成することとなるが、これらをハードコーディングするのは不便である。  
これを関数で解決するのが以下となる。  
``` 
!Select [ 1, !Cidr [ !GetAtt VPC.CidrBlock, 2, 7 ]] 
``` 
カンマで区切られた4つのエリアについて以下に説明する。  
1.取り出すデータ領域の指定 配列に格納された何番目のデータを取り出すか指定する。  
  配列は「0」から始まるので1つ目のデータを取り出したい場合は「0」と指定し、3番目のデータを取り出したい場合は「2」と指定する。  

2.元データを指定 配列に格納される元データを指定する。  

3.作成する配列データの数を指定 何個の配列データを作成するかを指定する。  

4.サブネットビットを指定 サブネットビットはサブネットマスクの逆である。例えば/24を指定したい場合は8、/25を指定する場合は7となる。  

### AZ取得関数 
以下のような記述とすることでサブネットのアベイラビリティーゾーンを指定できる。どちらも同じ意味である。  
```  
    AvailabilityZone:  
      Fn::Select:  
        - 0   
        - Fn::GetAZs: "" 
``` 
``` 
AvailabilityZone: !Select  
  - 0  
  - Fn::GetAZs: !Ref 'AWS::Region' 
```  

◆注意点 
本機能は「デプロイ先リージョンのすべての AZ をリスト」する機能ではない。  
デフォルト VPC が存在するリージョンでは、デフォルトのサブネットがあるアベイラビリティーゾーンのみを返却する。  

## その他 
### IAMインスタンスプロファイル  
EC2にIAM権限を付与する時は「IAMインスタンスプロファイル」というものをEC2にアタッチする。  
インスタンスプロファイルはEC2のみに使われる概念であり、IAMロールを作成すると自動で同名のIAMインスタンスプロファイルが作成されるため、あまり意識することは無い。  
ただし、Cloudformationでは明示的に作成する必要があるため、注意が必要である。 
``` 
AWSTemplateFormatVersion: "2010-09-09"
Resources:  
  EC2Instance:  
    Type: "AWS::EC2::Instance"  
    Properties:
      IamInstanceProfile: !Ref IAMRole  
      Tags:   
        - 
          Key: "Name"  
          Value: "Test"  
    
  IAMRole:  
    Type: "AWS::IAM::Role"  
    Properties:  
      Path: "/"  
      RoleName: "Test-Role"  
      AssumeRolePolicyDocument: "{\"Version\":\"2012-10-17\",\"Statement\":[{\"Effect\":\"Allow\",\"Principal\":{\"Service\":\"ec2.amazonaws.com\"},\"Action\":\"sts:AssumeRole\"}]}"     
      
      # IAMインスタンスプロファイルを作成する必要がある   
  IAMInstanceProfile:  
    Type: "AWS::IAM::InstanceProfile"  
    Properties:  
      Path: "/"
      InstanceProfileName: !Ref IAMRole  
      Roles:  
        - !Ref IAMRole
```  

### SSM接続  
LinuxのEC2にSSM接続するためには以下の設定が必要である。  
1,EC2に「AmazonSSMManagedInstanceCore」ポリシーを付与したIAMロールを設定する。  
2,EC2にSSMAgentをインストールし、起動する。(AmazonLinuxは初期インストール済み)  
3,インターネット接続不可なEC2の場合は以下エンドポイントを設定する。  
* com.amazonaws.region.ssm  
* com.amazonaws.region.ec2messages  
* com.amazonaws.region.ssmmessages  

なお、Cloudformationでエンドポイントを作成する場合、タグの付与は出来ないようである。作成後に手動追加が必要。(結構不便・・・)

