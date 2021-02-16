# my-terraform
個人の検証用で使うTerraform

# Getting Started

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

## AWS Secrets Manager

`providers/aws/environments/10-ssm/main.tf` でParameterStoreを作成しています。

これの元になるSecretManagerを事前に作成しておく必要があります。

- `${terraform.workspace}/keitakn/sendgrid`

```json
{
  "API_KEY": "中身は文字列なら何でもOK"
}
```

- `${terraform.workspace}/keitakn/slack`

```json
{
  "TOKEN": "中身は文字列なら何でもOK"
}
```

`${terraform.workspace}` の部分には任意のworkspace名を入れて下さい。

例えば `terraform workspace new dev` を実行し `dev` という名前のworkspaceを作成した場合、 `dev/keitakn/slack` という名前でSecretManagerを作成します。

こうする事によって共通の機密情報を複数のアプリケーションで使い回せるようにしてあります。

詳しくは [AWS Secrets ManagerからParameter StoreをTerraformで作成する](https://qiita.com/keitakn/items/55da7f9f3c3659cfc804) という記事を参考にして下さい。

## Terraformのインストール（Dockerで動くようになったので任意です）

[tfenv](https://github.com/tfutils/tfenv) 等を使ってTerraform本体をインストールして下さい。

バージョンはDockerfileに書いてあるので参照して下さい。

## 作業用のコンテナを起動させる

初回は以下のコマンドを実行します。

`docker-compose up --build -d`

2回目以降は以下のコマンドでOKです。

`docker-compose up -d`

# 設計方針について

https://github.com/nekochans/terraform-boilerplate と設計方針は同じです。

以下の順番で `terraform init` および `terraform apply` を実行して下さい。

Docker起動後にホストOS上で以下のコマンドを実行すると `terraform init` が実行されます。

```
chmod 755 terraform-init-dev.sh
docker-compose exec terraform ./terraform-init-dev.sh
```

1. `providers/aws/environments/10-network/`
1. `providers/aws/environments/10-ssm/`
1. `providers/aws/environments/11-ecr/`
1. `providers/aws/environments/11-cognito/`
1. `providers/aws/environments/20-api/`
1. `providers/aws/environments/20-eks`

マルチリージョン、マルチAZで稼働する前提になっているので、合計6つのNAT Gatewayが起動します。

その為、起動させておくとそこそこ料金がかかるので、動作確認後は `terraform destroy` でリソースを削除しておく事をオススメします。

`20-api` では以下の2つのアプリケーションが起動します。

これらのアプリケーションをECRにプッシュする事でAWS Fargateのクラスタが動作します。

- https://github.com/keitakn/go-rest-api
- https://github.com/keitakn/go-graphql
