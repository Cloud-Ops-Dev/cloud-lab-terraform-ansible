# Cloud Lab: Terraform + Ansible for AWS EC2 and IBM VSI

## Overview
This lab demonstrates provisioning an AWS EC2 instance (t2.micro, Ubuntu 22.04 in us-east-1) and an IBM Virtual Server Instance (VSI) (cx2-2x4, Ubuntu 22.04 in us-south-1) using Terraform, then configuring them with Ansible to install Python 3.10 and pip for customer AI projects (e.g., `llama.cpp`, `whisper-venv`). Built as part of a customer solution test on a Hyprland (Ubuntu 24.04.2 LTS) Laptop with [VSCodium](images/VScodium.png).

## Prerequisites
- AWS account with credentials configured (`~/.aws/credentials`).
- IBM Cloud account with API key (stored securely, e.g., `/Documents/Security/apikey.json`).
- SSH key pair (`~/.ssh/id_ed25519` and `.pub`).
- Terraform, Ansible installed.
- Clone the repo: `git clone https://github.com/Cloud-Ops-Dev/cloud-lab-terraform-ansible.git`.

## Setup
1. Navigate to `terraform/`:
    cd terraform
    terraform init
    export TF_VAR_ibm_api_key="<your-ibm-api-key>"  # Load from secure file if preferred
    terraform plan
    terraform apply</your-ibm-api-key>
2. Note public IPs from the output (EC2: `public_ip`, VSI: floating IP after association).
3. Update `ansible/inventory.ini` with IPs:
    [all]
    ec2_instance ansible_host=<ec2-public-ip> ansible_user=ubuntu
    vsi_instance ansible_host=<vsi-public-ip> ansible_user=ubuntu</vsi-public-ip></ec2-public-ip>
4. Run Ansible from `ansible/`:
    source ../venv/bin/activate
    ssh-add ~/.ssh/id_ed25519
    [ansible-playbook -i inventory.ini configure.yml](images/AnsibleRun2.png)
    

## What Has Been Done
- **Terraform Provisioning**:
- [AWS EC2: t2.micro, Ubuntu 22.04 AMI, SSH key `lab-key`](images/TerraformStateShowEc2.png).
- [IBM VSI: cx2-2x4, Ubuntu 22.04 minimal, VPC/subnet setup, SSH key `lab-key](images/ConfirmVSI.png)`, floating IP for public access.
- **Ansible Configuration**:
- Added deadsnakes PPA for Python 3.10.
- Installed Python 3.10 and pip on both instances.
- **Git Workflow**: Repo structured with `terraform/`, `ansible/`, `docs/`, committed and pushed to GitHub.

## Challenges and Solutions
- **SSH Key Imports**: Region mismatches (AWS us-east-1 vs. us-east-2) and name vs. ID resolution in IBM Cloud—fixed by using key ID in `main.tf`.
- **API Key Authentication**: Multiple keys tried; resolved by regenerating and verifying with `ibmcloud login --apikey <key> -r us-south`.
- **Floating IP for VSI**: Private IP only; added floating IP and associated with network interface using IBM CLI.
- **Security Group/ACL Rules**: SSH timed out due to default blocks—added inbound rules for port 22 from a trusted IP.
- **Ansible Linting**: `ansible-lint` crashes fixed by version pinning and virtual env tweaks.
- **Virtual Env Prompt Stacking**: zsh config caused `(venv)` multiplication—fixed by deactivating and resetting terminal.
- **pip3.10 installation**: The error "Cannot uninstall pip X.X.X, RECORD file not found. Because the system-installed pip lacks a RECORD file that pip uses to track installed files. Installed in a virtual environment to resolve (venv)

This lab demonstrates the importance of region consistency, key management, and security configurations in multi-cloud setups.

## Usage in Production
- Use for AI labs (e.g., run `llama.cpp` on instances).
- Scale with Terraform variables for different regions or instances.
- Secure API keys in env vars or secrets management (e.g., AWS Secrets Manager).

## Cleanup
Destroy resources:
- Terraform Destroy
- Delete floating IP: ibmcloud is floating-ip-delete r006-db610f58-79f6-xxx-xxx-xxxxxxxxxxxx

## Future Labs
Coming soon: IBM Watson automation possibly using Cisco hardware simulators for end-to-end network + AI workflows.