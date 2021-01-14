project_id="ngfw1-301708"
region = "us-east4"
instances = [
    "https://www.googleapis.com/compute/v1/projects/ngfw1-301708/zones/us-east4-a/instances/vmseries1"
]
backend = "https://www.googleapis.com/compute/v1/projects/ngfw1-301708/zones/us-east4-a/instanceGroups/umig-vmseries"
terraform_service_account = "impersonate-me@ngfw1-301708.iam.gserviceaccount.com"
