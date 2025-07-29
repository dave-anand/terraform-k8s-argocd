# Install Argo CD via Helm
resource "helm_release" "argocd" {
  name       = "argocd"
  namespace  = var.argocd_namespace
  repository = "https://argoproj.github.io/argo-helm"
  chart      = "argo-cd"
  version    = var.argocd_chart_version

  values = [
    yamlencode({
      server = {
        service = {
          type = "ClusterIP" # or NodePort if needed with Minikube; no `LoadBalancer` support in Minikube
          portHttp = 80
          portHttps = 443
        }
        insecure = true            # disables TLS inside the pod
        extraArgs = ["--insecure"] # optional: sets Argo CD server to serve HTTP only
      }
    })
  ]
  depends_on = [
    kubernetes_namespace.argocd
  ]
}
