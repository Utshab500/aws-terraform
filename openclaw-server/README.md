# OpenClaw Server

Terraform configuration to launch an Ubuntu Spot EC2 instance in us-east-1.

## Configuration

- Region: us-east-1
- OS: Ubuntu 22.04 LTS (latest official AMI)
- Instance type: t2.medium
- Storage: 20 GB root volume
- Purchase option: Spot

## Usage

From `openclaw-server/dev`:

```bash
terraform init
terraform plan
terraform apply
```
