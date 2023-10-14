# 世界時計API

日本時間をPOSTすると世界各地の時刻をJSON形式でレスポンスするAPIです。

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

## ローカル実行

```bash
sam build
sam local invoke WorldClockFunction --event events/event.json
```

```bash
sam local start-api
curl http://localhost:3000/
```

## テスト

```bash
bundle exec ruby tests/unit/test_handler.rb
```

## クリーンアップ

```bash
sam delete --stack-name world-clock-api
```
