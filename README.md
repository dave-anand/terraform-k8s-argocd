# Argo CD Deployment with Terraform on Minikube

This project automates the installation of [Argo CD](https://argo-cd.readthedocs.io/en/stable/) onto a Minikube Kubernetes cluster using Terraform and Helm. It includes automatic login via the Argo CD CLI and secure retrieval of the initial admin password.

---

## Features

- Installs Argo CD via the official Helm chart (INSECURE / disables TLS; see 'Notes on Security' below)
- Configurable via Terraform variables
- Uses `kubectl port-forward` for local access (Minikube-compatible)
- Retrieves and decodes the Argo CD admin password using a sanitized shell script
- Automates Argo CD CLI login

---

## Prerequisites

Before you begin, ensure the following are installed:

- [Terraform](https://developer.hashicorp.com/terraform/downloads) ≥ 1.3
- [kubectl](https://kubernetes.io/docs/tasks/tools/)
- [Minikube](https://minikube.sigs.k8s.io/docs/start/)
- [Helm](https://helm.sh/)
- [Argo CD CLI](https://argo-cd.readthedocs.io/en/stable/cli_installation/)
- [jq](https://stedolan.github.io/jq/)
- Bash shell with `tr`, `sed`, and `base64`

> Note: This setup assumes you are using Minikube with the Docker driver locally.

---

## File Structure

```bash
.
├── main.tf                        # Terraform resources (namespace, helm_release)
├── providers.tf                   # Terraform provider config and versions
├── variables.tf                   # Input variables
├── outputs.tf                     # Outputs including Argo CD admin password
├── get_argocd_password.sh         # Script to securely extract and sanitize the admin password
├── argocd_login.sh                # CLI login automation script
└── README.md                      # You are here!
```

---

## Usage

### 1. Start Minikube

```bash
minikube start
```

> Make sure your kubectl context points to Minikube:
```bash
# View
kubectl config current-context

# Switch
kubectl config use-context minikube
```

---

### 2. Deploy Argo CD via Terraform

```bash
terraform init
terraform plan
terraform apply
```

Terraform will:
- Install Argo CD using Helm
- Output the decoded admin password (via `external` script)

---

### 3. Access Argo CD UI

Use `kubectl port-forward` to expose the UI locally:

```bash
kubectl port-forward svc/argocd-server -n argocd 8080:80
```

Then open [http://localhost:8080](http://localhost:8080) in your browser.

---

### 4. Retrieve the Admin Password

For the web portal (user `admin`), get the generated password:

```bash
terraform output -raw argocd_initial_admin_password
```

> May need a second `terraform apply` for now...

> With macOS Terminal and `zsh` and similar., igrore trailing `%` for the password.

---

### 5. Log In via CLI

Run:

```bash
./argocd_login.sh
```

This will:
- Fetch the password from Terraform
- Log you into Argo CD using the CLI

> NOTE `--insecure` is required because Argo CD is exposed via HTTP (not HTTPS) in this local Minikube setup.

You can then run:
```bash
argocd app list
```

---

## Notes on Security

- Password is marked as `sensitive` in Terraform
- Shell script sanitizes decoded secret to avoid non-printable or invalid characters
- Session is cached in `~/.argocd/config`
- Installed as `insecure = true` / TLS disabled as currently intended for non-production use and mitigations for minikube.

---

## Troubleshooting

### Argo CD Pods and/or Related Not Ready?
Use:
```bash
kubectl get pods -n argocd
kubectl get all -n argocd
```

### Password Needs Two Terraform Applies
`terraform output -raw argocd_initial_admin_password` (in `argocd_login.sh`) needs 2 Terraform runs, even though nothing is changed on the second run.

### `%` Character in Password?
This is likely a terminal artifact due to a missing newline. It is **not** part of the password.

### ArgoCD Logout
At this time, delete `~/.config/argocd/config` for full reset...

### General Helm Issues
Ensure all is up to date: `helm repo update`

---

## Future Improvements

- Add support for EKS (toggle Minikube vs cloud)
- Auto-bootstrap a GitOps repo and sample app
- Integrate TLS certs and Ingress

---

## Cleanup

To delete the deployment:

```bash
terraform destroy
```

To remove cached Terraform state:

```bash
rm -rf .terraform .terraform.lock.hcl terraform.tfstate*
```

Manual CRD deletion may be needed:

```bash
kubectl get crds | grep argoproj
kubectl delete crd applications.argoproj.io
kubectl delete crd applicationsets.argoproj.io
kubectl delete crd appprojects.argoproj.io
```

---

## 📄 License

MIT License. Use freely, but secure your production credentials accordingly.
