project_id = "ngfw-298311"
region = "us-east4"
subnets = [
    "https://www.googleapis.com/compute/v1/projects/ngfw-298311/regions/us-east4/subnetworks/sb-untrust-us-east4",
    "https://www.googleapis.com/compute/v1/projects/ngfw-298311/regions/us-east4/subnetworks/sb-mgmt-us-east4",
    "https://www.googleapis.com/compute/v1/projects/ngfw-298311/regions/us-east4/subnetworks/sb-trust-us-east4"

]

tags = [
    # "ntag-iap-ssh",
    # "ntag-lb"
]

fw_panos        = "flex-bundle2-1002"
fw_machine_type   = "n1-standard-4"
terraform_service_account = "sa-to-impersoante@ngfw-298311.iam.gserviceaccount.com"