#!/bin/bash

# Define the repository (replace with your actual repo)
REPO="myuser/myrepo"

# Path to the file containing secrets and variables
FILE="secrets_and_variables.txt"

# Separate secrets and variables into different arrays
declare -A secrets
declare -A variables

# Read the file and populate the secrets and variables arrays
while IFS="=" read -r name value; do
  # Skip comments (lines starting with '#')
  if [[ $name =~ ^#.* ]]; then
    continue
  fi

  # If the variable or secret starts with "SECRET_", treat it as a secret
  if [[ $name == SECRET_* ]]; then
    secrets["$name"]="$value"
  elif [[ $name == VAR_* ]]; then
    variables["$name"]="$value"
  fi
done < "$FILE"

# Function to check if a secret exists
secret_exists() {
  gh secret list --repo "$REPO" | grep -q "$1"
}

# Function to check if a variable exists
variable_exists() {
  gh variable list --repo "$REPO" | grep -q "$1"
}

# Update or create secrets
echo "Creating or updating secrets..."
for secret_name in "${!secrets[@]}"; do
  secret_value="${secrets[$secret_name]}"

  # Check if the secret exists
  if secret_exists "$secret_name"; then
    echo "Secret '$secret_name' exists. Updating..."
    gh secret set "$secret_name" --repo "$REPO" --body "$secret_value"
  else
    echo "Secret '$secret_name' does not exist. Creating..."
    gh secret set "$secret_name" --repo "$REPO" --body "$secret_value"
  fi
done

# Update or create variables
echo "Creating or updating variables..."
for var_name in "${!variables[@]}"; do
  var_value="${variables[$var_name]}"

  # Check if the variable exists
  if variable_exists "$var_name"; then
    echo "Variable '$var_name' exists. Updating..."
    gh variable set "$var_name" --repo "$REPO" --value "$var_value"
  else
    echo "Variable '$var_name' does not exist. Creating..."
    gh variable set "$var_name" --repo "$REPO" --value "$var_value"
  fi
done

echo "Secrets and variables have been created or updated successfully!"
