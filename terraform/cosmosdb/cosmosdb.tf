# CosmosDB Account
resource "azurerm_cosmosdb_account" "cosmostatsukonievent" {
  name                       = "cosmostatsukonievent"
  location                   = "japaneast"
  resource_group_name        = "tatsukoni-test-v3"
  default_identity_type      = "FirstPartyIdentity"
  offer_type                 = "Standard"
  kind                       = "GlobalDocumentDB"
  network_acl_bypass_ids     = []
  free_tier_enabled          = false
  automatic_failover_enabled = true

  dynamic "capabilities" {
    for_each = local.is_serverless == "true" ? [1] : []
    content {
      name = "EnableServerless"
    }
  }

  consistency_policy {
    consistency_level       = "Session"
    max_interval_in_seconds = 5
    max_staleness_prefix    = 100
  }

  geo_location {
    location          = "japaneast"
    failover_priority = 0
  }

  tags = {
    defaultExperience         = "Core (SQL)"
    "hidden-workload-type"    = "Development/Testing"
    "hidden-cosmos-mmspecial" = ""
  }
}

# CosmosDB SQL Database
resource "azurerm_cosmosdb_sql_database" "test_event" {
  name                = "TestEvent"
  resource_group_name = azurerm_cosmosdb_account.cosmostatsukonievent.resource_group_name
  account_name        = azurerm_cosmosdb_account.cosmostatsukonievent.name

  dynamic "autoscale_settings" {
    for_each = local.is_serverless != "true" ? [1] : []
    content {
      max_throughput = 1000
    }
  }
}

# CosmosDB SQL Container - AppEvents
resource "azurerm_cosmosdb_sql_container" "app_events" {
  name                  = "AppEvents"
  resource_group_name   = azurerm_cosmosdb_account.cosmostatsukonievent.resource_group_name
  account_name          = azurerm_cosmosdb_account.cosmostatsukonievent.name
  database_name         = azurerm_cosmosdb_sql_database.test_event.name
  partition_key_paths   = ["/id"]
  partition_key_version = 2

  conflict_resolution_policy {
    mode                     = "LastWriterWins"
    conflict_resolution_path = "/_ts"
  }

  dynamic "autoscale_settings" {
    for_each = local.is_serverless != "true" ? [1] : []
    content {
      max_throughput = 1000
    }
  }
}

# CosmosDB SQL Container - FrontEvents
resource "azurerm_cosmosdb_sql_container" "front_events" {
  name                  = "FrontEvents"
  resource_group_name   = azurerm_cosmosdb_account.cosmostatsukonievent.resource_group_name
  account_name          = azurerm_cosmosdb_account.cosmostatsukonievent.name
  database_name         = azurerm_cosmosdb_sql_database.test_event.name
  partition_key_paths   = ["/id"]
  partition_key_version = 2

  conflict_resolution_policy {
    mode                     = "LastWriterWins"
    conflict_resolution_path = "/_ts"
  }

  dynamic "autoscale_settings" {
    for_each = local.is_serverless != "true" ? [1] : []
    content {
      max_throughput = 1000
    }
  }
}
