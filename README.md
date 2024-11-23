# [ogadra/self-hosted-runner](https://github.com/ogadra/self-hosted-runner)

GitHub ActionsのSelf-Hosted Runnerを構築するためのリポジトリです。

## How To Use

1. 環境変数をセットします

```shell
$ cp .env.sample .env
$ nano .env
```

`GITHUB_TOKEN`は、[Fine-grained personal access tokens](https://github.com/settings/tokens?type=beta) から、以下の設定のトークンを発行し、指定してください。

- Token name
  - 識別可能な任意の値
- Resource owner
  - リポジトリに権限をもつユーザを指定
- Expiration
  - 短めの値
  - ビルド時に有効であれば良い
- Repository access
  - `Only select repositories`で、対象リポジトリを有効にする
  - または、`All repositories` （非推奨）
- Permissions
  - Repository permissions
    - Administration
      - Read and write

2. ビルド && 実行します

```shell
$ docker compose up --build -d
```

## 注意点

1. ビルド時にRunnerの登録を行う関係上、Docker Imageに環境変数（GitHubのPAT）が残ります。取り扱いに気をつけてください。
2. 現時点ではx86のイメージをダウンロードしております。別アーキテクチャを使用するの場合は、各々該当箇所を変更するか、PR作成をお願いします。
