# 領収書記載Bot

メンションされたメッセージに付属しているExcelファイルに日付を記入します

## システム環境

- Ruby 3.2.2
- SAM CLI 1.97.0
- Docker

## デプロイ

```bash
sam build
sam deploy --guided

# 開発中の同期
sam sync --watch --use-container
```

## ログ出力

```bash
sam logs -t
```

## クリーンアップ

```bash
sam delete
```
