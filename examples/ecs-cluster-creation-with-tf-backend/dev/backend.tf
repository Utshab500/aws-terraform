terraform {
  backend "s3" {
    bucket = "my-tf-state-s3-backend-utshab500"
    key = "terraform.tfstate"
    region = "ap-southeast-1"
    dynamodb_table = "my-test-tf-lock-chanbra135"
  }
}