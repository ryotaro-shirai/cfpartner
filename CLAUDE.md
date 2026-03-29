# CLAUDE.md

## プロジェクト概要

CfPartner（CfP Partner）は、カンファレンスのCfP（Call for Proposals）締切情報を一元管理し、プロポーザルを出したいエンジニアを支援するWebアプリケーション。Rails 8.1.1製。アプリケーションコードはすべて `web/` 以下に存在する。

このプロダクトはオーナーの技術的な看板であり、設計判断の質が問われるプロダクトとして扱うこと。

---

## 技術スタック

- Ruby on Rails 8.1.1
- Hotwire（Turbo + Stimulus）／importmap経由
- PostgreSQL 17
- RSpec
- GitHub Actions
- PaaS（現フェーズ）／Kamal（`config/deploy.yml`）

---

## 現在のフェーズ：Ph2（7〜8月リリース目標）

### Ph2スコープ

- ユーザー管理（GitHub/Google OAuth）
- リマインド通知設定
- リマインド通知
- CI/CD導入

### Ph1（完了済み）

- Web一覧表示
- 簡易管理画面（Basic認証）

### Ph3以降（今は着手しない）

- CfP情報の自動収集
- お気に入り機能
- 検索・ソート・絞り込み
- Rails + Reactへのリプレイス
- Fargate + Terraform管理

---

## 開発コマンド

以下のコマンドは、特記のない限りDockerコンテナ内での実行を前提とする。

### Docker（推奨）

```bash
# サービス起動
docker-compose up -d

# DBセットアップ（初回）
docker-compose exec cfpartner-web bin/rails db:create db:migrate db:seed

# Railsコンソール
docker-compose exec cfpartner-web bin/rails console

# 全テスト実行
docker-compose exec cfpartner-web bundle exec rspec

# 単一テストファイルの実行
docker-compose exec cfpartner-web bundle exec rspec spec/models/talk_recruitment_spec.rb

# 行番号指定でテスト実行
docker-compose exec cfpartner-web bundle exec rspec spec/models/talk_recruitment_spec.rb:10

# Lint
docker-compose exec cfpartner-web bundle exec rubocop

# Lint自動修正
docker-compose exec cfpartner-web bundle exec rubocop -a

# ERB Lint（末尾改行・trailing whitespace・スペース等）
docker-compose exec cfpartner-web bundle exec erb_lint --lint-all

# セキュリティチェック
docker-compose exec cfpartner-web bundle exec brakeman
docker-compose exec cfpartner-web bundle exec bundler-audit
```

### ローカル（Dockerなし）

```bash
cd web
bundle install
bin/rails db:create db:migrate db:seed
bin/rails server
bundle exec rspec
bundle exec rubocop
```

---

## アーキテクチャ

### データモデル

`has_many` / `belongs_to` 関係を持つ2つのコアモデル：

- **`Event`** — カンファレンス情報（`name`, `site_url`, `thumbnail_url`, `start_at`, `end_at`, `status`）。Active Storageによる画像添付あり。  
  Statusのenum：`published_information(1)`, `now_on_the_event(2)`, `after_the_event(3)`
- **`TalkRecruitment`** — Eventに属するCfPエントリ（`title`, `site_url`, `start_at`, `end_at`, `status`, `talk_type`）。  
  Statusのenum：`no_information(1)`, `published_information(2)`, `now_on_call(3)`, `finished_call(4)`  
  Talk typeのenum：`session`, `short_session`, `lightning_talk`, `other`

### ルーティング・コントローラ

- **`/`** → `TalkRecruitmentsController#index`（一般公開のCfP一覧）
- **`/admin/*`** → `Admin::EventsController`, `Admin::TalkRecruitmentsController`
  いずれも `AdminController` を継承し、環境変数 `BASIC_AUTH_USER` / `BASIC_AUTH_PASSWORD` によるHTTP Basic認証を強制する。
- 管理画面のコントローラは現時点で `new` / `create` のみ実装。`edit` / `update` / `destroy` / `index` は未実装（将来対応）。

### ステータス管理の設計方針

- **ステータス更新はバッチ（`UpdateStatusBatch`）に完全委任する。**
  - `Event.status` も `TalkRecruitment.status` も、管理画面のフォームからは変更できない。
  - Strong Parameters から `status` を除外するのはこの設計方針に基づく。
  - 「バッチが次回実行されれば上書きされるから問題ない」ではなく、「中間状態の不整合を生まない設計」として意図的にフォームから除外している。

