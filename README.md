## Commands to run before building any infra
```bash
terraform version # to check if terraform is installed or not
aws --version # to check if we can work with aws cli or aws cli is installed or not
aws sts get-caller-identity # The get-caller-identity command displays information about the IAM identity used to authenticate the request. The caller is an IAM user.

```
if terraform is not installed, here is the process to install terraform
### command to install terraform
```bash
curl -fsSL https://releases.hashicorp.com/terraform/1.7.5/terraform_1.7.5_linux_amd64.zip -o terraform.zip
unzip terraform.zip
sudo mv terraform /usr/local/bin/
terraform version
```
### command to configure aws region
```bash
aws configure get region
aws configure set region us-east-1
aws configure get region
```

### command to Check existing VPCs
```bash
aws ec2 describe-vpcs --query 'Vpcs[*].{ID:VpcId,CIDR:CidrBlock,Default:IsDefault}' --output table
```
### command to Check available EC2 key pairs & generate one if not exists
```bash
aws ec2 describe-key-pairs --query 'KeyPairs[*].KeyName' --output table
mkdir -p ~/.ssh
# Now create the key pair
aws ec2 create-key-pair     --key-name build-agent-key     --query 'KeyMaterial'     --output text > ~/.ssh/build-agent-key.pem
# Set correct permissions
chmod 400 ~/.ssh/build-agent-key.pem
# Verify
aws ec2 describe-key-pairs --query 'KeyPairs[*].KeyName' --output table
aws s3api create-bucket     --bucket terraform-state-build-agent-471112794818     --region us-east-1
```
### command to enable Enable versioning & encryption
```bash
aws s3api put-bucket-versioning     --bucket terraform-state-build-agent-471112794818     --versioning-configuration Status=Enabled
# Enable encryption
aws s3api put-bucket-encryption     --bucket terraform-state-build-agent-471112794818     --server-side-encryption-configuration '{
"Rules": [{
"ApplyServerSideEncryptionByDefault": {
    "SSEAlgorithm": "AES256"
}
}]
}'
aws s3 ls | grep terraform-state
aws s3api get-bucket-versioning --bucket terraform-state-build-agent-471112794818
aws s3api get-bucket-encryption --bucket terraform-state-build-agent-471112794818
```
