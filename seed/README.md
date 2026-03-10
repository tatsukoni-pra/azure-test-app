# CosmosDB Seed Data

このディレクトリには、CosmosDB に初期データを投入するためのスクリプトとデータファイルが含まれています。

## ディレクトリ構成

```
seed/
├── seed-data/
│   ├── TestEvent/               # データベース名
│   │   ├── AppEvents/           # コンテナ名
│   │   │   ├── data1.json
│   │   │   └── data2.json
│   │   └── FrontEvents/         # コンテナ名
│   │       ├── data1.json
│   │       └── data2.json
│   └── TestEventV2/             # データベース名
│       ├── BackendEvents/       # コンテナ名
│       │   ├── data1.json
│       │   └── data2.json
│       └── InfraEvents/         # コンテナ名
│           ├── data1.json
│           └── data2.json
├── scripts/
│   └── seed-cosmosdb.ts
├── package.json
├── tsconfig.json
└── README.md
```

**ディレクトリ構造のルール：**
- 1階層目: データベース名（CosmosDB のデータベース名と完全一致）
- 2階層目: コンテナ名（CosmosDB のコンテナ名と完全一致）
- 3階層目: JSONデータファイル

**重要:** ディレクトリ名は CosmosDB の実際のデータベース名・コンテナ名と完全に一致させる必要があります。

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

例: TestEvent データベースの AppEvents コンテナに新しいデータを追加

```bash
cd seed/seed-data/TestEvent/AppEvents
cat > data3.json << EOF
{
  "id": "new_data_001",
  "description": "New sample data"
}
EOF
```

## 新しいデータベース・コンテナの追加

### 新しいコンテナを追加（既存データベース内）

```bash
# 例: TestEvent データベースに UserProfiles コンテナを追加
mkdir -p seed/seed-data/TestEvent/UserProfiles
echo '{"id": "user001", "name": "Sample User"}' > seed/seed-data/TestEvent/UserProfiles/data1.json
```

### 新しいデータベースを追加

```bash
# 例: Production データベースと Events コンテナを追加
mkdir -p seed/seed-data/Production/Events
echo '{"id": "event001", "type": "system"}' > seed/seed-data/Production/Events/data1.json
```

**重要:** ディレクトリ名は、CosmosDB の実際のデータベース名・コンテナ名と完全に一致させてください。
- データベース名が `TestEvent` の場合 → `TestEvent/` ディレクトリを作成
- コンテナ名が `AppEvents` の場合 → `AppEvents/` ディレクトリを作成

## 注意事項

- すべての JSON ファイルには `id` フィールドが必須です
- データ投入は upsert で実行されるため、同じ `id` のデータは上書きされます
- 冪等性が保証されているため、複数回実行しても安全です
