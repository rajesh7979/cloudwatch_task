terraform {
  required_version = ">= 0.12"
  backend "s3" {
    encrypt        = true
    bucket         = "blue-planet-terraform-state"
    key            = "alb"
    region         = "us-west-2"
    dynamodb_table = "blueplanet-terraform-states-db"
  }
}

provider "aws" {
  profile = var.profile
  region  = var.region

}

# needed for ALB creation
provider "aws" {
  profile = var.profile
  region  = var.region
  alias   = "default"

}

provider "aws" {
  profile = var.profile
  region  = var.region
  alias   = "qadev"

  # for blueplanet-qa-dev AWS Account usage since we are restricted
  # from creating ELBs we must use the following role
  assume_role {
    role_arn = "arn:aws:iam::898584090475:role/saas-automation"
  }
}

provider "aws" {
  profile = var.profile
  region  = var.region
  alias   = "platformdev"

  # for blueplanet-platform-dev AWS Account usage since we are restricted
  # from creating ELBs we must use the following role
  assume_role {
    role_arn = "arn:aws:iam::234743491860:role/saas-automation"
  }
}
