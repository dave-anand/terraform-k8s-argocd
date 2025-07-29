variable "kubeconfig_path" {
  type        = string
  description = "Path to the kubeconfig file"
}

variable "argocd_namespace" {
  type        = string
  description = "Namespace to deploy Argo CD"
}

variable "argocd_chart_version" {
  type        = string
  description = "Version of the Argo CD Helm chart"
}
