# AWS Infrastructure with Terraform

**Infrastructure as Code | AWS Networking | EC2 | IAM | Linux | Nginx**

## Project Overview

This project demonstrates the provisioning and management of AWS infrastructure using Terraform. It includes a custom VPC network, public and private subnets across two Availability Zones, network routing, security controls, and an EC2 instance hosting a simple Nginx website.

The infrastructure is defined through code rather than manually provisioned through the AWS Management Console.

This hands-on project is part of my Cloud Engineering portfolio and was developed to strengthen my practical knowledge of AWS, Infrastructure as Code, networking, Linux administration, and troubleshooting.

## Architecture

The environment is deployed in **AWS US East (N. Virginia), `us-east-1`**.

| Component | Implementation |
|---|---|
| VPC | Custom VPC with CIDR `10.0.0.0/16` |
| Public subnets | Two `/24` subnets across separate Availability Zones |
| Private subnets | Two `/24` subnets across separate Availability Zones |
| Internet Gateway | Internet connectivity for public subnet routing |
| Route tables | Separate public and private routing configurations |
| EC2 | One `t3.micro` running Amazon Linux 2023 |
| Web server | Nginx installed automatically through EC2 user data |
| Security Groups | Inbound HTTP (80), restricted outbound HTTPS (443), no inbound SSH |
| IAM | EC2 instance role with Systems Manager permissions |
| Storage | Encrypted 8 GiB gp3 root EBS volume |
| Terraform state | Local state, excluded from Git version control |

### Network Design

| Subnet | CIDR | Availability Zone |
|---|---|---|
| Public A | `10.0.1.0/24` | `us-east-1a` |
| Public B | `10.0.2.0/24` | `us-east-1b` |
| Private A | `10.0.11.0/24` | `us-east-1a` |
| Private B | `10.0.12.0/24` | `us-east-1b` |

The public subnets are associated with a route table containing a default IPv4 route (`0.0.0.0/0`) to the Internet Gateway.

The private subnets use a separate route table with local VPC routing only. No NAT Gateway has been deployed.

The EC2 web server runs in Public Subnet A. The second Availability Zone provides network capacity for potential future expansion, but the application itself currently runs on only one instance and is not highly available.

## Technologies Used

- **Amazon VPC:** Virtual networking and subnet configuration
- **Amazon EC2:** Linux compute infrastructure
- **AWS IAM:** Instance roles and managed permissions
- **AWS Systems Manager:** Secure instance administration using Session Manager
- **Amazon EBS:** Encrypted block storage
- **Terraform:** Infrastructure provisioning and lifecycle management
- **Amazon Linux 2023:** EC2 operating system
- **Nginx:** HTTP web server
- **Git and GitHub:** Source control and project documentation
- **Visual Studio Code:** Local development environment

## Security Considerations

Several security practices were applied:

- **Network separation:** Public and private subnets use separate route tables.
- **Controlled inbound access:** The web server Security Group allows HTTP on TCP port 80 without opening SSH port 22.
- **IAM roles:** EC2 uses an instance profile instead of hardcoded AWS access keys.
- **Secure metadata access:** IMDSv2 is required.
- **Storage encryption:** The EC2 root EBS volume is encrypted.
- **State protection:** Terraform state, local provider downloads, and sensitive local files are excluded from Git.
- **Systems Manager:** Session Manager provides an administrative access method without inbound SSH.

**Security limitation:** The demonstration website uses unencrypted HTTP and is not intended for production or sensitive data. HTTPS, enhanced monitoring, and additional availability controls would be appropriate for a production deployment.

## Repository Structure

| File | Purpose |
|---|---|
| `providers.tf` | Terraform AWS provider configuration |
| `main.tf` | VPC configuration |
| `subnets.tf` | Public and private subnet definitions |
| `networking.tf` | Internet Gateway and public routing |
| `private-routing.tf` | Private route table and associations |
| `security-groups.tf` | Web server Security Group and rules |
| `iam.tf` | EC2 IAM role, policy attachment, and instance profile |
| `ec2.tf` | EC2 instance configuration and outputs |
| `user-data.sh` | Nginx installation and website initialization |
| `.gitignore` | Excluded local and potentially sensitive files |
| `.terraform.lock.hcl` | Locked provider dependencies |

## Deployment Guide

### Prerequisites

- An AWS account with appropriate permissions
- Terraform installed locally
- AWS CLI configured with valid credentials or an authorized IAM Identity Center session
- Git, if cloning the repository

### 1. Clone the repository

`git clone https://github.com/josuegironestrada/aws-terraform-infrastructure.git`

`cd aws-terraform-infrastructure`

### 2. Initialize Terraform

`terraform init`

Downloads the required provider dependencies and initializes the working directory.

### 3. Validate the configuration

`terraform fmt -check`

`terraform validate`

Checks formatting and validates the Terraform configuration.

### 4. Review the deployment plan

`terraform plan`

Displays proposed infrastructure changes before deployment. Review the resources, target account, Region, and potential costs.

### 5. Deploy the infrastructure

`terraform apply`

Review the execution plan and approve only the intended changes.

### 6. Access the demonstration website

`terraform output web_server_url`

Open the resulting HTTP URL in a browser after instance initialization completes.

### 7. Verify the deployment

Confirm that the EC2 instance is running, the Nginx website responds, and the expected network and security resources exist in AWS.

## Troubleshooting Experience

During the initial EC2 deployment, Terraform successfully created the instance, but the website returned `ERR_CONNECTION_REFUSED`.

Investigation using AWS Systems Manager Session Manager revealed that Nginx had not been installed.

The troubleshooting process included:

1. Checking the Nginx service with `systemctl`.
2. Testing localhost connectivity with `curl`.
3. Inspecting cloud-init status and initialization logs.
4. Identifying a shell execution-format error in the user-data script.
5. Examining the script's raw bytes and discovering a leading newline before `#!/bin/bash`.
6. Correcting the script and replacing the EC2 instance through Terraform.
7. Verifying that the Nginx website was successfully served.

This exercise demonstrated the difference between successful infrastructure provisioning and successful application initialization.

## Key Lessons Learned

- Provisioning AWS resources using declarative Terraform configurations.
- Understanding resource dependencies and Terraform state.
- Designing VPC networks with public and private subnets.
- Configuring Internet Gateways, route tables, and subnet associations.
- Applying Security Groups and IAM roles.
- Automating Linux instance initialization through user data.
- Diagnosing cloud-init failures and application connectivity issues.
- Using Git and GitHub to version infrastructure code.
- Reviewing Terraform execution plans before applying potentially destructive changes.

## Cost Management and Cleanup

Deploying this project can incur AWS charges, including EC2 compute, EBS storage, public IPv4 addresses, and applicable data transfer.

Review estimated costs, AWS Free Tier eligibility, and available credits before deployment.

To remove all resources managed by this Terraform configuration:

`terraform plan -destroy`

`terraform destroy`

**Warning:** These commands apply to the entire Terraform-managed project. Review the plan carefully before confirming destruction.

The local Terraform state file must be preserved while managing deployed resources. Deleting the state file does not delete AWS infrastructure.

## Future Improvements

- Parameterize the configuration using Terraform input variables.
- Consolidate reusable outputs and standardize resource tagging.
- Add an AWS architecture diagram.
- Add automated Terraform validation through GitHub Actions.
- Explore remote Terraform state storage with appropriate access controls.
- Implement HTTPS and evaluate a highly available application architecture.

---

**Project type:** Personal hands-on Cloud Engineering learning project.

**Repository:** [aws-terraform-infrastructure](https://github.com/josuegironestrada/aws-terraform-infrastructure)
