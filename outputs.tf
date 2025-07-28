# External Data Source: Argo CD Admin Password
data "external" "argocd_password" {
  program = ["bash", "${path.module}/get_argocd_password.sh"]

  query = {
    trigger = timestamp()
  }
}

# Output: Argo CD Initial Admin Password
output "argocd_initial_admin_password" {
  value     = data.external.argocd_password.result.password
  sensitive = true
}
