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

# 1. Replace template variables in all files (excluding this script and CICD-Pipeline.yml)
find . -type f \( \
  -name "*.cs" -o -name "*.csproj" -o -name "*.json" -o -name "*.yml" -o -name "*.sln" -o -name "*.md" -o -name "*.xml" \
\) ! -name "$(basename "$0")" ! -name "CICD-Pipeline.yml" \
  -exec sed -i \
    -e "s/{{DomainName}}/$DOMAIN_NAME/g" \
    -e "s/{{DomainShortName}}/$DOMAIN_SHORT_NAME/g" \
    -e "s/{{api_port}}/$API_PORT/g" \
    -e "s/{{msg_port}}/$MSG_PORT/g" \
    {} +

# 3. Rename solution and project files if needed
solution_file=$(find . -maxdepth 1 -name "*.sln" | head -n 1)
if [[ -n "$solution_file" ]]; then
  new_solution_name=$(echo "$solution_file" | sed "s/{{DomainName}}/$DOMAIN_NAME/g")
  if [[ "$solution_file" != "$new_solution_name" ]]; then
    mv "$solution_file" "$new_solution_name"
  fi
fi


# 5. Create appsettings.Development.json in each project folder if it doesn't exist, using appsettings.json as a template
for folder in ./src/Api ./src/App ./src/Message; do
  appsettings_path="$folder/appsettings.json"
  devsettings_path="$folder/appsettings.Development.json"
  if [[ -f "$appsettings_path" && ! -f "$devsettings_path" ]]; then
    cp "$appsettings_path" "$devsettings_path"
    echo "Created $devsettings_path from $appsettings_path"
  fi
done

echo "Domain template applied. Folders, files, and contents updated."
echo "WARNING: You MUST manually set your secrets and environment-specific values in the appsettings.json and appsettings.Development.json files for each service!"
