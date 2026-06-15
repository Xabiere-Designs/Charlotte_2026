terraform {
  backend "s3" {
    bucket         = "xabieredesigns-charlotte-2026-tfstate"
    key            = "charlotte-2026/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "charlotte-2026-tf-locks"
    encrypt        = true
  }
}