# AWSセキュリティ
AWSセキュリティについて本項にまとめる。  
AWSには「セキュリティの柱 - AWS Well-Architected Framework」という考え方がある。  
https://docs.aws.amazon.com/ja_jp/wellarchitected/latest/security-pillar/welcome.html  

このフレームワークは次の6つの柱に基づいている。  
* Operational Excellence  
→運用を効率的・効果的に実施すること。運用構築の自動化、運用手順の継続的な改善など。  
* Security  
→データやシステムなどの資産を保護して、セキュリティを強化すること。暗号化、権限最適化、全アクション追跡、トラブルシミュレーション。  
* Reliability  
→処理に欠陥や不具合がなく、期待した処理が確実に行われること。障害検知/復旧の自動化、リソースの自動拡張/削除。  
* Performance Efficiency  
→リソースを効率的に使用し、維持すること。  
* Cost Optimization  
→費用を最小限に抑え、最大限のビジネス価値を得ること。費用分析、使用する分だけ支払う、コスト効率の測定。  
* Sustainability  
→環境に対する影響、特にエネルギーの消費と効率性。使用率を最大化する。  

## GuardDuty
マネージド型脅威検出サービスのAmazon GuardDutyは、様々なログを監視し、機械学習により脅威を検出する。  
ベストプラクティスでは全てのアカウントで有効化が推奨されている。  

特徴としては以下のような点がある。  
* アカウント単位で脅威が検出できる(設定はリージョン単位？)  
* アカウント全体で継続的に監視と対応ができる  

具体的には以下の2種類のログを分析することができる。  
* AWS CloudTrail 管理イベント分析(100 万イベントあたり 4.72USD)  
* Amazon Virtual Private Cloud (Amazon VPC) フローログおよび DNS クエリログの分析(最初の500GBは GB あたり 1.18USD)  

発見的統制という考えた方があり、これは万が一セキュリティ事故が起こったとしても、通知がくるので、気づいて対応しようというものである。  
発見的統制として役に立つのがGuardDutyである。  
