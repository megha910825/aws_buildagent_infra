## What We Are Building
A production-style AWS infrastructure that automatically provisions a self-hosted CI build agent the same agent you built in Project 1 but now running on real AWS infrastructure, created entirely by Terraform code.

### The Four Building Blocks

- VPC Private Network

Inside the VPC you create two subnets:

Public Subnet  → has internet access
                 → this is where NAT gateway sits

Private Subnet → NO direct internet access
                 → this is where your build agent sits
                 → it can reach out to internet via NAT
                 → but nobody from internet can reach IN
Why private subnet for the agent?

A build agent doesn't need to be publicly accessible. It reaches out to GitHub/Azure to pick up jobs nobody needs to reach into it. Putting it in a private subnet is the secure, production-correct approach.

- Security Group  Firewall
Controls what traffic is allowed IN and OUT
of EC2 instance

Inbound:
└── SSH port 22 — only from my IP (for debugging)

Outbound:
└── Everything allowed
    (agent needs to reach GitHub, pull packages etc)

- IAM Role Agent's Identity

EC2 instance needs AWS permissions to:
├── Write logs to CloudWatch
├── Pull images from ECR (later)
└── Read secrets (later)

IAM Role = an identity for EC2 wears
IAM Policy = the list of what that identity can do

EC2 + IAM Role = agent can talk to AWS services
                 without any hardcoded credentials
- EC2 Instance  Build Agent Server
The actual virtual machine where your agent runs

On first boot it runs a startup script (user_data)
that:
├── Installs Docker, Python, Ansible
├── Runs your Project 1 bootstrap.sh
└── Registers agent with GitHub Actions

After that it sits and waits for CI jobs
### Workflow

How It All Connects
GitHub Actions triggers a job
        ↓
Job looks for a self-hosted runner
        ↓
Your EC2 instance (in private subnet) picks it up
        ↓
EC2 runs the job inside a Docker container
(using the images built in Project 1)
        ↓
Job completes, result reported back to GitHub
        ↓
EC2 sits idle, waiting for next job

### Why Modules?

we created 4 modules vpc, ec2, iam, security-group.

Without modules:          With modules:
─────────────────         ─────────────
one giant main.tf         each piece is separate
300+ lines                reusable anywhere
hard to read              easy to test individually
hard to reuse             easy to add dev/staging/prod
Think of modules like the Ansible roles from Project 1 same principle, different tool.

### What Terraform State Does Here
First time when we run terraform apply:
→ Creates VPC, subnets, EC2, IAM, security group
→ Saves a record of everything in S3 bucket
   "I created vpc-xxx, ec2-yyy, role-zzz"

Next time when we change something and run apply:
→ Reads state from S3
→ Compares current code vs what exists
→ Only changes what's different
→ Nothing else gets touched

### The Big Picture

Terraform code
        ↓
terraform apply
        ↓
AWS creates:
├── VPC
│   ├── Public subnet  → NAT Gateway
│   └── Private subnet → EC2 Build Agent
├── Security Group     → firewall rules
├── IAM Role           → agent's AWS permissions
└── EC2 Instance       → runs Project 1 agent
        ↓
State saved to S3 bucket
        ↓
GitHub Actions CI/CD pipeline
keeps infrastructure up to date
on every code change
