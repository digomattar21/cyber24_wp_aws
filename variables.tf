variable "db_user" {
  description = "The database user for WordPress"
  type        = string
}

variable "db_password" {
  description = "The password for the WordPress database user"
  type        = string
  sensitive   = true
}
