#!/bin/bash
set -e

# Usage: ./apply-domain-template.sh "DomainName" "domainshortname" "api_port" "msg_port"
DOMAIN_NAME="$1"
DOMAIN_SHORT_NAME="$2"
API_PORT="${3:-5271}"
MSG_PORT="${4:-5281}"

if [[ -z "$DOMAIN_NAME" || -z "$DOMAIN_SHORT_NAME" ]]; then
  echo "Usage: $0 <DomainName> <DomainShortName> [api_port] [msg_port]"
  exit 1
fi

# 1. Replace template variables in all files (excluding this script)
find . -type f \( -name "*.cs" -o -name "*.csproj" -o -name "*.json" -o -name "*.yml" -o -name "*.sln" -o -name "*.md" -o -name "*.xml" \) ! -name "$(basename "$0")" \
  -exec sed -i \
    -e "s/{{DomainName}}/$DOMAIN_NAME/g" \
    -e "s/{{DomainShortName}}/$DOMAIN_SHORT_NAME/g" \
    -e "s/{{api_port}}/$API_PORT/g" \
    -e "s/{{msg_port}}/$MSG_PORT/g" \
    {} +

# 2. Rename folders and subfolders (example for src only, adjust as needed)
cd src
for d in Application Domain Infrastructure InternalContracts Message Test.Mocks Test.UnitTests; do
  if [ -d "$d" ]; then
    mv "$d" "${DOMAIN_NAME}${d/Application/}Application"
  fi
done
cd ..

# 3. Rename solution and project files
find . -name "*{{DomainName}}*" -exec bash -c 'mv "$0" "${0//\{\{DomainName\}\}/'$DOMAIN_NAME'}"' {} \;
find ./src -name "*{{DomainName}}*.csproj" -exec bash -c 'mv "$0" "${0//\{\{DomainName\}\}/'$DOMAIN_NAME'}"' {} \;

echo "Domain template applied. Folders, files, and contents updated."
echo "WARNING: You MUST manually set your secrets and environment-specific values in the appsettings.json and appsettings.Development.json files for each service!"
