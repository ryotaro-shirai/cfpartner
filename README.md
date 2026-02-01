# CfPartner

カンファレンスのCfP（Call for Proposal）期限をひと目で把握できるシンプルな一覧アプリケーションです。

## プロジェクト構成

```
cfpartner/
├── web/              # Railsアプリケーション
│   ├── app/          # アプリケーションコード
│   ├── config/       # 設定ファイル
│   ├── db/           # データベース関連
│   ├── spec/         # テスト
│   └── README.md     # 詳細なREADME
├── docker-compose.yml # Docker Compose設定
└── README.md         # このファイル
```

## クイックスタート

### Docker Composeを使用（推奨）

```bash
# サービスを起動
docker-compose up -d

# データベースのセットアップ
docker-compose exec cfpartner-web bin/rails db:create
docker-compose exec cfpartner-web bin/rails db:migrate
docker-compose exec cfpartner-web bin/rails db:seed

# アプリケーションにアクセス
# http://localhost:3000
```

### 詳細なセットアップ手順

詳細なセットアップ手順、機能説明、開発ガイドについては、[web/README.md](./web/README.md) を参照してください。

## 主な機能

- 📋 CfP情報の一覧表示
- 🏷️ ステータスバッジによる視覚的な状態表示
- ⏰ 締め切りまでの残り日数表示
- 📅 イベント開催日程の表示
- 🔗 CfP提出先・イベントサイトへのリンク
- 🛠️ 管理画面でのイベント・CfP情報管理

## 技術スタック

- Ruby on Rails 8.1.1
- PostgreSQL
- Docker & Docker Compose
- RSpec（テスト）

## ライセンス

（ライセンス情報を記載）
