# my-terraform
個人の検証用で使うTerraform

# Getting Started

## Terraformのインストール

Terraform 0.12.8 で動作します。（2019-09-12時点での最新安定版）

[tfenv](https://github.com/tfutils/tfenv) 等を使ってTerraform本体をインストールして下さい。

## AWSクレデンシャルの設定

`providers/aws/environments/**/backend.tf` を見ると分かるのですが、 `profile` で `nekochans-dev` という名前を使っています。

従って以下のように [名前付きプロファイル](https://docs.aws.amazon.com/ja_jp/cli/latest/userguide/cli-configure-profiles.html) を作成して下さい。

`~/.aws/credentials`

```
[nekochans-dev]
aws_access_key_id=YOUR_AWS_ACCESS_KEY_ID
aws_secret_access_key=YOUR_AWS_SECRET_ACCESS_KEY
```

無論このプロファイル名は好きな名前に変えてもらって問題ありません。

その場合は `providers/aws/environments/**/backend.tf` 内の `profile` を全て修正して下さい。

## tfstateを保存するS3バケットを用意する

tfstateはS3バケットに保存しています。

このS3バケットはTerraformの管理対象外なので、事前に作成します。

S3バケットの名前は `providers/aws/environments/**/backend.tf` に記載されています。

`keitakn-tfstate` がS3バケットの名前です。

S3バケットは同じ名前で作成その為、本リポジトリをフォークして別のプロジェクトを始める場合、別の名前を付ける必要があります。

これは他のS3バケットにも言える事です。

`modules/aws/` 配下を `aws_s3_bucket` で検索してS3バケットリソースの名前を変更して下さい。

## Route53のホストゾーンへドメインを登録する

[modules/aws/api/variable.tf](https://github.com/keitakn/my-terraform/blob/7217f5879d99baffbcaeaabc0f07b99a53e56f63/modules/aws/api/variable.tf#L48) に定義されています。

`keitakn.de` というドメイン名が登録されていますが、同じドメイン名は登録する事が出来ません。

よってこちらも本リポジトリをフォークした際に問題となるので、違うドメインを取得してホストゾーンを作成して下さい。

Route53でドメインを購入しても良いですが、https://www.onamae.com/ 等で安価なドメインを用意するのも良いでしょう。

下記の記事等が参考になるでしょう。

```
（参考）お名前.comでのドメイン取得とRoute 53との連携(お名前.comへのRoute 53DNS登録)
http://nopipi.hatenablog.com/entry/2019/01/03/132701
```

## AWS Certificate Managerで証明書を取得する

`*.取得したドメイン名` で証明書を取得して下さい。（無料です）

証明書は `ap-northeast-1` で作成すればとりあえず大丈夫です。

しかしCloudFront等一部のサービスは `us-east-1` の証明書しか利用出来ないので、取得しておいても良いでしょう。
