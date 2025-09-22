resource "terraform_data" "reset_org_policies" {
  provisioner "local-exec" {
    # This runs our complete, robust script on the local machine
    command = <<-EOT
      #!/bin/bash
      
      # Stop script on any error
      set -e
      
      PROJECT_ID="${var.project_id}"
      echo "--- Starting Org Policy Reset for Project: $PROJECT_ID ---"
      
      # 1. Get Project Number
      echo "Fetching project number..."
      PROJECT_NUMBER=$(gcloud projects describe "$PROJECT_ID" --format="value(projectNumber)")
      if [[ -z "$PROJECT_NUMBER" ]]; then
        echo "Error: Could not find project number for $PROJECT_ID."
        exit 1
      fi
      
      # 2. Get ALL available constraints (as you suggested)
      echo "Fetching all available constraints for project..."
      CONSTRAINTS_TO_RESET=$(gcloud org-policies list --project="$PROJECT_ID" --show-unset --format="value(constraint)")
      
      if [[ -z "$CONSTRAINTS_TO_RESET" ]]; then
        echo "No organization policies found for project $PROJECT_ID."
        echo "--- Reset Complete (Nothing to do) ---"
        exit 0
      fi
      
      # 3. Create a single temp file for the policy YAML
      TEMP_POLICY_FILE=$(mktemp)
      # Ensure the temp file is cleaned up when the script exits
      trap "rm -f $TEMP_POLICY_FILE" EXIT
      
      # 4. Loop, build YAML, and apply
      for CONSTRAINT in $CONSTRAINTS_TO_RESET; do
        echo "Resetting: $CONSTRAINT"
        
        # Create the YAML content with 'reset: true'
        # This is the universal V2 command to "remove enforcement"
        # by setting the policy to the Google-managed default.
        cat > "$TEMP_POLICY_FILE" << EOF
name: projects/$PROJECT_NUMBER/policies/$CONSTRAINT
spec:
  reset: true
EOF
        
        # Apply the policy (suppress output for cleaner apply)
        gcloud org-policies set-policy "$TEMP_POLICY_FILE" > /dev/null
      done
      
      echo "--- Successfully reset all policies on $PROJECT_ID to 'Google Default' ---"
    EOT
  }
}

resource "null_resource" "set_project" {
  depends_on = [terraform_data.reset_org_policies]
  triggers = {
    always_run = timestamp()
  }

  provisioner "local-exec" {
    command = "gcloud config set project ${var.project_id} && gcloud config set billing/quota_project ${var.project_id} && gcloud auth application-default set-quota-project ${var.project_id}"
  }
}