### スコープ設計

- **`Event.accepting_cfp`** — CfP登録対象のイベントを返す。`where(status: :published_information)` で絞り込む。
  - 開催中（`now_on_the_event`）・終了後（`after_the_event`）のイベントへのCfP登録は不可とする設計判断。
  - 管理画面の `Admin::TalkRecruitmentsController` はこのスコープを `fetch_accepting_cfp_events` private method 経由で使用する。

### ステータスロジック

- `TalkRecruitmentsHelper#status_badge`：親Eventのステータスを優先マージする。Eventが `now_on_the_event` または `after_the_event` の場合、TalkRecruitment自身のステータスより優先される。
- `TalkRecruitmentsHelper#deadline_chip`：期限チップの色を算出する（当日=赤、3日以内=オレンジ、3日超=青、期限切れ=グレー）。

### バッチ処理

`app/batches/update_status_batch.rb` — 手動またはRails runner経由で実行。`start_at` / `end_at` と現在時刻を比較し、EventとTalkRecruitmentのステータスをトランザクション内で更新する。非本番環境では `log/batch.log`（週次ローテーション）、本番環境ではstdoutにログ出力する。

### インフラ

- PostgreSQL 17（ホスト側ポート：15432 / コンテナ側ポート：5432）
- Selenium Chromium（ポート：4444、システムテスト用）
- アセットパイプライン：Propshaft
- JS：Stimulus + Turbo（Hotwire）via importmap
- ジョブキュー：SolidQueue（定期ジョブ設定：`config/recurring.yml`）
- デプロイ：Kamal（`config/deploy.yml`）

---

## コードレビュー方針

このプロダクトのレビューは「動くか」ではなく「なぜそう設計したか」を問う。オーナーはリードエンジニアを目指しており、レビューはその成長を促すために厳しく行うこと。

### 最重要ルール

1. **すべての設計判断に「なぜ」を求めよ**
   - 「よく見るパターンだから」「Railsのデフォルトだから」は理由として不十分
   - このプロダクト固有の文脈（規模、フェーズ、ユーザー像）を踏まえた判断を求める
   - 他の選択肢とトレードオフを言語化できていない設計は指摘する

2. **スコープ逸脱を即座に止めよ**
   - Ph2に不要な機能や技術の先行導入を見つけたら指摘する
   - React、Terraform、Fargate、自動収集パイプラインへの着手はPh3以降
   - 「それは今やるべきことか？」と問いかける

3. **過剰設計を止めよ**
   - 現時点のユーザー数・トラフィックに対して過剰な抽象化や最適化を見つけたら指摘する
   - 完璧なテストカバレッジへのこだわりより、リリースを優先させる
   - ただし、通知基盤など将来の拡張が明確な箇所は設計の余地を残すことを求める

### レビュー結果出力のルール
- レビュー結果はレビュー依頼時に指定するフォルダに `YYYYMMDD-{変更内容の概略}.md` を作成し、そちらにレビュー結果を記載してください。
- 前回のレビュー結果ファイルに実装者からのコメントというのを記載しているので、そちらも確認して上記で新規作成したレビュー結果ファイルにコメントをください。
- コンソール上にもレビュー結果のサマリを表示してください。
- レビュー結果の冒頭には以下のような情報を入れてください。
  ```
   - **日付**: 2026-03-15
   - **ブランチ**: feature/update-admin-page → main
   - **変更ファイル数**: 6ファイル（104行追加 / 28行削除）
  ```

---

### コード品質基準

#### 設計

- Fat Controllerを許さない。ビジネスロジックはモデル層またはサービスオブジェクトに置く
- Fat Modelも許さない。モデルが複数の責務を持ち始めたらサービスオブジェクトやValueオブジェクトへの分離を求める
- コールバック（`before_save`, `after_create` など）の利用には明確な理由を求める。副作用が暗黙的に実行される設計を避ける
- N+1クエリを許さない。`includes` / `preload` の適切な使用を確認する
- DBのインデックス設計を確認する。外部キー、頻出WHERE句のカラムにインデックスがなければ指摘する
- `before_action` の使用は、アクション数が増えてから検討する。現時点のアクション数（2〜3）では private method への委譲で十分。
- ビューから直接DBクエリを発行することを禁止する（Fat View）。クエリはコントローラで実行し、インスタンス変数で渡す。
- スコープ名はドメイン語彙を使う。`upcoming`（時間軸概念）より `accepting_cfp`（ドメイン操作）のように、プロダクトの言葉で命名する。
- `ORDER BY` を明示しない `Model.all` は使用しない。順序が必要な場面では必ず `order` を指定する。

