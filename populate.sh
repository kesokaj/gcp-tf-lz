


set -euxo pipefail

GCP_USER=$(gcloud auth list --format="value(ACCOUNT)")
GCP_BILLING_ID=$(gcloud beta billing accounts list --format="value(name)")
GCP_ORG_ID=$(gcloud organizations list --format="value(ID)")
GCP_TOKEN=$(gcloud auth print-access-token)

export GOOGLE_OAUTH_ACCESS_TOKEN=${GCP_TOKEN}
cat << EOF > terraform.tfvars

billing_id = "${GCP_BILLING_ID}"
org_id = "${GCP_ORG_ID}"
gcp_user = "${GCP_USER}"
EOF