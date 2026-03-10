import { CosmosClient } from "@azure/cosmos";
import * as fs from "fs/promises";
import * as path from "path";

async function main() {
  const endpoint = process.env.COSMOS_ENDPOINT;
  const key = process.env.COSMOS_KEY;

  if (!endpoint || !key) {
    throw new Error("COSMOS_ENDPOINT and COSMOS_KEY are required");
  }

  console.log(`Endpoint: ${endpoint}\n`);

  const client = new CosmosClient({ endpoint, key });
  const seedDataDir = path.join(__dirname, "../../seed-data");
  const dbDirs = await fs.readdir(seedDataDir, { withFileTypes: true });

  for (const dbDir of dbDirs) {
    if (!dbDir.isDirectory()) continue;

    const databaseName = dbDir.name;
    console.log(`[${databaseName}]`);

    const database = client.database(databaseName);
    const dbPath = path.join(seedDataDir, dbDir.name);
    const containerDirs = await fs.readdir(dbPath, { withFileTypes: true });

    for (const containerDir of containerDirs) {
      if (!containerDir.isDirectory()) continue;

      const containerName = containerDir.name;
      const containerPath = path.join(dbPath, containerDir.name);
      const files = await fs.readdir(containerPath);
      const jsonFiles = files.filter((f) => f.endsWith(".json"));

      console.log(`  [${containerName}]`);
      for (const file of jsonFiles) {
        const data = JSON.parse(
          await fs.readFile(path.join(containerPath, file), "utf-8")
        );
        await database.container(containerName).items.upsert(data);
        console.log(`    ✓ ${data.id}`);
      }
    }
    console.log();
  }

  console.log("Completed");
}

main().catch((error) => {
  console.error("Error:", error.message);
  process.exit(1);
});
