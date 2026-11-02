#!/usr/bin/env bash
set -euo pipefail

TERRAFORM_VERSION="1.7.5"
PROJECT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"

cd "$PROJECT_DIR"

if ! command -v terraform >/dev/null 2>&1; then
  echo "Installing Terraform ${TERRAFORM_VERSION}..."
  tmp_dir="$(mktemp -d)"
  trap 'rm -rf "$tmp_dir"' EXIT

  curl -fsSL \
    "https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_amd64.zip" \
    -o "$tmp_dir/terraform.zip"

  unzip -q "$tmp_dir/terraform.zip" -d "$tmp_dir"
  sudo install "$tmp_dir/terraform" /usr/local/bin/terraform
fi

terraform version

echo "Checking existing AWS credentials..."
aws sts get-caller-identity --query '{Account:Account,Arn:Arn}' --output table

if [[ ! -f providers.tf || ! -f main.tf ]]; then
  echo "Missing root providers.tf or main.tf. Add both before running terraform init." >&2
  exit 1
fi

echo "Initializing Terraform..."
terraform init

echo "Setup complete. Next: terraform validate && terraform plan"
