#!/bin/bash
# scripts/setup-github-secrets.sh
# Helper script to set up GitHub secrets using GitHub CLI

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo -e "${GREEN}🔐 GitHub Secrets Setup for CrowdStrike Falcon Automation${NC}"
echo "========================================================"

# Check if GitHub CLI is installed
if ! command -v gh &> /dev/null; then
    echo -e "${RED}❌ GitHub CLI (gh) is not installed${NC}"
    echo "Please install it from: https://cli.github.com/"
    exit 1
fi

# Check if user is authenticated
if ! gh auth status &> /dev/null; then
    echo -e "${YELLOW}⚠️ Not authenticated with GitHub CLI${NC}"
    echo "Please run: gh auth login"
    exit 1
fi

echo -e "${GREEN}✅ GitHub CLI is installed and authenticated${NC}"
echo

# Function to set secret
set_secret() {
    local secret_name=$1
    local secret_description=$2
    local is_optional=${3:-false}
    
    echo -e "${YELLOW}Setting up: $secret_name${NC}"
    echo "Description: $secret_description"
    
    if [ "$is_optional" = true ]; then
        echo -e "${YELLOW}(Optional - press Enter to skip)${NC}"
    fi
    
    echo -n "Enter value: "
    read -s secret_value
    echo
    
    if [ -n "$secret_value" ]; then
        echo "$secret_value" | gh secret set "$secret_name"
        echo -e "${GREEN}✅ $secret_name set successfully${NC}"
    elif [ "$is_optional" = true ]; then
        echo -e "${YELLOW}⏭️ Skipped $secret_name${NC}"
    else
        echo -e "${RED}❌ $secret_name is required${NC}"
        exit 1
    fi
    
    echo
}

# Required secrets
echo -e "${GREEN}📋 Setting up REQUIRED secrets:${NC}"
echo

set_secret "FALCON_CID" "Your CrowdStrike Customer ID (e.g., 1234567890ABCDEF1234567890ABCDEF-12)"

set_secret "LINUX_ADMIN_USERNAME" "Linux VM administrator username"

set_secret "LINUX_ADMIN_PASSWORD" "Linux VM administrator password"

set_secret "WINDOWS_ADMIN_USERNAME" "Windows VM administrator username"

set_secret "WINDOWS_ADMIN_PASSWORD" "Windows VM administrator password"

# Optional secrets
echo -e "${GREEN}📋 Setting up OPTIONAL secrets:${NC}"
echo -e "${YELLOW}These are used for automatic installer downloads. Skip if you'll use manual installers.${NC}"
echo

set_secret "FALCON_CLIENT_ID" "CrowdStrike API Client ID for automatic downloads" true

set_secret "FALCON_CLIENT_SECRET" "CrowdStrike API Client Secret for automatic downloads" true

set_secret "FALCON_CLOUD" "CrowdStrike Cloud (us-1, us-2, eu-1, us-gov-1)" true

# Additional optional secrets for Azure authentication (if needed)
echo -e "${GREEN}📋 Setting up AZURE secrets (if using service principal):${NC}"
echo -e "${YELLOW}These are needed if you want to run Terraform from GitHub Actions${NC}"
echo

set_secret "AZURE_CLIENT_ID" "Azure Service Principal Client ID" true

set_secret "AZURE_CLIENT_SECRET" "Azure Service Principal Client Secret" true

set_secret "AZURE_SUBSCRIPTION_ID" "Azure Subscription ID" true

set_secret "AZURE_TENANT_ID" "Azure Tenant ID" true

echo -e "${GREEN}🎉 GitHub Secrets setup completed!${NC}"
echo
echo -e "${GREEN}📋 Summary of secrets that should be configured:${NC}"
echo "Required:"
echo "  ✅ FALCON_CID"
echo "  ✅ LINUX_ADMIN_USERNAME"
echo "  ✅ LINUX_ADMIN_PASSWORD"
echo "  ✅ WINDOWS_ADMIN_USERNAME"
echo "  ✅ WINDOWS_ADMIN_PASSWORD"
echo
echo "Optional:"
echo "  🔧 FALCON_API_CLIENT_ID"
echo "  🔧 FALCON_API_CLIENT_SECRET"
echo "  🔧 AZURE_CLIENT_ID"
echo "  🔧 AZURE_CLIENT_SECRET"
echo "  🔧 AZURE_SUBSCRIPTION_ID"
echo "  🔧 AZURE_TENANT_ID"
echo
echo -e "${GREEN}🚀 You're ready to run the CrowdStrike automation workflow!${NC}"

# Instructions for getting CrowdStrike credentials
echo
echo -e "${YELLOW}📝 How to get CrowdStrike credentials:${NC}"
echo "1. Log into CrowdStrike Falcon console"
echo "2. Navigate to Support → API Clients & Keys"
echo "3. Copy your Customer ID (CID)"
echo "4. Create API client with 'Sensor Download' scope (optional)"
echo "5. Note the Client ID and Secret (optional)"
echo
echo -e "${YELLOW}📝 How to get Azure credentials (for Terraform in GitHub Actions):${NC}"
echo "1. Create a service principal: az ad sp create-for-rbac --name 'falcon-terraform'"
echo "2. Note the appId (CLIENT_ID), password (CLIENT_SECRET), and tenant (TENANT_ID)"
echo "3. Get subscription ID: az account show --query id"
