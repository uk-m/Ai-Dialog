# AiDia (AI Diary)

AI 写真日記サービス **AiDia** のモノレポです。Docker 上で Rails API・Sidekiq・React(Vite)・PostgreSQL・Redis・MinIO を一括で動かし、画像アップロード→EXIF/OCR 解析→OpenAI による日記ドラフト生成→公開までをサポートします。

## ディレクトリ構成

```
.
├─ apps/
│  ├─ api/   # Rails 8.1 (API + HTML)
│  └─ web/   # React + Vite + Tailwind + shadcn
├─ docker-compose.yml
├─ Procfile.dev
├─ Makefile
└─ .env.example
```

## 事前準備

- Docker / Docker Compose v2
- Node.js 20 系（ローカルで `pnpm` を使う場合）
- Ruby / Bundler（ローカルで直接 Rails を動かす場合）

※ この実行環境には `ruby` / `node` コマンドが入っていないため `bundle install` や `pnpm install` を実行できていません。各自の開発環境で依存関係を再インストールし、`apps/api/Gemfile.lock` と `apps/web/pnpm-lock.yaml` を再生成してください。

## セットアップ手順

```bash
cp .env.example .env             # 初回のみ
make bootstrap                   # 依存取得 + DB 初期化
make up                          # Rails / Sidekiq / Vite / DB / Redis / MinIO を起動
```

### 主な Makefile タスク

| コマンド        | 説明                                         |
|-----------------|----------------------------------------------|
| `make up`       | Docker Compose で全サービスを起動             |
| `make down`     | コンテナ停止 & クリーンアップ                 |
| `make logs`     | すべてのサービスログを tail                  |
| `make console`  | Rails console                                 |
| `make db-shell` | PostgreSQL シェル                             |
| `make seed`     | Seed データ投入 (`demo@aidia.local`)          |
| `make lint-api` | RuboCop                                       |
| `make lint-web` | eslint                                        |

### エンドポイント

- Rails API: http://localhost:3000
- Sidekiq Web UI: http://localhost:3000/sidekiq
- フロント (Vite): http://localhost:5173
- MinIO Console: http://localhost:9001 (ユーザー/パスは `.env` を参照)

## バックエンド概要 (apps/api)

- Rails 8.1 / Ruby 3.4 / PostgreSQL / Redis
- Devise + devise_token_auth による API 認証（ヘッダー: `access-token`, `client`, `uid` など）
- ActiveStorage (MinIO/S3 互換) + CarrierWave 共存
- ActiveJob + Sidekiq
  - `DiaryIngestionJob`: ActiveStorage 画像から EXIF / 簡易 OCR / ラベル抽出
  - `DiaryDraftJob`: OpenAI でタイトル/本文/ムード/タグを JSON schema で生成
  - `WeeklyDigestJob`: 週次まとめを生成し `weekly_digests` に upsert
- Seeds で `demo@aidia.local / password12345!` を作成（メール確認済み）
- `config/initializers/openai.rb`, `carrierwave.rb`, `sidekiq.rb`, `cors.rb` などで外部サービスを一括管理

## フロントエンド概要 (apps/web)

- React 19 + TypeScript + Vite
- Tailwind CSS + shadcn 風 UI コンポーネント
- 状態管理: Jotai (ユーザープリファレンス) / Zustand (アップロードキュー)
- 主要ページ
  - `/` タイムライン + 下書き一覧
  - `/calendar` カレンダーヒートマップ
  - `/upload` 画像アップロード & 進行状況
  - `/weekly` 週次まとめ
  - `/settings` Jotai 連携のプリファレンス保存
  - `/entries/:id` 日記編集
- `axios` クライアントは `devise_token_auth` のトークンをローカルストレージに保存し、以降の API リクエストに自動付与
- `.env` の `VITE_API_BASE_URL` で API エンドポイントを変更可能

## Docker / Compose

- `api` / `worker` は同一 Rails イメージを共有し、ボリュームで `storage`, `bundle_cache` を永続化
- `web` は `node:20-alpine` + `pnpm` ベース
- `db`: Postgres 16, `redis`: 7, `minio`: コンソール付き
- `make bootstrap` 時に DB を `db:setup`、MinIO には `aidia-uploads` バケットを利用

## 環境変数

`.env.example` に主要キーを掲載しています。最低限以下は本番用に差し替えてください。

- `OPENAI_API_KEY` / `OPENAI_MODEL`
- `MINIO_ACCESS_KEY` / `MINIO_SECRET_KEY` / `MINIO_ENDPOINT`
- `SIDEKIQ_WEB_USERNAME` / `SIDEKIQ_WEB_PASSWORD`
- `DEVISE_SECRET_KEY`

## 認証フロー

1. `POST /auth/sign_in` で `access-token`, `client`, `uid`, `expiry`, `token-type` を取得。
2. それらをフロントの `localStorage` に保存。
3. 以降の API リクエストで自動的にヘッダー付与。

## OCR / AI について

- OCR は `tesseract` CLI を呼び出しています（`ImageAnalyzer` に `TODO` コメントあり）。Vision API などに置き換える場合は同クラスを差し替えてください。
- OpenAI 呼び出しは JSON Schema モードで強制し、失敗時はフォールバックテキストを返すようにしています。

## Procfile 開発

Docker を使わずにローカルで試す場合は以下。

```bash
overmind start -f Procfile.dev
```

## 未実行の検証

この環境では各ランタイムがインストールされていないため以下を実行できていません。ローカルで必ず実施してください。

```bash
cd apps/api && bundle install
cd apps/web && pnpm install
```
