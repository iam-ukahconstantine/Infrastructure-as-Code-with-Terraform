# Infrastructure as Code with Terraform

This repository demonstrates the use of modular Terraform to provision and manage AWS infrastructure, showcasing practical implementations of Infrastructure as Code (IaC) principles.

## Overview

The project includes configurations for deploying:

- **Three-Tier AWS Architecture**: A modular setup encompassing a VPC, public and private subnets, security groups, EC2 instances, and an RDS database.

- **Amazon EKS Cluster**: An Elastic Kubernetes Service cluster configured for container orchestration, complete with networking and IAM roles.

Each component is defined using HashiCorp Configuration Language (HCL), promoting readability and maintainability.

## Prerequisites

Before deploying the infrastructure, ensure you have:

- [Terraform](https://www.terraform.io/downloads.html) installed

- An AWS account with appropriate permissions

- AWS CLI configured with your credentials

## Getting Started

1. **Clone the Repository**:

   ```bash
   git clone https://github.com/iam-ukahconstantine/Infrastructure-as-Code-with-Terraform.git
   cd Infrastructure-as-Code-with-Terraform
   ```


2. **Navigate to the Desired Project**:

   ```bash
   cd 3_tier_AWS_architectural_deployment
   # or
   cd EKS_cluster_deployment
   ```


3. **Initialize Terraform**:

   ```bash
   terraform init
   ```


4. **Review the Execution Plan**:

   ```bash
   terraform plan
   ```


5. **Apply the Configuration**:

   ```bash
   terraform apply
   ```


   Confirm the action when prompted.

## Project Structure


```plaintext
Infrastructure-as-Code-with-Terraform/
├── 3_tier_AWS_architectural_deployment/
│   ├── main.tf
│   ├── variables.tf
│   └── outputs.tf
└── EKS_cluster_deployment/
    ├── main.tf
    ├── variables.tf
    └── outputs.tf
```


- **main.tf**: Defines the primary infrastructure resources.

- **variables.tf**: Declares input variables for customization.

- **outputs.tf**: Specifies the outputs to display after deployment.

## Best Practices

- **State Management**: Consider using remote backends like AWS S3 with state locking via DynamoDB to manage Terraform state files securely.

- **Modularization**: Break down configurations into reusable modules for better organization and scalability.

- **Version Control**: Pin provider versions to prevent unexpected changes.

## Contributing

Contributions are welcome! Feel free to fork the repository and submit pull requests for enhancements or bug fixes.
