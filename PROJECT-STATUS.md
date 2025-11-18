# MoviesTerra Infrastructure - Project Status

**Last Updated**: 2024-10-29  
**Project**: Cloud Infrastructure for Movie Analyst Application  
**GitHub**: https://github.com/ylopezs/moviesterra-infra  
**Cloud Provider**: Azure (West US 2)

---

## 🎯 Current Status: INFRASTRUCTURE DEPLOYED - READY FOR APPLICATION DEPLOYMENT

---

## ✅ Completed Tasks

### 1. Infrastructure Setup (Terraform)
- ✅ Remote state backend configured (local backend for now)
- ✅ VNet created: `10.0.0.0/16` in West US 2
- ✅ 4 Subnets with NSGs:
  - Frontend: `10.0.1.0/24` (public)
  - Backend: `10.0.2.0/24` (private)
  - Database: `10.0.3.0/24` (private)
  - Bastion: `10.0.254.0/27` (management)
- ✅ 2 Load Balancers (Standard SKU):
  - Frontend LB (public)
  - Backend LB (internal)
- ✅ 3 VMs deployed (Ubuntu 22.04, B1s):
  - Bastion: Public IP for SSH access
  - Frontend VM: Behind frontend LB
  - Backend VM: Behind backend LB
- ✅ Azure SQL Database (Free tier, serverless)
- ✅ Network Security Groups configured
- ✅ Service endpoints enabled for SQL

### 2. Access & Security
- ✅ SSH keys configured
- ✅ SSH agent forwarding working
- ✅ Bastion host accessible
- ✅ Can SSH from Bastion to Frontend/Backend VMs

### 3. Configuration Management
- ✅ Ansible installed on Bastion
- ✅ Ansible inventory configured
- ✅ Connectivity tested (ping successful to all VMs)

### 4. Documentation & Repository
- ✅ GitHub repository created: ylopezs/moviesterra-infra
- ✅ Comprehensive README.md
- ✅ .gitignore configured
- ✅ Basic project structure

---

## 🔄 Current Infrastructure Details

### Resource Group
- **Name**: `rg-moviesterra-qa`
- **Location**: `westus2`
- **Workspace**: `qa`

### Networking
```
VNet: vnet-moviesterra-qa (10.0.0.0/16)
├── Frontend Subnet: 10.0.1.0/24
├── Backend Subnet: 10.0.2.0/24
├── Database Subnet: 10.0.3.0/24
└── Bastion Subnet: 10.0.254.0/27
```

### Virtual Machines
| VM | Role | IP Address | Access |
|----|------|------------|--------|
| vm-bastion-qa | Management & Ansible | Public: 4.154.240.40<br>Private: 10.0.254.x | SSH from internet |
| vm-frontend-qa | Web UI | Private: 10.0.1.4 | Via Bastion, Behind LB |
| vm-backend-qa | API Server | Private: 10.0.2.5 | Via Bastion, Behind LB |

### Load Balancers
- **Frontend LB**: Public IP `4.155.29.153` → Port 80 → Frontend VM
- **Backend LB**: Internal `10.0.2.x` → Port 3000 → Backend VM

### Database
- **Type**: Azure SQL Database (SQL Server)
- **Server**: `sql-moviesterra-qa.database.windows.net`
- **Database**: `moviesdb`
- **SKU**: GP_S_Gen5_1 (Free tier, serverless)
- **Storage**: 32 GB
- **Admin User**: `dbadmin`

---

## 📋 Next Steps (In Order)

### Immediate: Backend Code Modification for Azure SQL

**DECISION MADE**: Modify backend to use Azure SQL Database (Option 1)
- Change npm package from `mysql` to `mssql`
- Update connection configuration in backend code
- Adapt SQL queries if needed (should be minimal)
- Azure SQL already deployed and working

**Why this approach**:
- ✅ Use managed Azure SQL (already deployed)
- ✅ Learn real cloud database integration
- ✅ Better for production scenarios
- ✅ Demonstrates code adaptation skills
- ⚠️ Requires code modification

