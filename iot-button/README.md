# 在庫切れ通知IoTボタン

IoTボタンを押すことで、オフィス用品の在庫切れを通知します。

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
