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

* **environments/** – Environment-specific Terraform configurations (dev, staging, prod).
* **modules/** – Reusable Terraform modules for AWS resources.

## Modules

* **vpc** – Creates VPC, subnets, and networking components.
* **security-groups** – Manages security group rules.
* **ec2** – Launches EC2 instances and related configurations.
* **alb** – Application Load Balancer setup.
* **rds** – RDS database resources.
* **s3** – S3 buckets and policies.
* **iam** – IAM roles, policies, and permissions.

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
terraform apply
```

## Requirements

* Terraform >= 1.x
* AWS CLI configured
* Appropriate AWS permissions
