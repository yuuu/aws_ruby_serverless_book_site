# 勤務通知API

Slackを経由して出勤・退勤を通知するAPIです。

## システム環境

- Ruby 3.2.2
- SAM CLI 1.97.0
- Docker

## デプロイ

```bash
sam build
sam deploy --guided

# 開発中の同期
sam sync --watch
```

## ログ出力

```bash
sam logs -t
```

## クリーンアップ

```bash
sam delete
```
