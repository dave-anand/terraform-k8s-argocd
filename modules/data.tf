data "external" "argocd_password" {
  program = ["bash", "${path.module}/get_argocd_password.sh"]

  query = {
    trigger = timestamp()
  }
}