**Tasks**:
1. Fork/copy application code to repository
2. Modify `movie-analyst-api/package.json` - change mysql to mssql
3. Modify `movie-analyst-api/server.js` - update connection code
4. Modify `movie-analyst-api/seeds.js` - update for mssql
5. Test locally or deploy to Backend VM
6. Create database schema and seed data

### Application Deployment

**Source Code**: https://github.com/aljoveza/devops-rampup
- `movie-analyst-api/` - Node.js backend API
- `movie-analyst-ui/` - Frontend web UI

**Backend Requirements**:
- Node.js runtime
- npm packages (express, **mssql** - modified from mysql)
- Environment variables:
  - `DB_HOST` (sql-moviesterra-qa.database.windows.net)
  - `DB_USER` (dbadmin)
  - `DB_PASS` (your password)
  - `DB_NAME` (moviesdb)
  - `PORT` (3000)

**Code Modifications Required**:
- `package.json`: Change `mysql` to `mssql`
- `server.js`: Update connection code for mssql
- `seeds.js`: Update connection code for mssql

**Frontend Requirements**:
- TBD (need to check package.json)
- Likely Node.js/React
- Needs backend API endpoint

**Tasks**:
1. Clone application repo on Bastion
2. Create Ansible playbook for backend deployment
3. Create Ansible playbook for frontend deployment
4. Configure environment variables
5. Start services
6. Test application end-to-end

### Monitoring & Finalization
1. Set up Azure Monitor
2. Create architecture diagram
3. Document deployment process
4. Test disaster recovery (destroy/recreate)

---

## 🔑 Important Information

### SSH Access
```bash
# Start SSH agent and add key
eval $(ssh-agent -s)
ssh-add ~/.ssh/moviesterra_key

# Connect to Bastion with forwarding
ssh -A azureuser@4.154.240.40

# From Bastion to Frontend
ssh azureuser@10.0.1.4

# From Bastion to Backend
ssh azureuser@10.0.2.5
```

### Terraform Commands
```bash
# Working directory: ~/moviesterra-infra/terraform
# Workspace: qa

# Apply infrastructure
terraform apply -var-file="environments/qa/terraform.tfvars"

# Destroy infrastructure
terraform destroy -var-file="environments/qa/terraform.tfvars"

# View outputs
terraform output

# List resources
terraform state list
```

### Ansible Commands
```bash
# On Bastion: ~/ansible

# Test connectivity
ansible all -i inventory.ini -m ping

# Run playbook
ansible-playbook -i inventory.ini playbooks/PLAYBOOK_NAME.yml
```

---

## 📁 File Locations

### Local Machine
```
~/moviesterra-infra/
├── terraform/
│   ├── backend.tf
│   ├── main.tf
│   ├── variables.tf
│   ├── outputs.tf
│   └── environments/qa/terraform.tfvars
├── scripts/
│   └── setup-bastion.sh
└── .gitignore

~/.ssh/
└── moviesterra_key (private key)
└── moviesterra_key.pub (public key)
```

### Bastion Host
```
/home/azureuser/ansible/
├── inventory.ini
├── playbooks/ (to be created)
└── devops-rampup/ (application repo - cloned)
    ├── movie-analyst-api/
    └── movie-analyst-ui/
```

---

## 🔧 Technical Details

### Terraform Configuration
- **Version**: ~> 1.13.0
- **Provider**: azurerm ~> 3.0
- **Backend**: Local (terraform.tfstate in project directory)
- **State**: Per workspace (qa, prod)

### Application Stack
- **Backend**: Node.js + Express + MySQL
- **Frontend**: TBD (likely React/Node.js)
- **Database Schema**:
  - `publications` (name, avatar)
  - `reviewers` (name, publication, avatar)
  - `movies` (title, release_year, score, reviewer, publication)

### Network Security
- Frontend subnet: Open to internet (HTTP/HTTPS), SSH from Bastion
- Backend subnet: Only accessible from Frontend subnet + SSH from Bastion
- Database subnet: Only accessible from Backend + Bastion
- Bastion subnet: SSH from internet only

