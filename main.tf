module "argocd" {
  source              = "./modules"
  kubeconfig_path     = var.kubeconfig_path
  argocd_namespace    = var.argocd_namespace
  argocd_chart_version = var.argocd_chart_version
}
