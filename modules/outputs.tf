output "argocd_initial_admin_password" {
  value     = data.external.argocd_password.result.password
  sensitive = true
}

output "argocd_server_url" {
  value = "http://localhost:8080"
}
