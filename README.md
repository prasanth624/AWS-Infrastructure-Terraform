# AWS Infrastructure Terraform

This repository contains Terraform code to provision and manage AWS infrastructure using a modular approach.

## Repository Structure

```

AWS-Infrastructure-Terraform
├── environments
│   ├── dev
│   ├── staging
│   └── prod
│
└── modules
├── alb
├── ec2
│   └── templates
├── iam
│   └── policies
├── rds
├── s3
│   └── policies
├── security-groups
└── vpc

```

## Overview

- **environments/** – Environment-specific Terraform configurations (dev, staging, prod).
- **modules/** – Reusable Terraform modules for AWS resources.

## Modules

- **vpc** – Creates VPC, subnets, and networking components.
- **security-groups** – Manages security group rules.
- **ec2** – Launches EC2 instances and related configurations.
- **alb** – Application Load Balancer setup.
- **rds** – RDS database resources.
- **s3** – S3 buckets and policies.
- **iam** – IAM roles, policies, and permissions.

## Automated CI/CD Pipeline

This repository uses **GitHub Actions** to automate Terraform validation and deployment.

Pipeline behavior:

| Branch | Environment | Action |
|------|------|------|
| `dev` | `environments/dev` | Automatically deploys infrastructure |
| `stage` | `environments/staging` | Automatically deploys infrastructure |
| `main` | `environments/prod` | Runs Terraform plan on Pull Request and requires approval before apply |

### Pipeline Steps

The GitHub Actions workflow performs the following:

1. Checkout repository  
2. Setup Terraform  
3. Configure AWS credentials  
4. Run `terraform init`  
5. Run `terraform validate`  
6. Run `terraform plan`  
7. Deploy infrastructure (`terraform apply`) based on branch rules  

Workflow file location:

```

.github/workflows/terraform.yml

```

## Usage

1. Navigate to the required environment:

```

cd environments/dev

```

2. Initialize Terraform:

```

terraform init

```

3. Plan the infrastructure:

```

terraform plan

```

4. Apply the configuration:

```

terraform apply --auto-approve

```

## Requirements

- Terraform >= 1.x
- AWS CLI configured
- Appropriate AWS permissions
