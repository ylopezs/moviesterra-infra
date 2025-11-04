
variable "project_name" {
  description = "Project name used for resource naming"
  type        = string
}

variable "environment" {
  description = "Environment name (qa, prod, etc.)"
  type        = string
}

variable "location" {
  description = "Azure region"
  type        = string
  default     = "eastus"
}

variable "tags" {
  description = "Tags to apply to resources"
  type        = map(string)
  default     = {}
}

# Network Configuration
variable "vnet_address_space" {
  description = "Address space for VNet"
  type        = string
  default     = "10.0.0.0/16"
}

variable "frontend_subnet_prefix" {
  description = "Address prefix for frontend subnet"
  type        = string
  default     = "10.0.1.0/24"
}

variable "backend_subnet_prefix" {
  description = "Address prefix for backend subnet"
  type        = string
  default     = "10.0.2.0/24"
}

variable "database_subnet_prefix" {
  description = "Address prefix for database subnet"
  type        = string
  default     = "10.0.3.0/24"
}

variable "bastion_subnet_prefix" {
  description = "Address prefix for bastion subnet"
  type        = string
  default     = "10.0.254.0/27"
}

# Database Configuration
variable "db_admin_username" {
  description = "Database administrator username"
  type        = string
  sensitive   = true
  default     = "dbadmin"
}

variable "db_admin_password" {
  description = "Database administrator password"
  type        = string
  sensitive   = true
}

variable "database_name" {
  description = "Name of the database to create"
  type        = string
  default     = "moviesdb"
}

# VM Configuration
variable "admin_username" {
  description = "Admin username for VMs"
  type        = string
  default     = "azureuser"
}

variable "ssh_public_key" {
  description = "SSH public key for VM access"
  type        = string
  default     = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDF50DwGTeWKZ0c1EPLuTFGhQGRD3hEC6fFI3cYs1A5PquWZQruPiiESQAxxoA96Dy196Jlmn9qeZ0U5pt5pxm54MS/KQxoxH8RmFnlAozT2H2+KQpIK9Vq1gDIzJwqVmc0QUw1H12sqb/IQEFO9zlhHQ3AFuiMs4J13ebiBi4T4BGeGIY84T1BVKtVDgHtiXJmOziUAY6lNt3/Dt0bkp8+iQuehCRreoNkRubs/9LRGKWgt+RE9SDiipj7TnH5BpIfdzhcWTGlq4h8mPD56Ay3Ss3PsXvElNFPbT3qlY9BiLPxBsBrdkeFUf8MrAzPH6dtjrn1gdfmdme516jGOmbL09tKPDE7D91zUtDYWVmNwO0ullwsugyt7Ki8C/rlUafCbkaGMeaeQbaSqtuGGRcdekcDEZxq47/7L1+EpCBalR0osYtKvn+QqhETWomwJVl7pGWlVYQV7TmUUnsq1Z7XsnYAMmUGBktUV5rR7rql9d/GR+U27ygV4gmg2YxuPxec7Op6sxvcjYiSRbM3epn0xCFy4q/hqRJ423zLsw+ow2OT1dpUy0npypNv2f83AI/xV/X9dTYYpsUZTojgCUslZaGM50UAOEUzoIrYSaNBOtKgT4CdMC/kABwfRBrzs12c4DVT2LuaN17lR20B542PGAhFtK8aXwrJqxKHCdXsuw== alberto@alberto"
}