# Create namespace
resource "kubernetes_namespace" "argocd" {
  metadata {
    name = var.argocd_namespace
  }
}

# Install Argo CD via Helm
resource "helm_release" "argocd" {
  name       = "argocd"
  namespace  = var.argocd_namespace
  repository = "https://argoproj.github.io/argo-helm"
  chart      = "argo-cd"
  version    = var.argocd_chart_version

#   values = [
#     <<EOF
# server:
#   service:
#     type: NodePort # No `LoadBalancer` support in Minikube
# EOF
#   ]

  values = [
    yamlencode({
      server = {
        service = {
          type = "ClusterIP" # or NodePort if needed
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


# MiniKube Cleanup: Explicitly Delete the CRDs (even if Helm keeps them)
resource "time_sleep" "wait_helm_cleanup" {
  destroy_duration = "15s"
  depends_on       = [helm_release.argocd]
}

