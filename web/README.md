# CfPartner

カンファレンスのCfP（Call for Proposal）期限をひと目で把握できるシンプルな一覧アプリケーションです。

## 概要

CfPartnerは、技術カンファレンスのCfP募集情報を一元管理し、締め切りまでの残り日数を視覚的に表示するWebアプリケーションです。イベント主催者は管理画面からイベントとCfP情報を登録・管理でき、参加者はTOPページで一目で締め切り情報を確認できます。

## 主な機能

### ユーザー向け機能
- **CfP一覧表示**: イベントのCfP情報をカード形式で一覧表示
- **ステータス表示**: イベントの状態（募集中、募集終了、イベント開催中など）をバッジで表示
- **締め切りカウントダウン**: 締め切りまでの残り日数を色分けされたチップで表示
  - 本日締切（赤）
  - あと3日以内（オレンジ）
  - あと4日以上（青）
  - 締め切り済み（グレー）
- **日程情報**: 提出締め切りとイベント開催日程をアイコン付きで表示
- **アクションボタン**: 
  - Submit Proposal（募集受付中の場合）
  - Submissions Closed（募集終了の場合）
  - Event Page（イベント公式サイトへのリンク）

### 管理機能
- **イベント管理**: イベントの作成・編集・削除
- **CfP情報管理**: 各イベントに紐づくトーク募集情報の管理
- **ステータス管理**: イベントとCfPの状態を適切に管理

## 技術スタック

- **フレームワーク**: Ruby on Rails 8.1.1
- **データベース**: PostgreSQL
- **アセット管理**: Propshaft
- **JavaScript**: Stimulus + Turbo (Hotwire)
- **テスト**: RSpec + FactoryBot
- **コンテナ**: Docker Compose

## セットアップ

### 必要な環境

- Docker & Docker Compose
- Ruby 3.4.3（ローカル開発の場合）

### Docker Composeを使用したセットアップ

1. リポジトリをクローン
```bash
git clone <repository-url>
cd cfpartner
```

2. 環境変数ファイルを作成
```bash
cp .env.example .env
# .envファイルを編集して必要な環境変数を設定
```

3. Docker Composeでサービスを起動
```bash
docker-compose up -d
```

4. データベースのセットアップ
```bash
docker-compose exec cfpartner-web bin/rails db:create
docker-compose exec cfpartner-web bin/rails db:migrate
docker-compose exec cfpartner-web bin/rails db:seed
```

5. アプリケーションにアクセス
- アプリケーション: http://localhost:3000
- 管理画面: http://localhost:3000/admin/events

### ローカル開発環境のセットアップ

1. 依存関係のインストール
```bash
cd web
bundle install
```

2. データベースのセットアップ
```bash
bin/rails db:create
bin/rails db:migrate
bin/rails db:seed
```

3. サーバーの起動
```bash
bin/rails server
```

## データベース構造

### Events（イベント）
- `name`: イベント名
- `site_url`: イベント公式サイトURL
- `thumbnail_url`: サムネイル画像URL
- `start_at`: イベント開始日時
- `end_at`: イベント終了日時
- `status`: ステータス（published_information, now_on_the_event, after_the_event）

### TalkRecruitments（トーク募集）
- `title`: 募集タイトル
- `site_url`: CfP提出先URL
- `start_at`: 募集開始日時
- `end_at`: 募集締切日時
- `status`: ステータス（no_information, published_information, now_on_call, finished_call）
- `talk_type`: トーク種別（session, short_session, lightning_talk, other）
- `event_id`: 関連するイベントID

## テスト

### テストの実行

```bash
# 全テストを実行
bundle exec rspec

# 特定のファイルのテストを実行
bundle exec rspec spec/helpers/talk_recruitments_helper_spec.rb

# 特定のテストを実行
bundle exec rspec spec/models/talk_recruitment_spec.rb:10
```

### テストカバレッジ

- モデル: `TalkRecruitment`, `Event`
- ヘルパー: `TalkRecruitmentsHelper`
- リクエスト: `TalkRecruitments`, `Admin`

## 開発

### コードスタイル

プロジェクトではRuboCopを使用してコードスタイルを統一しています。

```bash
# コードスタイルチェック
bundle exec rubocop

# 自動修正
bundle exec rubocop -a
```

### セキュリティチェック

```bash
# Brakeman（セキュリティ脆弱性チェック）
bundle exec brakeman

# Bundler Audit（gemの脆弱性チェック）
bundle exec bundler-audit
```

## デプロイ

Kamalを使用したデプロイに対応しています。詳細は `config/deploy.yml` を参照してください。

## ライセンス

（ライセンス情報を記載）

## コントリビューション

（コントリビューションガイドラインを記載）
