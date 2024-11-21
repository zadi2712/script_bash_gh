#!/bin/bash

# Define the repository (replace with your actual repo)
REPO="myuser/myrepo"

# Define secrets and variables to be updated
# For secrets, you will specify the secret name and its new value
declare -A secrets=(
  ["SECRET_1"]="new_secret_value_1"
  ["SECRET_2"]="new_secret_value_2"
)

# For variables, you will specify the variable name and its new value
declare -A variables=(
  ["VAR_1"]="new_var_value_1"
  ["VAR_2"]="new_var_value_2"
)

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
