#!/bin/bash

# PostgreSQL Project Generator
# Usage: ./create-project.sh <project_name>

if [ $# -eq 0 ]; then
    echo "Usage: $0 <project_name>"
    echo "Example: $0 ecommerce"
    exit 1
fi

PROJECT_NAME=$1
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
INVENTORY_DIR="$SCRIPT_DIR/inventory"
ROOT_PROJECT="$INVENTORY_DIR/root_project"
NEW_PROJECT="$INVENTORY_DIR/$PROJECT_NAME"

# Check if project already exists
if [ -d "$NEW_PROJECT" ]; then
    echo "❌ Project '$PROJECT_NAME' already exists!"
    exit 1
fi

# Check if root_project exists
if [ ! -d "$ROOT_PROJECT" ]; then
    echo "❌ root_project template not found!"
    exit 1
fi

echo "🚀 Creating new PostgreSQL project: $PROJECT_NAME"

# Copy root_project to new project
cp -r "$ROOT_PROJECT" "$NEW_PROJECT"

# Update project name in all.yml
if [ -f "$NEW_PROJECT/group_vars/all.yml" ]; then
    # For macOS sed
    sed -i '' "s/project_name: \"root_project\"/project_name: \"$PROJECT_NAME\"/" "$NEW_PROJECT/group_vars/all.yml"
    echo "✅ Updated project name in group_vars/all.yml"
fi

# Create a project-specific README
cat > "$NEW_PROJECT/README.md" << EOF
# PostgreSQL Project: $PROJECT_NAME

## Quick Start

\`\`\`bash
# Test connectivity
ansible -i inventory/$PROJECT_NAME/hosts all -m ping

# Run playbook on production
ansible-playbook -i inventory/$PROJECT_NAME/hosts playbook.yml --limit prod

# Run playbook on test
ansible-playbook -i inventory/$PROJECT_NAME/hosts playbook.yml --limit test

# Run only on PostgreSQL servers
ansible-playbook -i inventory/$PROJECT_NAME/hosts playbook.yml --limit postgresql
\`\`\`

## Inventory Structure

- **prod**: Production PostgreSQL servers
- **test**: Test PostgreSQL servers  
- **postgresql**: All PostgreSQL servers (prod + test)

## Customization

1. Update IP addresses in \`hosts\` file
2. Modify variables in \`group_vars/\` and \`host_vars/\`
3. Adjust PostgreSQL configuration as needed

## Generated: $(date)
EOF

echo "✅ Created project directory: $NEW_PROJECT"
echo "✅ Generated README.md"
echo ""
echo "📝 Next steps:"
echo "1. Edit inventory/$PROJECT_NAME/hosts - Update IP addresses"
echo "2. Edit inventory/$PROJECT_NAME/group_vars/all.yml - Review project settings"
echo "3. Test connectivity: ansible -i inventory/$PROJECT_NAME/hosts all -m ping"
echo ""
echo "🔧 Quick edit commands:"
echo "vim inventory/$PROJECT_NAME/hosts"
echo "vim inventory/$PROJECT_NAME/group_vars/all.yml"
