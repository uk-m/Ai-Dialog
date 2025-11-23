# AiDia (AI Diary)

画像をアップロードすると EXIF/OCR/ラベルを元に AI が日記の下書きを生成するサービスです。開発環境は Docker Compose で Rails(API+Sidekiq) / React(Vite) / Postgres / Redis / MinIO を一括起動します。

## 構成
- ディレクトリ: `apps/api` (Rails 8.1 / Ruby 3.4) と `apps/web` (React + Vite + TS) のモノレポ
- Docker サービス: `web`(Rails), `worker`(Sidekiq), `frontend`(Vite), `db`(Postgres16), `redis`, `minio`
- 環境変数の雛形: `.env.example`（初回はこれを `.env` にコピー）

## 前提
- Docker / Docker Compose v2
- (任意) ローカルで直接動かす場合は Ruby 3.4 と Node 20 / pnpm が必要

## 初回セットアップ & 起動
```bash
cp .env.example .env        # 初回のみ
make bootstrap              # イメージ構築 + bundle install + db:prepare + seed + pnpm install
make up                     # 全サービス起動（HMR有効）
```

## よく使う Make タスク
- `make up` / `make up-build` : 立ち上げ（必要に応じて再ビルド）
- `make down` : 停止・孤立コンテナ掃除
- `make logs` : 全サービスのログを追う
- `make console` : Rails コンソール
- `make db-shell` : psql シェル
- `make lint-backend` / `make lint-frontend` : RuboCop / ESLint
- `make test` : Rails test
- `make seed` : Seed データ投入

## アクセス先
- フロント: http://localhost:5173
- Rails API: http://localhost:3000
- Sidekiq Web UI: http://localhost:3000/sidekiq （Basic 認証は `.env` 参照）
- MinIO Console: http://localhost:9001 （`.env` の MINIO_* 参照）

## 環境変数メモ
- Rails: `DATABASE_URL`, `REDIS_URL`, `ACTIVE_STORAGE_SERVICE`, `MINIO_*`, `APP_HOST`, `FRONTEND_HOST`, `OPENAI_API_KEY`(未設定ならモック)
- Frontend: `VITE_API_BASE_URL`, `VITE_APP_HOST`
- Seed ユーザー（デフォルト）: `demo@aidia.local / password12345!`（`.env` で変更可）

## トラブルシュート
- Docker デーモンに繋がらない: Docker Desktop/WSL2 を起動して `docker info` が通るか確認。
- psych などのネイティブ拡張ビルド失敗: `Dockerfile.web` に必要な dev パッケージ（libyaml 等）を含めているので、再ビルド後に再実行。

## ローカル実行（非 Docker）
```bash
cd apps/api && bundle install && bin/rails db:prepare
cd apps/web && pnpm install && pnpm dev
```
