# In KodeKloud CloudShell
git clone https://github.com/megha910825/aws_buildagent_infra.git
cd aws-buildagent-infra
terraform init

wget -O - https://apt.releases.hashicorp.com/gpg | sudo gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/hashicorp.list
sudo apt update && sudo apt install terraform
terraform version

aws --version                 # is the CLI installed?
aws configure                 # enter the playground's Access Key, Secret Key, region us-east-1
aws sts get-caller-identity   # should show the kk_labs_user account
aws s3 ls | grep terraform-state
