import { CosmosClient } from "@azure/cosmos";
import * as fs from "fs/promises";
import * as path from "path";

async function main() {
  const endpoint = process.env.COSMOS_ENDPOINT;
  const key = process.env.COSMOS_KEY;
  const databaseName = process.env.DATABASE_NAME || "TestEvent";

  if (!endpoint || !key) {
    throw new Error("COSMOS_ENDPOINT and COSMOS_KEY are required");
  }

  console.log(`Database: ${databaseName}`);
  console.log(`Endpoint: ${endpoint}`);

  const client = new CosmosClient({ endpoint, key });
  const database = client.database(databaseName);
  const seedDataDir = path.join(__dirname, "../../seed-data");
  const dirs = await fs.readdir(seedDataDir, { withFileTypes: true });

  for (const dir of dirs) {
    if (!dir.isDirectory()) continue;

    const containerName = dir.name
      .split("_")
      .map((w) => w.charAt(0).toUpperCase() + w.slice(1))
      .join("");

    const containerPath = path.join(seedDataDir, dir.name);
    const files = await fs.readdir(containerPath);
    const jsonFiles = files.filter((f) => f.endsWith(".json"));

    console.log(`\n[${containerName}]`);
    for (const file of jsonFiles) {
      const data = JSON.parse(
        await fs.readFile(path.join(containerPath, file), "utf-8")
      );
      await database.container(containerName).items.upsert(data);
      console.log(`  ✓ ${data.id}`);
    }
  }

  console.log("\nCompleted");
}

main().catch((error) => {
  console.error("Error:", error.message);
  process.exit(1);
});
