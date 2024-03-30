# AWSとRubyではじめるサーバーレス入門

本リポジトリは技術書典15で頒布した技術書「AWSとRubyではじめるサーバーレス入門」のサンプルWebアプリケーション＆サポートページです。

![表紙・裏表紙](https://user-images.githubusercontent.com/8074640/282184290-797f7fe7-1b3c-4bcd-b2f0-a2c6a168795f.jpg)

## ディレクトリ構成

### world-clock-api

「3章 スラッシュコマンドを作る」で構築する世界時計のバックエンドです。

### notify-for-working

「4章 データベースを使う」で構築する出退勤コマンドのバックエンドです。

### receipt-writer

「5章 ファイルを処理する」で構築する受領証書き込みBotのバックエンドです。

## 正誤表

本書に下表の誤りがありました。お詫びして訂正いたします。

| ページ | 箇所 | 誤 | 正 | 補足 |
| ---- | ---- | ---- | ---- | ---- |
| P.34, 35, 39 | 図3.8, 表3.1, 図3.13 | PDT | PST | PDTは太平洋夏時間であり、夏時間の期間中(3月の第2日曜日午前2時から11月の第1日曜日午前2時まで)に限り使用可能でした。代わりにPSTを使用ください。 |
| P.63 | リスト 4.12 | notify-for-working/record_working/Gemfile | notify-for-working/notify_working/Gemfile | |

## 指摘・質問がある場合

[本リポジトリのIssues](https://github.com/yuuu/aws_ruby_serverless_book_site/issues)に書き込みをお願いいたします。

## 画像素材

- https://icooon-mono.com/
