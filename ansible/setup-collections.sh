#!/bin/bash
# ansible/setup-collections.sh
# Helper script to install required Ansible collections locally

set -e

# Colors for output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo -e "${GREEN}🚀 Setting up CrowdStrike Falcon Ansible Collections${NC}"
echo "=================================================="

# Check if Ansible is installed
if ! command -v ansible &> /dev/null; then
    echo -e "${YELLOW}⚠️ Ansible is not installed. Installing...${NC}"
    pip install ansible
fi

# Check Python version
python_version=$(python3 -c "import sys; print('.'.join(map(str, sys.version_info[:2])))")
echo "Python version: $python_version"

if python3 -c "import sys; sys.exit(0 if sys.version_info >= (3, 7) else 1)"; then
    echo -e "${GREEN}✅ Python version meets requirements (>= 3.7)${NC}"
else
    echo -e "${RED}❌ Python 3.7+ is required${NC}"
    exit 1
fi

# Install Python requirements
echo -e "${YELLOW}📦 Installing Python dependencies...${NC}"
pip install crowdstrike-falconpy requests pywinrm

# Install Ansible collections from requirements.yml
echo -e "${YELLOW}📦 Installing Ansible collections...${NC}"
if [ -f "requirements.yml" ]; then
    ansible-galaxy collection install -r requirements.yml --force
else
    # Install collections individually if requirements.yml doesn't exist
    ansible-galaxy collection install crowdstrike.falcon --force
    ansible-galaxy collection install ansible.windows --force
    ansible-galaxy collection install community.windows --force
fi

echo -e "${GREEN}✅ Collection installation completed!${NC}"

# List installed collections
echo -e "${YELLOW}📋 Installed collections:${NC}"
ansible-galaxy collection list | grep -E "(crowdstrike|ansible\.windows|community\.windows)"

# Verify CrowdStrike collection
echo -e "${YELLOW}🔍 Verifying CrowdStrike Falcon collection...${NC}"
if ansible-doc crowdstrike.falcon.falcon_install > /dev/null 2>&1; then
    echo -e "${GREEN}✅ CrowdStrike Falcon collection is properly installed${NC}"
else
    echo -e "${RED}❌ Issue with CrowdStrike Falcon collection installation${NC}"
    exit 1
fi

echo -e "${GREEN}🎉 Setup completed successfully!${NC}"
echo
echo "Available CrowdStrike Falcon roles:"
echo "  - crowdstrike.falcon.falcon_install"
echo "  - crowdstrike.falcon.falcon_configure"
echo "  - crowdstrike.falcon.falcon_uninstall"
echo
echo "Key modules:"
echo "  - crowdstrike.falcon.sensor_download"
echo "  - crowdstrike.falcon.falconctl"
echo "  - crowdstrike.falcon.falconctl_info"