#### 命名

- メソッド名、変数名、クラス名が意図を正確に伝えているか確認する
- 曖昧な名前（`data`, `info`, `handle`, `process`, `manager` など）を見つけたら具体的な名前への変更を求める
- Railsの規約に沿った命名になっているか確認する

#### エラーハンドリング

- 外部サービス連携（OAuth、通知送信など）では必ず例外処理を行う
- `rescue StandardError` のような広すぎる例外キャッチを見つけたら、具体的な例外クラスの指定を求める
- エラー時のユーザー体験（フラッシュメッセージ、リダイレクト先）が適切か確認する

#### テスト

- モデルのバリデーションとスコープのテストは必須
- サービスオブジェクトの正常系・異常系テストは必須
- 統合テストはクリティカルパス（ユーザー登録、CfP一覧表示、通知設定）に限定してよい
- テストの可読性を重視する。`context` / `describe` の構造がテスト対象の振る舞いを正確に記述しているか確認する
- factoryの定義が最小限か確認する。テストに不要な属性をfactoryに含めない
- **`let!` で統一する。** `let` と `let!` の混在はコグニティブロードを高めるため、DBレコードか否かによらず `let!` で統一する方針。
- **RSpec `describe` の命名規則を厳守する。** インスタンスメソッドは `describe '#method_name'`、クラスメソッド・スコープは `describe '.method_name'`。
- **リクエストスペックの変数名に `describe` スコープ内のコンテキストが自明な接頭辞をつけない。** `describe "Admin::TalkRecruitments"` の中であれば `talk_recruitment_title` ではなく `title` で十分。

#### セキュリティ

- Strong Parametersが適切に設定されているか確認する
- 認証・認可の境界が明確か確認する。管理画面と一般ユーザー画面のアクセス制御を特に注意する
- OAuthトークンやAPIキーがコードにハードコードされていないか確認する
- CSRFトークンの保護が有効か確認する

#### マイグレーション

- マイグレーションが可逆か（rollback可能か）確認する
- NOT NULL制約、デフォルト値、インデックスが適切に設定されているか確認する
- 既存データがある状態でのマイグレーション安全性を確認する

---

### Ph2固有のレビュー観点

#### OAuth実装

- OmniAuthの設定が適切か確認する
- セッション管理の設計判断を問う（Cookieベース vs DBセッション、有効期限の設計根拠）
- 複数プロバイダ対応を見据えたユーザーモデル設計になっているか確認する
- OAuth失敗時のフォールバックが実装されているか確認する

#### 通知基盤

- ジョブの設計を厳しく問う。Sidekiqを使う場合はリトライ戦略と冪等性の担保を必ず確認する
- 通知のスケジューリング設計の判断根拠を求める（cron vs 個別ジョブスケジューリング）
- 通知の配信状態管理（送信済み、失敗、リトライ中）の設計を確認する
- 将来のマルチチャネル対応（メール、Slack、ブラウザ通知）を見据えた拡張性があるか確認する。ただし今実装するのはメール通知のみでよい

#### CI/CD

- GitHub Actionsのワークフローが適切に分割されているか確認する（テスト、リント、デプロイ）
- テスト実行の高速化（並列実行、キャッシュ活用）が検討されているか確認する
- デプロイのロールバック手順が考慮されているか確認する

---

### Hotwire固有のルール

- Turbo Frameの分割粒度が適切か確認する。ページ全体をひとつのFrameにしていたら指摘する
- Stimulus Controllerが肥大化していたら分割を求める
- Turbo Streamの使用箇所では、WebSocket接続の管理とフォールバックを確認する

---

### Git運用

- コミットメッセージは変更の意図を記述する。「fix」「update」のみのメッセージは不可
- 1つのPRは1つの関心事に絞る。複数の機能変更が混在するPRは分割を求める
- PRの説明には「何を変えたか」「なぜ変えたか」「他に検討した選択肢」を記載する

---

### レビューのトーン

- 妥協しない。曖昧な実装や根拠のない設計判断を見逃さない
- 単に問題を指摘するだけでなく「なぜそれが問題なのか」「リードエンジニアならどう判断するか」の観点を添える
- 良い設計判断にはその理由とともに明確に評価する
- ブログや登壇で話せるレベルの設計判断を目指させる