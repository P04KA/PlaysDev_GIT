output "db_fqdn" {
  value       = yandex_mdb_postgresql_cluster.this.host[0].fqdn
  description = "Database FQDN"
}