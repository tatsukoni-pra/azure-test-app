# CosmosDB Seed Data

このディレクトリには、CosmosDB に初期データを投入するためのスクリプトとデータファイルが含まれています。

## ディレクトリ構成

```
seed/
├── seed-data/              # 初期データ
│   ├── app_events/         # AppEventsコンテナ用データ
│   │   ├── data1.json
│   │   └── data2.json
│   └── front_events/       # FrontEventsコンテナ用データ
│       ├── data1.json
│       └── data2.json
├── scripts/                # データ投入スクリプト
│   └── seed-cosmosdb.ts
├── package.json
├── tsconfig.json
└── README.md
```

## ローカル実行

### 前提条件

- Node.js 20.x 以上
- CosmosDB アカウントの接続情報（エンドポイントとキー）

### 実行手順

1. 依存関係のインストール

```bash
cd seed
npm install
```

2. TypeScript のビルド

```bash
npm run build
```

3. 環境変数の設定

```bash
export COSMOS_ENDPOINT="https://your-account.documents.azure.com:443/"
export COSMOS_KEY="your-primary-key"
export DATABASE_NAME="TestEvent"  # オプション（デフォルト: TestEvent）
```

4. データ投入の実行

```bash
npm run seed
```

## GitHub Actions での実行

GitHub Actions ワークフローを手動実行することで、データを投入できます。

1. GitHub リポジトリの「Actions」タブに移動
2. 「Seed CosmosDB Data」ワークフローを選択
3. 「Run workflow」ボタンをクリック
4. 実行

## データファイルの追加

新しいデータを追加する場合は、対応するコンテナのディレクトリに JSON ファイルを追加してください。

例: AppEvents に新しいデータを追加

```bash
cd seed/seed-data/app_events
cat > data3.json << EOF
{
  "id": "new_data_001",
  "description": "New sample data"
}
EOF
```

## 新しいコンテナのデータを追加

1. `seed-data/` 配下に新しいディレクトリを作成（例: `user_profiles`）
2. ディレクトリ名はスネークケース（`_` 区切り）で記述
3. スクリプトが自動的にキャメルケースに変換（`user_profiles` → `UserProfiles`）
4. ディレクトリ内に JSON ファイルを配置

## 注意事項

- すべての JSON ファイルには `id` フィールドが必須です
- データ投入は upsert で実行されるため、同じ `id` のデータは上書きされます
- 冪等性が保証されているため、複数回実行しても安全です
