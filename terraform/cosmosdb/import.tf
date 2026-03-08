# Import CosmosDB Account
import {
  to = azurerm_cosmosdb_account.cosmostatsukonievent
  id = "/subscriptions/ba29533e-1e4c-43a8-898a-a5815e9b577b/resourceGroups/tatsukoni-test-v3/providers/Microsoft.DocumentDB/databaseAccounts/cosmostatsukonievent"
}

# Import CosmosDB SQL Database - TestEvent
import {
  to = azurerm_cosmosdb_sql_database.test_event
  id = "/subscriptions/ba29533e-1e4c-43a8-898a-a5815e9b577b/resourceGroups/tatsukoni-test-v3/providers/Microsoft.DocumentDB/databaseAccounts/cosmostatsukonievent/sqlDatabases/TestEvent"
}

# Import CosmosDB SQL Container - AppEvents
import {
  to = azurerm_cosmosdb_sql_container.app_events
  id = "/subscriptions/ba29533e-1e4c-43a8-898a-a5815e9b577b/resourceGroups/tatsukoni-test-v3/providers/Microsoft.DocumentDB/databaseAccounts/cosmostatsukonievent/sqlDatabases/TestEvent/containers/AppEvents"
}

# Import CosmosDB SQL Container - FrontEvents
import {
  to = azurerm_cosmosdb_sql_container.front_events
  id = "/subscriptions/ba29533e-1e4c-43a8-898a-a5815e9b577b/resourceGroups/tatsukoni-test-v3/providers/Microsoft.DocumentDB/databaseAccounts/cosmostatsukonievent/sqlDatabases/TestEvent/containers/FrontEvents"
}
