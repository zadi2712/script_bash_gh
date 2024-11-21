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

# Update secrets
echo "Updating secrets..."
for secret_name in "${!secrets[@]}"; do
  secret_value="${secrets[$secret_name]}"
  echo "Updating secret: $secret_name"
  gh secret set "$secret_name" --repo "$REPO" --body "$secret_value"
done

# Update variables
echo "Updating variables..."
for var_name in "${!variables[@]}"; do
  var_value="${variables[$var_name]}"
  echo "Updating variable: $var_name"
  gh variable set "$var_name" --repo "$REPO" --value "$var_value"
done

echo "Secrets and variables updated successfully!"
