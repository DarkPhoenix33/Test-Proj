terraform {
  backend "s3" {
    bucket       = "myterraform-pro-bucket"
    key          = "state/statefile.tfstate"
    region       = "us-east-1"
    encrypt      = true
    use_lockfile = true
  }
  required_version = ">= 1.5.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}
