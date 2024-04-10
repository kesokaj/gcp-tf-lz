````
install gcloud-sdk https://cloud.google.com/sdk/docs/install-sdk#installing_the_latest_version

gcloud auth login

gcloud auth application-default login
or
set -x GOOGLE_APPLICATION_CREDENTIALS <PATH TO JSON KEY> <-- fish
alt
export GOOGLE_APPLICATION_CREDENTIALS=<PATH TO JSON KEY> <-- bash

1.) copy terraform.tfvars.sample to terraform.tfvars
2.) edit file terraform.tfvars
3.) or run ./populate.sh
4.) terraform init && terraform plan && terraform apply --auto-approve
5.) terraform destory --auto-approve <-- to cleanup
6.) ./cleanup.sh to remove old files
````
