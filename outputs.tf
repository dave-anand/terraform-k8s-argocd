output "argocd_initial_admin_password" {
  value     = module.argocd.argocd_initial_admin_password
  sensitive = true
}

output "argocd_server_url" {
  value = module.argocd.argocd_server_url
}
