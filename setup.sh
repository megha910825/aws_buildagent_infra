curl -fsSL https://releases.hashicorp.com/terraform/1.7.5/terraform_1.7.5_linux_amd64.zip -o /tmp/terraform.zip
mkdir -p /tmp/terraform-install
unzip -o /tmp/terraform.zip -d /tmp/terraform-install
sudo install /tmp/terraform-install/terraform /usr/local/bin/terraform
terraform version
aws sts get-caller-identity
ls -l ./*.tf
cat providers.tf
