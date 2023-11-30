resource "random_password" "password" {
  length = 16
  special = true
  override_special = "!#$%&*()-_=+[]{}<>:?"
}

data "azurerm_key_vault" "key_vault" {
  name = "front-shop-kv"
  resource_group_name = var.rg_name
}

resource "azurerm_key_vault_secret" "db-pass" {
  name = "db-pass"
  key_vault_id = data.azurerm_key_vault.key_vault.id
  value = random_password.password.result
}

resource "azurerm_mysql_server" "db_server" {
  name                = "front-shop-mysqlserver"
  location            = var.rg_location
  resource_group_name = var.rg_name

  administrator_login          = var.adm_login
  administrator_login_password = random_password.password.result

  sku_name   = "B_Gen5_2"
  storage_mb = 5120
  version    = "5.7"

  auto_grow_enabled                 = true
  backup_retention_days             = 7
  geo_redundant_backup_enabled      = false
  infrastructure_encryption_enabled = false
  public_network_access_enabled     = true
  ssl_enforcement_enabled           = true
  ssl_minimal_tls_version_enforced  = "TLS1_2"
}

resource "azurerm_mssql_database" "mysql_db" {
  name                  = "frontshop-db"
  server_id             = azurerm_mysql_server.db_server.id
  collation             = "SQL_Latin1_General_CP1_CI_AS"
  license_type          = "BasePrice"
  max_size_gb           = 30
  storage_account_type  = "Local"
  sku_name              = "S0"
  zone_redundant        = false
}

resource "azurerm_mssql_virtual_network_rule" "db_rule" {
  name = "mssql-rule"
  server_id = azurerm_mysql_server.db_server.id
  subnet_id = var.subnet_id
}

output "db_pass" {
  value = random_password.password.result
}