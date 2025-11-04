# MoviesTerra Infrastructure

Cloud infrastructure automation for the MoviesTerra application using Terraform, Ansible, and Azure.

## 📋 Project Overview

This project demonstrates DevOps best practices by deploying a full-stack movie review application on Azure cloud infrastructure. The infrastructure is defined as code using Terraform and configured using Ansible.

### Application Components
- **Frontend**: React-based movie review UI
- **Backend**: Node.js REST API
- **Database**: Azure SQL Database / MySQL
- **Infrastructure**: Azure (VNet, Load Balancers, VMs, NSGs)

## 🏗️ Architecture

```
Internet
   ↓
[Frontend Load Balancer] (Public: 4.155.29.153)
   ↓
[Frontend VM] (10.0.1.4) - Movie Analyst UI
   ↓
[Backend Load Balancer] (Internal)
   ↓
[Backend VM] (10.0.2.5) - Movie Analyst API
   ↓
[Azure SQL Database] - Movie Database

[Bastion Host] (4.154.240.40) - SSH Access & Ansible Controller
```

### Network Architecture
- **VNet**: `10.0.0.0/16` (West US 2)
- **Subnets**:
  - Frontend: `10.0.1.0/24` (Public)
  - Backend: `10.0.2.0/24` (Private)
  - Database: `10.0.3.0/24` (Private)
  - Bastion: `10.0.254.0/27` (Management)

## 🚀 Quick Start

