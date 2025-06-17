# CrowdStrike Falcon Agent Automation

This repository provides a complete automation solution for deploying and managing CrowdStrike Falcon agents on Azure infrastructure using Terraform, Ansible, and GitHub Actions. **This solution uses the official [CrowdStrike Ansible Collection](https://github.com/CrowdStrike/ansible_collection_falcon)** for reliable, tested, and maintained Falcon agent management.

## 🎯 Overview

This solution enables you to:
- **Deploy infrastructure**: Automatically provision Windows and Linux VMs on Azure using Terraform
- **Manage Falcon agents**: Install/uninstall CrowdStrike Falcon agents using official CrowdStrike roles
- **Scale operations**: Target specific servers by IP address with flexible OS selection
- **Maintain security**: Use encrypted secrets and secure connection methods
- **Enterprise-grade**: Built on official CrowdStrike tools with full API integration

## 📁 Repository Structure

```
├── terraform/
│   ├── main.tf              # Main Terraform configuration
│   ├── variables.tf         # Variable definitions
│   ├── outputs.tf           # Output definitions
│   └── terraform.tfvars     # Variable values (create this)
├── ansible/
│   ├── playbook.yml         # Main playbook using CrowdStrike collection
│   ├── requirements.yml     # Ansible collection requirements
│   ├── setup-collections.sh # Collection setup script
│   └── inventory.yml        # Dynamic inventory (auto-generated)
├── .github/
│   └── workflows/
│       └── crowdstrike.yml  # GitHub Actions workflow
├── scripts/
│   └── setup-github-secrets.sh # GitHub secrets helper
└── README.md                # This documentation
```

## 🏗️ Architecture & Components

### **Official CrowdStrike Integration**
This solution leverages the official **CrowdStrike Ansible Collection** (`crowdstrike.falcon`) which provides:

- **🔧 Pre-built Roles**: 
  - `falcon_install` - Automated sensor installation
  - `falcon_configure` - Sensor configuration management  
  - `falcon_uninstall` - Clean sensor removal

- **📡 Official Modules**:
  - `sensor_download` - Download installers via API
  - `falconctl` - Configure sensor settings
  - `falconctl_info` - Query sensor status

- **🚀 Enterprise Features**:
  - FalconPy SDK integration
  - Multi-platform support (Windows, Linux, macOS)
  - API-driven automation
  - Official CrowdStrike support

## 🚀 Quick Start

### Prerequisites

1. **Azure Subscription** with sufficient permissions
2. **Terraform** installed locally
3. **GitHub repository** with Actions enabled
4. **CrowdStrike Falcon** subscription with API access

### Step 1: Deploy Infrastructure with Terraform

1. **Clone this repository**:
   ```bash
   git clone <repository-url>
   cd crowdstrike-falcon-automation
   ```

2. **Configure Azure authentication**:
   ```bash
   az login
   az account set --subscription "your-subscription-id"
   ```

3. **Create terraform.tfvars**:
   ```hcl
   # terraform/terraform.tfvars
   resource_group_name = "rg-crowdstrike-falcon"
   location = "East US"
   prefix = "falcon"
   
   # VM Sizes (cheapest options)
   linux_vm_size = "Standard_B1s"
   windows_vm_size = "Standard_B1ms"
   
   # Admin credentials
   linux_admin_username = "azureuser"
   linux_admin_password = "YourSecurePassword123!"
   windows_admin_username = "azureuser"
   windows_admin_password = "YourSecurePassword123!"
   
   # Tags
   tags = {
     Environment = "Development"
     Project     = "CrowdStrike-Falcon"
     ManagedBy   = "Terraform"
   }
   ```

4. **Deploy infrastructure**:
   ```bash
   cd terraform
   terraform init
   terraform plan
   terraform apply
   ```

5. **Note the output IP addresses**:
   ```bash
   terraform output
   ```

### Step 2: Configure GitHub Secrets

Add the following secrets to your GitHub repository (`Settings` → `Secrets and variables` → `Actions`):

#### Required Secrets:
```
FALCON_CID                 # Your CrowdStrike Customer ID
LINUX_ADMIN_USERNAME       # Linux VM admin username
LINUX_ADMIN_PASSWORD       # Linux VM admin password
WINDOWS_ADMIN_USERNAME      # Windows VM admin username
WINDOWS_ADMIN_PASSWORD      # Windows VM admin password
```

#### Optional Secrets (for API-based automation):
```
FALCON_CLIENT_ID           # CrowdStrike API Client ID
FALCON_CLIENT_SECRET       # CrowdStrike API Client Secret
FALCON_CLOUD              # CrowdStrike Cloud (us-1, us-2, eu-1, us-gov-1)
```

#### Getting CrowdStrike API Credentials:
1. **Log into CrowdStrike Falcon console**
2. **Navigate to** Support → API Clients & Keys
3. **Create API Client** with scopes:
   - `Sensor Download: Read` (for downloading installers)
   - `Hosts: Read, Write` (for host management)
4. **Copy** Client ID and Secret
5. **Note your cloud region**: us-1 (default), us-2, eu-1, or us-gov-1

### Step 3: Run the Automation Workflow

1. **Navigate to GitHub Actions** in your repository
2. **Select** the "CrowdStrike Falcon Agent Management" workflow
3. **Click** "Run workflow"
4. **Configure parameters**:
   - **Action**: `install` or `uninstall`
   - **OS Target**: `windows`, `linux`, or `both`
   - **Target IPs**: Comma-separated list (e.g., `20.30.40.50,40.50.60.70`)

## 🔧 Detailed Configuration

### CrowdStrike Collection Requirements

The official CrowdStrike Ansible Collection requires:
- **Ansible Core**: >= 2.15.0
- **Python**: >= 3.7
- **FalconPy SDK**: >= 1.3.0

### Installation Methods

The collection supports multiple installation methods:
1. **API Method** (Recommended): Automatic download from CrowdStrike
2. **Local File**: Use pre-downloaded installers
3. **Remote URL**: Download from custom repository

### API Scopes Required

When using API credentials, ensure these scopes are enabled:
- **Sensor Download: Read** - Download sensor installers
- **Hosts: Read, Write** - Manage host registration (optional)
- **Installation Tokens: Read** - Use installation tokens (optional)

### Terraform Variables

| Variable | Description | Default | Required |
|----------|-------------|---------|----------|
| `resource_group_name` | Azure resource group name | `rg-crowdstrike-falcon` | No |
| `location` | Azure region | `East US` | No |
| `prefix` | Resource name prefix | `falcon` | No |
| `linux_vm_size` | Linux VM size | `Standard_B1s` | No |
| `windows_vm_size` | Windows VM size | `Standard_B1ms` | No |
| `linux_admin_username` | Linux admin username | `azureuser` | No |
| `linux_admin_password` | Linux admin password | - | Yes |
| `windows_admin_username` | Windows admin username | `azureuser` | No |
| `windows_admin_password` | Windows admin password | - | Yes |

### GitHub Actions Workflow Inputs

| Input | Description | Options | Default |
|-------|-------------|---------|---------|
| `action` | Operation to perform | `install`, `uninstall` | `install` |
| `os_target` | Target operating system | `windows`, `linux`, `both` | `both` |
| `target_ips` | Comma-separated IP addresses | Any valid IPs | Required |

### CrowdStrike Configuration

#### Required Information:
- **Customer ID (CID)**: Found in Falcon console under Support → API Clients & Keys
- **API Credentials** (optional): For automated installer downloads

#### Getting Your CID:
1. Log into CrowdStrike Falcon console
2. Navigate to **Support** → **API Clients & Keys**
3. Copy your **Customer ID (CID)**

## 📋 Usage Examples

### Example 1: Install on Both OS Types
```yaml
Action: install
OS Target: both
Target IPs: 20.30.40.50,40.50.60.70
```

### Example 2: Uninstall from Windows Only
```yaml
Action: uninstall
OS Target: windows
Target IPs: 20.30.40.50
```

### Example 3: Install on Multiple Linux Servers
```yaml
Action: install
OS Target: linux
Target IPs: 10.0.1.10,10.0.1.20,10.0.1.30
```

## 🔒 Security Best Practices

### Credentials Management
- ✅ **Use GitHub Secrets** for all sensitive data
- ✅ **Rotate passwords** regularly
- ✅ **Use strong passwords** with complexity requirements
- ✅ **Limit IP access** via NSG rules to your public IP only

### Network Security
- ✅ **SSH (22)** restricted to your public IP
- ✅ **RDP (3389)** restricted to your public IP
- ✅ **WinRM (5985/5986)** restricted to your public IP
- ✅ **Private subnet** for internal communication

### Agent Security
- ✅ **Encrypted communication** with CrowdStrike cloud
- ✅ **Service validation** before marking installation complete
- ✅ **Clean uninstall** with verification steps

## 🔍 Troubleshooting

### Common Issues

#### 1. **Terraform Authentication Errors**
```bash
# Solution: Re-authenticate with Azure
az login
az account show
```

#### 2. **GitHub Actions Connectivity Issues**
- Check IP addresses are correct
- Verify NSG rules allow your runner's IP
- Ensure VM admin credentials are correct

#### 3. **Ansible Connection Failures**
```yaml
# Linux SSH Issues:
# - Verify SSH is enabled and accessible
# - Check username/password combination
# - Test manual SSH connection

# Windows WinRM Issues:
# - Ensure WinRM is enabled on target
# - Check Windows Firewall settings
# - Verify WinRM configuration
# - Run: winrm quickconfig on Windows hosts
```

#### 4. **CrowdStrike Collection Issues**
```bash
# Verify collection installation
ansible-galaxy collection list | grep crowdstrike

# Reinstall if needed
ansible-galaxy collection install crowdstrike.falcon --force

# Check collection documentation
ansible-doc crowdstrike.falcon.falcon_install
```

#### 5. **CrowdStrike Installation Failures**
- Verify CID format (32-character hex with checksum)
- Check API credentials and scopes
- Ensure sufficient disk space on targets
- Review sensor logs: `/var/log/falcon-sensor.log` (Linux) or Event Viewer (Windows)
- Validate network connectivity to CrowdStrike cloud

### Debugging Steps

#### 1. **Test Infrastructure Connectivity**
```bash
# Test Linux SSH
ssh azureuser@<linux-ip>

# Test Windows RDP
# Use Remote Desktop Connection to <windows-ip>:3389
```

#### 2. **Manual Ansible Testing**
```bash
# Test Linux connection
ansible linux -i inventory.yml -m ping

# Test Windows connection  
ansible windows -i inventory.yml -m win_ping
```

#### 3. **Check Service Status**
```bash
# Linux - Using official collection modules
ansible all -i inventory.yml -m crowdstrike.falcon.falconctl_info

# Windows (PowerShell)
Get-Service -Name "CSFalconService"

# Linux - Direct service check
sudo systemctl status falcon-sensor
```

### **CrowdStrike Collection Examples**

#### **Basic Install with API**
```yaml
- hosts: all
  roles:
    - role: crowdstrike.falcon.falcon_install
      vars:
        falcon_client_id: "{{ falcon_client_id }}"
        falcon_client_secret: "{{ falcon_client_secret }}"
    - role: crowdstrike.falcon.falcon_configure
      vars:
        falcon_tags: "production,web-servers"
```

#### **Install Specific Version**
```yaml
- hosts: all
  roles:
    - role: crowdstrike.falcon.falcon_install
      vars:
        falcon_sensor_version_decrement: 2  # Install N-2 version
```

#### **Windows with Installation Token**
```yaml
- hosts: windows
  roles:
    - role: crowdstrike.falcon.falcon_install
      vars:
        falcon_cid: "{{ falcon_cid }}"
        falcon_windows_install_args: "/norestart ProvToken={{ installation_token }}"
```
```bash
# Linux - Using official collection modules
ansible all -i inventory.yml -m crowdstrike.falcon.falconctl_info

# Windows (PowerShell)
Get-Service -Name "CSFalconService"

# Linux - Direct service check
sudo systemctl status falcon-sensor
```

### **CrowdStrike Collection Examples**

#### **Basic Install with API**
```yaml
- hosts: all
  roles:
    - role: crowdstrike.falcon.falcon_install
      vars:
        falcon_client_id: "{{ falcon_client_id }}"
        falcon_client_secret: "{{ falcon_client_secret }}"
    - role: crowdstrike.falcon.falcon_configure
      vars:
        falcon_tags: "production,web-servers"
```

#### **Install Specific Version**
```yaml
- hosts: all
  roles:
    - role: crowdstrike.falcon.falcon_install
      vars:
        falcon_sensor_version_decrement: 2  # Install N-2 version
```

#### **Windows with Installation Token**
```yaml
- hosts: windows
  roles:
    - role: crowdstrike.falcon.falcon_install
      vars:
        falcon_cid: "{{ falcon_cid }}"
        falcon_windows_install_args: "/norestart ProvToken={{ installation_token }}"
```

## 🔄 Advanced Usage

### Local Development Setup

#### 1. **Install Collections Locally**
```bash
# Run the setup script
cd ansible
chmod +x setup-collections.sh
./setup-collections.sh

# Or install manually
pip install crowdstrike-falconpy
ansible-galaxy collection install crowdstrike.falcon
ansible-galaxy collection install ansible.windows
ansible-galaxy collection install community.windows
```

#### 2. **Test Playbook Locally**
```bash
# Create local inventory
cat > test-inventory.yml << EOF
all:
  children:
    windows:
      hosts:
        test-win:
          ansible_host: 192.168.1.100
          ansible_user: Administrator
          ansible_password: "{{ windows_password }}"
          ansible_connection: winrm
          ansible_winrm_transport: basic
          ansible_winrm_server_cert_validation: ignore
    linux:
      hosts:
        test-linux:
          ansible_host: 192.168.1.101
          ansible_user: azureuser
          ansible_password: "{{ linux_password }}"
          ansible_connection: ssh
EOF

# Test connectivity
ansible all -i test-inventory.yml -m ping

# Run playbook
ansible-playbook -i test-inventory.yml playbook.yml \
  --extra-vars "falcon_action=install falcon_cid=YOUR_CID"
```

### Custom Installer Sources

#### **Using Local Files**
```yaml
- hosts: all
  roles:
    - role: crowdstrike.falcon.falcon_install
      vars:
        falcon_install_method: file
        falcon_sensor_download_path: "/path/to/local/installer"
```

#### **Using Remote URL**
```yaml
- hosts: all
  roles:
    - role: crowdstrike.falcon.falcon_install
      vars:
        falcon_install_method: url
        falcon_sensor_download_url: "https://your-repo.com/falcon-installer.deb"
```

### Multi-Environment Configuration

#### **Environment-Specific Variables**
```yaml
# group_vars/production.yml
falcon_client_id: "{{ vault_prod_falcon_client_id }}"
falcon_client_secret: "{{ vault_prod_falcon_client_secret }}"
falcon_cloud: "us-1"
falcon_tags: "production,{{ ansible_hostname }}"

# group_vars/development.yml
falcon_client_id: "{{ vault_dev_falcon_client_id }}"
falcon_client_secret: "{{ vault_dev_falcon_client_secret }}"
falcon_cloud: "us-2"
falcon_tags: "development,testing"
```

#### **Dynamic Inventory from CrowdStrike**
```yaml
# Use CrowdStrike's dynamic inventory plugin
plugin: crowdstrike.falcon.falcon_hosts
client_id: "{{ falcon_client_id }}"
client_secret: "{{ falcon_client_secret }}"
groups:
  windows: ansible_os_family == "Windows"
  linux: ansible_os_family != "Windows"
  production: "'production' in (tags | default([]))"
```

## 🏢 Enterprise Integration

### CI/CD Pipeline Integration

#### **GitLab CI Example**
```yaml
# .gitlab-ci.yml
stages:
  - validate
  - deploy
  - verify

falcon-deploy:
  stage: deploy
  image: registry.gitlab.com/ansible/creator-base:latest
  script:
    - pip install crowdstrike-falconpy
    - ansible-galaxy collection install crowdstrike.falcon
    - ansible-playbook -i inventory.yml playbook.yml
  only:
    - main
```

#### **Azure DevOps Pipeline**
```yaml
# azure-pipelines.yml
stages:
- stage: Deploy
  jobs:
  - job: FalconDeployment
    pool:
      vmImage: ubuntu-latest
    steps:
    - script: |
        pip install ansible crowdstrike-falconpy
        ansible-galaxy collection install crowdstrike.falcon
      displayName: 'Install dependencies'
    - script: |
        ansible-playbook -i inventory.yml playbook.yml
      displayName: 'Deploy Falcon agents'
```

### Integration with Configuration Management

#### **Ansible Tower/AWX Integration**
```yaml
# Use AWX/Tower job templates
- name: Falcon Management Job Template
  uri:
    url: "https://tower.company.com/api/v2/job_templates/{{ falcon_job_id }}/launch/"
    method: POST
    body_format: json
    body:
      extra_vars:
        falcon_action: "{{ action }}"
        target_hosts: "{{ ansible_limit }}"
```

#### **Terraform Enterprise Integration**
```hcl
# Call Ansible from Terraform
resource "null_resource" "falcon_deployment" {
  triggers = {
    vm_ids = join(",", [
      azurerm_linux_virtual_machine.main.id,
      azurerm_windows_virtual_machine.main.id
    ])
  }

  provisioner "local-exec" {
    command = <<-EOT
      ansible-playbook -i inventory.yml playbook.yml \
        --extra-vars "falcon_action=install"
    EOT
  }

  depends_on = [
    azurerm_linux_virtual_machine.main,
    azurerm_windows_virtual_machine.main
  ]
}
```

### Monitoring and Compliance

#### **Compliance Reporting**
```yaml
# compliance-check.yml
- name: CrowdStrike Compliance Check
  hosts: all
  tasks:
    - name: Get Falcon sensor info
      crowdstrike.falcon.falconctl_info:
      register: falcon_status

    - name: Generate compliance report
      template:
        src: compliance_report.j2
        dest: "/tmp/falcon_compliance_{{ ansible_date_time.epoch }}.json"
      vars:
        compliance_data:
          hostname: "{{ ansible_hostname }}"
          falcon_version: "{{ falcon_status.falconctl_info.version | default('Not installed') }}"
          falcon_cid: "{{ falcon_status.falconctl_info.cid | default('Not configured') }}"
          falcon_aid: "{{ falcon_status.falconctl_info.aid | default('Not registered') }}"
          last_check: "{{ ansible_date_time.iso8601 }}"
```

#### **Health Check Automation**
```yaml
# health-check.yml
- name: Falcon Health Check
  hosts: all
  tasks:
    - name: Check Falcon service status
      service:
        name: "{{ 'CSFalconService' if ansible_os_family == 'Windows' else 'falcon-sensor' }}"
      register: service_status

    - name: Send alerts if service is down
      uri:
        url: "https://monitoring.company.com/api/alerts"
        method: POST
        body_format: json
        body:
          alert: "Falcon service down on {{ inventory_hostname }}"
          severity: "critical"
      when: service_status.status != "started"
```

## 🔐 Security Hardening

### Vault Integration

#### **Ansible Vault for Secrets**
```bash
# Encrypt sensitive variables
ansible-vault create group_vars/all/vault.yml

# Content of vault.yml
vault_falcon_client_id: "your-encrypted-client-id"
vault_falcon_client_secret: "your-encrypted-client-secret"
vault_windows_admin_password: "your-encrypted-password"

# Reference in playbooks
falcon_client_id: "{{ vault_falcon_client_id }}"
```

#### **HashiCorp Vault Integration**
```yaml
- name: Get secrets from HashiCorp Vault
  hashivault_read:
    secret: "secret/crowdstrike"
    key: "client_id"
  register: vault_client_id

- name: Use Vault secrets
  include_role:
    name: crowdstrike.falcon.falcon_install
  vars:
    falcon_client_id: "{{ vault_client_id.value }}"
```

### Network Security

#### **Restricted Network Access**
```hcl
# Additional NSG rules for production
resource "azurerm_network_security_group_rule" "falcon_cloud_outbound" {
  name                        = "AllowFalconCloudOutbound"
  priority                    = 200
  direction                   = "Outbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_ranges     = ["443", "80"]
  source_address_prefix       = "*"
  destination_address_prefix  = "CrowdStrike.FalconCloud"
  resource_group_name         = azurerm_resource_group.main.name
  network_security_group_name = azurerm_network_security_group.linux.name
}
```

#### **Certificate Management**
```yaml
# Use certificates for WinRM
- name: Configure WinRM with certificates
  win_shell: |
    $cert = New-SelfSignedCertificate -DnsName "{{ ansible_host }}" -CertStoreLocation "cert:\LocalMachine\My"
    winrm create winrm/config/Listener?Address=*+Transport=HTTPS "@{Hostname=`"{{ ansible_host }}`";CertificateThumbprint=`"$($cert.Thumbprint)`"}"
```

## 📊 Monitoring and Observability

### Metrics Collection

#### **Falcon Agent Metrics**
```yaml
- name: Collect Falcon metrics
  crowdstrike.falcon.falconctl_info:
  register: falcon_metrics

- name: Send metrics to monitoring system
  uri:
    url: "{{ monitoring_endpoint }}"
    method: POST
    body_format: json
    body:
      metric: "falcon.agent.status"
      value: "{{ 1 if falcon_metrics.falconctl_info.aid else 0 }}"
      tags:
        hostname: "{{ ansible_hostname }}"
        environment: "{{ environment }}"
```

#### **Custom Dashboards**
```yaml
# Grafana dashboard configuration
- name: Deploy Grafana dashboard
  uri:
    url: "{{ grafana_url }}/api/dashboards/db"
    method: POST
    headers:
      Authorization: "Bearer {{ grafana_token }}"
    body_format: json
    body:
      dashboard:
        title: "CrowdStrike Falcon Status"
        panels:
          - title: "Agent Status"
            type: "stat"
            targets:
              - expr: 'falcon_agent_status{environment="{{ environment }}"}'
```

## 🚀 Performance Optimization

### Parallel Execution

#### **Optimized Playbook Settings**
```yaml
# ansible.cfg
[defaults]
host_key_checking = False
gathering = smart
fact_caching = memory
fact_caching_timeout = 86400
forks = 50
strategy = free

[ssh_connection]
pipelining = True
ssh_args = -o ControlMaster=auto -o ControlPersist=60s
```

#### **Batch Processing**
```yaml
- name: Install Falcon in batches
  include_role:
    name: crowdstrike.falcon.falcon_install
  vars:
    ansible_limit: "{{ ansible_play_hosts[:10] }}"  # Process 10 hosts at a time
  run_once: true
  loop: "{{ range(0, ansible_play_hosts|length, 10) | list }}"
```

### Resource Optimization

#### **Conditional Installation**
```yaml
- name: Check if Falcon is already installed
  crowdstrike.falcon.falconctl_info:
  register: falcon_check
  ignore_errors: yes

- name: Install only if not present
  include_role:
    name: crowdstrike.falcon.falcon_install
  when: falcon_check.failed or not falcon_check.falconctl_info.aid
```

## 🧪 Testing and Validation

### Automated Testing

#### **Molecule Testing**
```yaml
# molecule/default/molecule.yml
dependency:
  name: galaxy
  options:
    requirements-file: requirements.yml
driver:
  name: docker
platforms:
  - name: ubuntu
    image: ubuntu:20.04
    pre_build_image: true
provisioner:
  name: ansible
  inventory:
    host_vars:
      ubuntu:
        falcon_client_id: "{{ lookup('env', 'FALCON_CLIENT_ID') }}"
        falcon_client_secret: "{{ lookup('env', 'FALCON_CLIENT_SECRET') }}"
verifier:
  name: ansible
```

#### **Test Playbook**
```yaml
# tests/test_falcon_installation.yml
- name: Test Falcon Installation
  hosts: all
  tasks:
    - name: Verify Falcon service is running
      service:
        name: "{{ 'CSFalconService' if ansible_os_family == 'Windows' else 'falcon-sensor' }}"
        state: started
      register: service_check

    - name: Verify Falcon configuration
      crowdstrike.falcon.falconctl_info:
      register: falcon_info

    - name: Assert Falcon is properly configured
      assert:
        that:
          - service_check is not failed
          - falcon_info.falconctl_info.cid is defined
          - falcon_info.falconctl_info.aid is defined
        fail_msg: "Falcon installation verification failed"
```

### Smoke Tests

#### **Post-Deployment Validation**
```yaml
- name: Smoke test Falcon deployment
  hosts: all
  tasks:
    - name: Test network connectivity to Falcon cloud
      uri:
        url: "https://api.crowdstrike.com/health"
        method: GET
        timeout: 10
      register: connectivity_test

    - name: Check Falcon process is running
      shell: |
        {% if ansible_os_family == "Windows" %}
        Get-Process -Name "CSFalconService" -ErrorAction SilentlyContinue
        {% else %}
        pgrep falcon-sensor
        {% endif %}
      register: process_check
      failed_when: process_check.rc != 0
```

## 📝 Best Practices Summary

### ✅ **DO's**
- **Use official collection**: Always use `crowdstrike.falcon` collection
- **API authentication**: Prefer API credentials over manual installers
- **Version pinning**: Pin collection versions in requirements
- **Error handling**: Include proper error handling and rollback
- **Logging**: Enable detailed logging for troubleshooting
- **Testing**: Test in non-production environments first
- **Monitoring**: Implement health checks and monitoring
- **Security**: Use Ansible Vault or external secret management

### ❌ **DON'Ts**
- **Hard-code secrets**: Never put credentials in plaintext
- **Skip validation**: Always verify installation success
- **Ignore errors**: Handle failed installations gracefully
- **Manual processes**: Avoid manual steps that break automation
- **Version drift**: Don't mix different sensor versions
- **Skip backups**: Always have rollback procedures
- **Ignore logs**: Monitor and review deployment logs

## 📞 Support and Community

### **Official Resources**
- **CrowdStrike Collection**: [GitHub Repository](https://github.com/CrowdStrike/ansible_collection_falcon)
- **Collection Documentation**: [Official Docs](https://crowdstrike.github.io/ansible_collection_falcon/)
- **FalconPy SDK**: [GitHub Repository](https://github.com/CrowdStrike/falconpy)
- **CrowdStrike Community**: [Community Forums](https://community.crowdstrike.com/)

### **Getting Help**
1. **Check documentation** first
2. **Search existing issues** in the collection repository
3. **Review logs** for specific error messages
4. **Create detailed issue reports** with:
   - Ansible version
   - Collection version
   - Target OS details
   - Error logs
   - Minimal reproduction case

### **Contributing**
- **Report bugs**: Use GitHub Issues
- **Feature requests**: Submit enhancement requests
- **Pull requests**: Follow contribution guidelines
- **Documentation**: Help improve docs and examples

---

## 🎉 Conclusion

This solution provides a production-ready, enterprise-grade automation framework for CrowdStrike Falcon agent management using official tools and best practices. The integration with the official CrowdStrike Ansible Collection ensures reliability, maintainability, and ongoing support.

**Key Benefits:**
- ✅ **Official Support**: Built on CrowdStrike-maintained tools
- ✅ **Enterprise Ready**: Scalable, secure, and compliant
- ✅ **Full Automation**: End-to-end deployment pipeline
- ✅ **Multi-Platform**: Windows and Linux support
- ✅ **API Integration**: Modern, API-driven approach
- ✅ **Extensible**: Easy to customize and extend

**Ready to deploy? Start with the Quick Start guide above! 🚀**

## 🔄 Advanced Usage

### Custom Installer Sources

If you need to use local installers instead of API downloads:

1. **Upload installers** to a accessible location
2. **Modify download tasks** in Ansible roles
3. **Update URLs** to point to your installer repository

### Multiple Environment Support

```yaml
# Different environments
environments:
  dev:
    resource_group: "rg-falcon-dev"
    vm_size: "Standard_B1s"
  prod:
    resource_group: "rg-falcon-prod"
    vm_size: "Standard_D2s_v3"
```

### Integration with Configuration Management

```yaml
# Add to existing Ansible inventory
falcon_agents:
  hosts:
    web-server-01:
      ansible_host: 10.0.1.10
    db-server-01:
      ansible_host: 10.0.1.20
```

## 📊 Monitoring and Reporting

### Post-Installation Verification

The automation includes verification steps that check:
- ✅ Service is running
- ✅ Agent is communicating with CrowdStrike cloud
- ✅ Customer ID (CID) is correctly configured
- ✅ Agent ID (AID) is generated

### Monitoring Commands

```bash
# Linux - Check Falcon status
sudo /opt/CrowdStrike/falconctl -g --cid
sudo /opt/CrowdStrike/falconctl -g --aid
sudo systemctl status falcon-sensor

# Windows - Check Falcon status (PowerShell)
Get-Service -Name "CSFalconService"
& "C:\Program Files\CrowdStrike\CSFalconContainer.exe" stats agent_info
```

## 🏢 Enterprise Considerations

### Scaling for Production

#### 1. **Infrastructure as Code Best Practices**
```hcl
# Use remote state for team collaboration
terraform {
  backend "azurerm" {
    resource_group_name   = "rg-terraform-state"
    storage_account_name  = "terraformstate"
    container_name        = "tfstate"
    key                   = "crowdstrike.terraform.tfstate"
  }
}
```

#### 2. **Environment Separation**
```bash
# Different workspaces for environments
terraform workspace new dev
terraform workspace new staging
terraform workspace new prod
```

#### 3. **Automated Deployment Pipeline**
```yaml
# .github/workflows/infrastructure.yml
name: Infrastructure Deployment
on:
  push:
    branches: [main]
    paths: ['terraform/**']
  
jobs:
  terraform:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - name: Setup Terraform
        uses: hashicorp/setup-terraform@v2
      - name: Terraform Apply
        run: |
          cd terraform
          terraform init
          terraform plan
          terraform apply -auto-approve
```

### Security Hardening

#### 1. **Network Segmentation**
```hcl
# Additional security groups for production
resource "azurerm_network_security_group" "falcon_mgmt" {
  name = "${var.prefix}-falcon-mgmt-nsg"
  
  security_rule {
    name                       = "FalconCloud"
    priority                   = 100
    direction                  = "Outbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_ranges    = ["443", "80"]
    source_address_prefix      = "*"
    destination_address_prefix = "CrowdStrike.FalconCloud"
  }
}
```

#### 2. **Key Management**
```yaml
# Use Azure Key Vault for secrets
- name: Get secrets from Key Vault
  uses: Azure/get-keyvault-secrets@v1
  with:
    keyvault: "falcon-secrets-kv"
    secrets: |
      falcon-cid
      admin-credentials
```

#### 3. **Compliance and Auditing**
```yaml
# Add compliance tags
tags = {
  Environment   = "Production"
  Compliance    = "SOC2"
  DataClass     = "Internal"
  Owner         = "SecurityTeam"
  CostCenter    = "IT-Security"
  Backup        = "Required"
}
```

## 🔄 Maintenance and Updates

### Regular Maintenance Tasks

#### 1. **Agent Health Checks**
```yaml
# .github/workflows/health-check.yml
name: Falcon Agent Health Check
on:
  schedule:
    - cron: '0 8 * * MON'  # Weekly on Monday at 8 AM
  
jobs:
  health-check:
    runs-on: ubuntu-latest
    steps:
      - name: Run health check playbook
        run: |
          ansible-playbook -i inventory.yml health-check.yml
```

#### 2. **Agent Updates**
```yaml
# Add to ansible/roles/*/tasks/update.yml
- name: Check current agent version
  shell: /opt/CrowdStrike/falconctl -g --version
  register: current_version

- name: Update agent if newer version available
  include_tasks: install.yml
  when: update_required
```

### Backup and Recovery

#### 1. **Configuration Backup**
```bash
# Backup Terraform state
terraform state pull > backup/terraform.tfstate.backup

# Backup Ansible inventory
cp ansible/inventory.yml backup/inventory-$(date +%Y%m%d).yml
```

#### 2. **Disaster Recovery**
```yaml
# .github/workflows/disaster-recovery.yml
name: Disaster Recovery
on:
  workflow_dispatch:
    inputs:
      restore_point:
        description: 'Backup restore point'
        required: true

jobs:
  restore:
    runs-on: ubuntu-latest
    steps:
      - name: Restore infrastructure
        run: |
          terraform init
          terraform import existing_resources
          terraform apply
```

## 📈 Performance Optimization

### Cost Optimization

#### 1. **VM Size Optimization**
```hcl
# Variable VM sizes based on environment
variable "vm_sizes" {
  type = map(object({
    linux   = string
    windows = string
  }))
  
  default = {
    dev = {
      linux   = "Standard_B1s"    # ~$4/month
      windows = "Standard_B1ms"   # ~$15/month
    }
    prod = {
      linux   = "Standard_D2s_v3" # ~$70/month
      windows = "Standard_D2s_v3" # ~$96/month
    }
  }
}
```

#### 2. **Auto-shutdown for Dev Environments**
```hcl
# Auto-shutdown for cost savings
resource "azurerm_dev_test_global_vm_shutdown_schedule" "main" {
  virtual_machine_id = azurerm_linux_virtual_machine.main.id
  location           = azurerm_resource_group.main.location
  enabled            = true

  daily_recurrence_time = "1900"
  timezone              = "UTC"
}
```

### Performance Monitoring

#### 1. **Azure Monitor Integration**
```hcl
# Enable monitoring
resource "azurerm_monitor_diagnostic_setting" "vm_diagnostics" {
  name               = "vm-diagnostics"
  target_resource_id = azurerm_linux_virtual_machine.main.id
  
  metric {
    category = "AllMetrics"
    enabled  = true
  }
}
```

## 🧪 Testing Strategy

### Unit Testing

#### 1. **Terraform Testing**
```bash
# Install terratest dependencies
go mod init terraform-test
go get github.com/gruntwork-io/terratest/modules/terraform

# Run tests
go test -v terraform_test.go
```

#### 2. **Ansible Testing with Molecule**
```bash
# Install molecule
pip install molecule molecule-docker

# Initialize molecule
cd ansible/roles/linux
molecule init scenario

# Run tests
molecule test
```

### Integration Testing

#### 1. **End-to-End Testing**
```yaml
# .github/workflows/e2e-test.yml
name: End-to-End Testing
on:
  pull_request:
    branches: [main]

jobs:
  e2e-test:
    runs-on: ubuntu-latest
    steps:
      - name: Deploy test environment
        run: terraform apply -var-file="test.tfvars"
      
      - name: Test Falcon installation
        run: |
          ansible-playbook -i test-inventory.yml playbook.yml \
            --extra-vars "falcon_action=install"
      
      - name: Verify installation
        run: |
          ansible-playbook -i test-inventory.yml verify.yml
      
      - name: Test Falcon uninstallation
        run: |
          ansible-playbook -i test-inventory.yml playbook.yml \
            --extra-vars "falcon_action=uninstall"
      
      - name: Cleanup test environment
        run: terraform destroy -auto-approve
```

## 🤝 Contributing

### Development Workflow

1. **Fork** the repository
2. **Create** a feature branch: `git checkout -b feature/new-functionality`
3. **Make** your changes
4. **Test** thoroughly
5. **Submit** a pull request

### Code Standards

#### Terraform
- Use consistent naming conventions
- Include variable descriptions
- Add resource tags
- Use modules for reusable components

#### Ansible
- Follow YAML best practices
- Use descriptive task names
- Include error handling
- Add debug outputs for troubleshooting

#### GitHub Actions
- Use official actions when possible
- Include timeout values
- Add artifact uploads for debugging
- Use environment-specific secrets

## 📚 Additional Resources

### Documentation Links
- [CrowdStrike Falcon Documentation](https://falcon.crowdstrike.com/documentation)
- [Azure Terraform Provider](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs)
- [Ansible Windows Modules](https://docs.ansible.com/ansible/latest/collections/ansible/windows/)
- [GitHub Actions Documentation](https://docs.github.com/en/actions)

### CrowdStrike Resources
- [Falcon API Documentation](https://falcon.crowdstrike.com/documentation/page/a2a7fc0e/crowdstrike-oauth2-based-apis)
- [Sensor Download API](https://falcon.crowdstrike.com/documentation/page/f01030e5/sensor-download-apis)
- [Falcon Linux Sensor Deployment Guide](https://falcon.crowdstrike.com/documentation/20/falcon-sensor-for-linux)

### Community Support
- [CrowdStrike Community](https://community.crowdstrike.com/)
- [Terraform Azure Provider Issues](https://github.com/hashicorp/terraform-provider-azurerm/issues)
- [Ansible Issues](https://github.com/ansible/ansible/issues)

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## ⚠️ Disclaimer

This automation is provided as-is for educational and development purposes. Always test thoroughly in a non-production environment before deploying to production systems. Ensure compliance with your organization's security policies and CrowdStrike's terms of service.

---

## 📞 Support

For issues and questions:

1. **Check** the troubleshooting section above
2. **Review** GitHub Issues for similar problems
3. **Create** a new issue with detailed information
4. **Include** relevant logs and error messages

**Happy automating! 🚀**



