# Simple NGINX on EC2 (Terraform, AWS)

This repo provisions a **single Amazon EC2 instance** running **NGINX** with **plain HTTP** (no SSL) for a quick demo.  
It also sets up a **Terraform remote backend on S3** with **versioning + S3 Object Lock**.

## What you get

- 1× VPC (10.42.0.0/16), 1× public subnet (10.42.1.0/24), IGW, route to internet
- 1× Security Group allowing **HTTP (80)** (and optional **SSH (22)** if you enable it)
- 1× EC2 instance (Amazon Linux 2023) with NGINX installed via `user_data`
- Terraform **remote state** on S3 with:
  - **Versioning** + **S3 Object Lock** (default retention 1 day in **GOVERNANCE** mode)


> S3 **Object Lock** protects objects from deletion/overwrite for a retention window, but is **not** used by Terraform for concurrency locks. This project configures **both** for safety.

---

## Prerequisites

- Terraform **1.5+**
- AWS credentials configured (e.g., via `aws configure`)
- IAM permissions to create S3, DynamoDB, EC2, VPC, etc.

---

## Quick start

### 0) Clone/extract this folder
```
terraform-nginx-ec2/
└── Terraform-files/                 
```

### 1) Backend Configurartion

> Create an S3 bucket with a unique name.
> Enable object versioning to get versioned state file
> Update the name of the bucket in your backend.tf file
> You can use terraform to provision this bucket as well but for simplicity it's provisioned manually. You can import it in your terraform files using import block in later stages

### 2) Configure the main stack to use that backend
> Open the terminal and move to the project directory
cd ../Terraform-files


Then initialize with the backend configuration:

```bash
terraform init 
```

### 3) Apply the demo stack

> Run terraform-plan and look for all the resources that are being created
> If everything looks good run terraform-apply

When it finishes, look for the `http_url` output, e.g.
```
Outputs:

http_url = "http://54.210.x.y/"
```

Open that URL in a browser to see the NGINX welcome page.

---

## Tearing it down

Destroy the stack first, then the backend.

```bash
# In Terraform-files/
terraform destroy -auto-approve -var "region=us-east-1"


```

> Delete the S3 bucket after emptying it  

---


## Notes 

- **AMI**: Uses latest Amazon Linux 2023 (x86_64) automatically.
- **Public IP**: Subnet is configured with `map_public_ip_on_launch = true`.
- **Security**: This is a **demo**. For production, lock SSH to your IP, add SSM, use private subnets + ALB, etc.
- **HTTPS**: Intentionally **not** configured. You could later put an ALB or CloudFront + ACM in front without touching the instance.
- **Inbound-ports**: I have utilized my public IP for inbound access. You can change it to your desired IP in security.tf or you can uncomment the 0.0.0.0/0 line to access it from anywhere 

