# terraform-rdsAutomation

# AWS RDS MySQL Automation Using Terraform

## Overview
This project provisions a private Amazon RDS MySQL database on AWS using Terraform. It automates the creation of the database subnet group, security group, and RDS instance with a simple and reusable configuration.

## Architecture
- **Amazon RDS:** MySQL 8.4 database using `db.t3.micro`.
- **DB Subnet Group:** Uses subnets from the default VPC.
- **Security Group:** Allows MySQL traffic (port 3306) only from within the VPC.
- **Terraform:** Manages AWS infrastructure through Infrastructure as Code.

## Configuration
The project uses separate Terraform files:
- `provider.tf` – AWS provider configuration.
- `variables.tf` – Configurable region, naming, environment, and database credentials.
- `main.tf` – RDS instance and networking resources.
- `outputs.tf` – Database endpoint and database name.

## Deployment

```bash
export TF_VAR_db_password='YourStrongPassword'

terraform init
terraform fmt
terraform validate
terraform plan
terraform apply
```

## Security & Cost
The RDS instance is private and not publicly accessible. Database credentials are supplied through a sensitive Terraform variable. Multi-AZ is disabled to keep lab costs lower.

**Note:** This configuration is intended for learning and lab environments. Review backup, deletion protection, and final snapshot settings before production use.