---

## 🚨 Known Issues & Considerations

### 1. Database Choice
- Application originally uses MySQL
- Deployed Azure SQL (SQL Server) instead
- **Solution**: Modifying backend code to use `mssql` npm package instead of `mysql`
- Requires code changes but provides better cloud integration

### 2. Free Tier Limitations
- Azure SQL free tier had regional restrictions
- Basic Public IPs not available in subscription
- Using Standard SKU Load Balancer (~$20/month cost)

### 3. SSH Key Management
- Using `~/.ssh/moviesterra_key`
- Must use `-A` flag for agent forwarding
- Public key embedded in Terraform variables.tf

### 4. State Management
- Currently using local backend
- For team work, should migrate to Azure Storage backend
- Remote backend resources already exist: `stmoviesstate02eb9e`

---

## 💰 Cost Tracking

### Current Monthly Estimate
- VMs (3x B1s): **FREE** (750 hours/month for 12 months)
- Azure SQL Database: **FREE** (100K vCore seconds/month forever)
- VNet, Subnets, NSGs: **FREE** (always free)
- Standard Load Balancer: **~$20/month** (PAID)
- Storage: **~$1/month**
- **Total**: ~$20-25/month

### Cost Optimization Notes
- After exam, destroy infrastructure to stop charges
- Keep Terraform code to recreate quickly
- Consider Basic Load Balancer if available in future

---

## 📝 Environment Variables Required

### Terraform (during apply)
```bash
export TF_VAR_db_admin_password="YourStrongPassword123!"
```

### Backend Application (to be set on Backend VM)
```bash
export DB_HOST="sql-moviesterra-qa.database.windows.net"
export DB_USER="dbadmin"
export DB_PASS="YourStrongPassword123!"
export DB_NAME="moviesdb"
export PORT="3000"
```

---

## 🎓 Learning Objectives Achieved

- ✅ Infrastructure as Code (Terraform)
- ✅ Cloud networking (VNets, subnets, NSGs)
- ✅ Load balancing and high availability concepts
- ✅ SSH key management and agent forwarding
- ✅ Bastion/jump host architecture
- ✅ Configuration management with Ansible
- ✅ Git workflow and documentation
- ⏳ Application deployment (in progress)
- ⏳ Database management (in progress)
- ⏳ Monitoring and observability (pending)

---

## 📞 Quick Reference

### Key URLs
- GitHub Repo: https://github.com/ylopezs/moviesterra-infra
- Application Source: https://github.com/aljoveza/devops-rampup
- Frontend LB: http://4.155.29.153
- Bastion SSH: azureuser@4.154.240.40

### Key IPs
- Bastion Public: `4.154.240.40`
- Frontend LB Public: `4.155.29.153`
- Frontend VM Private: `10.0.1.4`
- Backend VM Private: `10.0.2.5`

### Key Commands
```bash
# Deploy
cd terraform && terraform apply -var-file="environments/qa/terraform.tfvars"

# SSH
eval $(ssh-agent -s) && ssh-add ~/.ssh/moviesterra_key
ssh -A azureuser@4.154.240.40

# Ansible
cd ~/ansible && ansible all -i inventory.ini -m ping

# Destroy
cd terraform && terraform destroy -var-file="environments/qa/terraform.tfvars"
```

---

## 🔄 Project Timeline

1. ✅ **Day 1**: Infrastructure planning and Terraform setup
2. ✅ **Day 2**: Networking, VMs, and database deployment
3. ✅ **Day 3**: SSH access, Ansible setup, repository creation
4. ⏳ **Day 4**: MySQL installation and application deployment (CURRENT)
5. ⏳ **Day 5**: Testing, monitoring, and documentation finalization

---

**Status**: Ready for MySQL installation and application deployment  
**Next Action**: Create Ansible playbook for MySQL setup on Backend VM  
**Blocker**: None  
**Risk**: None identified