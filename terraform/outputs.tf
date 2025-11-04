
output "resource_group_name" {
  description = "Name of the resource group"
  value       = azurerm_resource_group.main.name
}

output "resource_group_location" {
  description = "Location of the resource group"
  value       = azurerm_resource_group.main.location
}

output "resource_group_id" {
  description = "ID of the resource group"
  value       = azurerm_resource_group.main.id
}

output "workspace" {
  description = "Current Terraform workspace"
  value       = terraform.workspace
}

output "vnet_name" {
  description = "Name of the Virtual Network"
  value       = azurerm_virtual_network.main.name
}

output "vnet_id" {
  description = "ID of the Virtual Network"
  value       = azurerm_virtual_network.main.id
}

output "frontend_subnet_id" {
  description = "ID of the frontend subnet"
  value       = azurerm_subnet.frontend.id
}

output "backend_subnet_id" {
  description = "ID of the backend subnet"
  value       = azurerm_subnet.backend.id
}

output "database_subnet_id" {
  description = "ID of the database subnet"
  value       = azurerm_subnet.database.id
}

output "bastion_subnet_id" {
  description = "ID of the bastion subnet"
  value       = azurerm_subnet.bastion.id
}

output "frontend_lb_public_ip" {
  description = "Public IP of the frontend load balancer"
  value       = azurerm_public_ip.frontend_lb.ip_address
}

output "frontend_lb_id" {
  description = "ID of the frontend load balancer"
  value       = azurerm_lb.frontend.id
}

output "backend_lb_id" {
  description = "ID of the backend load balancer"
  value       = azurerm_lb.backend.id
}

output "sql_server_name" {
  description = "Name of the SQL server"
  value       = azurerm_mssql_server.main.name
}

output "sql_server_fqdn" {
  description = "Fully qualified domain name of the SQL server"
  value       = azurerm_mssql_server.main.fully_qualified_domain_name
}

output "database_name" {
  description = "Name of the database"
  value       = azurerm_mssql_database.main.name
}

output "sql_connection_string" {
  description = "SQL Database connection string (password hidden)"
  value       = "Server=tcp:${azurerm_mssql_server.main.fully_qualified_domain_name},1433;Database=${azurerm_mssql_database.main.name};User ID=${var.db_admin_username};Password=***;Encrypt=yes;TrustServerCertificate=no;"
  sensitive   = true
}

output "bastion_public_ip" {
  description = "Public IP of the Bastion host"
  value       = azurerm_public_ip.bastion.ip_address
}

output "bastion_ssh_command" {
  description = "SSH command to connect to Bastion"
  value       = "ssh ${var.admin_username}@${azurerm_public_ip.bastion.ip_address}"
}

output "frontend_private_ip" {
  description = "Private IP of the Frontend VM"
  value       = azurerm_network_interface.frontend.private_ip_address
}

output "backend_private_ip" {
  description = "Private IP of the Backend VM"
  value       = azurerm_network_interface.backend.private_ip_address
}
