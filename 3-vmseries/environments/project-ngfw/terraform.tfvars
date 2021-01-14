project_id = "ngfw1-301708"
region     = "us-east4"
subnets = [
  "https://www.googleapis.com/compute/v1/projects/ngfw1-301708/regions/us-east4/subnetworks/sb-untrust-us-east4",
  "https://www.googleapis.com/compute/v1/projects/ngfw1-301708/regions/us-east4/subnetworks/sb-management-us-east4",
  "https://www.googleapis.com/compute/v1/projects/ngfw1-301708/regions/us-east4/subnetworks/sb-trust-us-east4"

]

tags = [
  # "ntag-iap-ssh",
  # "ntag-lb"
]

fw_panos                  = "flex-bundle2-1002"
fw_machine_type           = "n1-standard-4"
terraform_service_account = "impersonate-me@ngfw1-301708.iam.gserviceaccount.com"