### Prerequisites
- [Terraform](https://www.terraform.io/downloads) ~> 1.13.0
- [Azure CLI](https://docs.microsoft.com/en-us/cli/azure/install-azure-cli)
- SSH key pair
- Azure subscription with active credits

### 1. Clone Repository
```bash
git clone https://github.com/ylopezs/moviesterra-infra.git
cd moviesterra-infra
```

### 2. Configure Azure Authentication
```bash
az login
az account set --subscription "YOUR_SUBSCRIPTION_ID"
```

### 3. Set Up SSH Key
```bash
# Generate SSH key (if needed)
ssh-keygen -t rsa -b 4096 -f ~/.ssh/moviesterra_key -N ""

# Update variables.tf with your public key
cat ~/.ssh/moviesterra_key.pub
```

### 4. Initialize Terraform
```bash
cd terraform
terraform init
```

### 5. Create Workspace
```bash
terraform workspace new qa
terraform workspace select qa
```

### 6. Deploy Infrastructure
```bash
# Set database password
export TF_VAR_db_admin_password="YourStrongPassword123!"

# Review plan
terraform plan -var-file="environments/qa/terraform.tfvars"

# Deploy
terraform apply -var-file="environments/qa/terraform.tfvars"
```

### 7. Access Infrastructure
```bash
# Get Bastion IP
terraform output bastion_public_ip

# Connect with SSH agent forwarding
eval $(ssh-agent -s)
ssh-add ~/.ssh/moviesterra_key
ssh -A azureuser@<BASTION_IP>
```

## 📁 Repository Structure

```
moviesterra-infra/
├── README.md                 # This file
├── .gitignore               # Git ignore rules
├── terraform/               # Infrastructure as Code
│   ├── backend.tf          # Terraform backend configuration
│   ├── main.tf             # Main infrastructure resources
│   ├── variables.tf        # Variable definitions
│   ├── outputs.tf          # Output values
│   └── environments/       # Environment-specific configs
│       ├── qa/
│       │   └── terraform.tfvars
│       └── prod/
│           └── terraform.tfvars
├── ansible/                 # Configuration Management
│   ├── inventory.ini       # Ansible inventory
│   └── playbooks/          # Ansible playbooks
│       ├── deploy-frontend.yml
│       ├── deploy-backend.yml
│       └── setup-database.yml
├── scripts/                 # Utility scripts
│   └── setup-bastion.sh    # Bastion configuration script
└── docs/                    # Documentation
    ├── SSH-Guide.md        # SSH access guide
    └── Architecture.md     # Architecture documentation
```

## 🔧 Infrastructure Components

### Networking
- **Virtual Network**: Isolated network environment
- **Subnets**: Segmented network for security
- **NSGs**: Network security groups with firewall rules
- **Load Balancers**: Traffic distribution (Standard SKU)

### Compute
- **3x VMs**: Ubuntu 22.04 LTS, Standard_B1s (Free tier)
  - Bastion: Management and Ansible controller
  - Frontend: Web application server
  - Backend: API server

### Database
- **Azure SQL Database**: Serverless, Free tier
  - SKU: GP_S_Gen5_1
  - Storage: 32 GB
  - Auto-pause: 60 minutes

### Security
- SSH key-based authentication (no passwords)
- NSG rules for controlled access
- Private subnets for backend and database
- Bastion host for secure SSH access

## 🔐 Security Best Practices

- ✅ SSH agent forwarding (no private keys on servers)
- ✅ Network segmentation (public/private subnets)
- ✅ NSG rules (least privilege access)
- ✅ No hard-coded credentials
- ✅ Environment variables for secrets
- ✅ Infrastructure as Code (version controlled)

## 📊 Cost Optimization

This infrastructure uses **Azure Free Tier** resources:
- **VMs**: B1s instances (750 hours/month free for 12 months)
- **SQL Database**: Free tier (100K vCore seconds/month forever)
- **Networking**: VNet, NSGs, subnets (always free)
- **Load Balancer**: Standard SKU (~$20/month - paid)
- **Storage**: Minimal usage (<$1/month)

**Estimated monthly cost**: ~$20-25 (mostly Load Balancer)

## 🛠️ Management Commands

### Terraform
```bash
# Plan changes
terraform plan -var-file="environments/qa/terraform.tfvars"

# Apply changes
terraform apply -var-file="environments/qa/terraform.tfvars"

# Destroy infrastructure
terraform destroy -var-file="environments/qa/terraform.tfvars"

# Show outputs
terraform output

# List resources
terraform state list
```

### Workspaces
```bash
# List workspaces
terraform workspace list

# Create new workspace
terraform workspace new prod

# Switch workspace
terraform workspace select qa
```

### SSH Access
```bash
# Start SSH agent
eval $(ssh-agent -s)
ssh-add ~/.ssh/moviesterra_key

# Connect to Bastion
ssh -A azureuser@<BASTION_IP>

# From Bastion to Frontend
ssh azureuser@10.0.1.4

# From Bastion to Backend
ssh azureuser@10.0.2.5
```

## 📝 Environment Variables

Required environment variables for deployment:

```bash
# Terraform
export TF_VAR_db_admin_password="YourStrongPassword"

# Application (set on VMs)
export DB_HOST="sql-moviesterra-qa.database.windows.net"
export DB_USER="dbadmin"
export DB_PASS="YourPassword"
export DB_NAME="moviesdb"
export PORT="3000"
```

## 🧪 Testing

### Infrastructure Tests
```bash
# Validate Terraform
terraform validate

# Format Terraform code
terraform fmt -recursive

# Check SSH connectivity
ansible all -i ansible/inventory.ini -m ping
```

### Application Tests
```bash
# Test Backend API
curl http://10.0.2.5:3000/

# Test Frontend
curl http://10.0.1.4:80/
```

## 📚 Documentation

- [SSH Access Guide](docs/SSH-Guide.md) - Detailed SSH setup and troubleshooting
- [Architecture Documentation](docs/Architecture.md) - Detailed architecture overview
- [Terraform Best Practices](https://www.terraform.io/docs/cloud/guides/recommended-practices/index.html)
- [Ansible Best Practices](https://docs.ansible.com/ansible/latest/user_guide/playbooks_best_practices.html)

## 🔄 CI/CD Pipeline (Future)

Planned improvements:
- [ ] GitHub Actions for Terraform
- [ ] Automated testing
- [ ] Infrastructure validation
- [ ] Automated deployments
- [ ] Monitoring and alerting

## 🐛 Troubleshooting

### Common Issues

**Issue**: `Permission denied (publickey)` when SSH to VMs
**Solution**: Ensure SSH agent forwarding is enabled (`ssh -A`)

**Issue**: Terraform state lock error
**Solution**: Check if another process is running or manually unlock

**Issue**: Resource provisioning failures
**Solution**: Check Azure quotas and regional availability

See [SSH Guide](docs/SSH-Guide.md) for more troubleshooting tips.

## 🤝 Contributing

This is an educational project for learning DevOps practices. Contributions are welcome!

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/improvement`)
3. Commit changes (`git commit -am 'Add new feature'`)
4. Push to branch (`git push origin feature/improvement`)
5. Create Pull Request

## 📄 License

This project is licensed under the MIT License - see LICENSE file for details.

## 👤 Author

**Alberto Lopez**
- GitHub: [@ylopezs](https://github.com/ylopezs)

## 🙏 Acknowledgments

- [Endava DevOps Ramp-Up](https://github.com/aljoveza/devops-rampup) - Original application
- Azure Documentation
- Terraform Documentation
- Ansible Documentation

---

**Note**: This infrastructure is designed for learning and exam purposes. For production use, additional security hardening, monitoring, and high availability configurations are recommended.