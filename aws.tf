provider "aws" {
  region  = "us-west-2"
  version = "1.14.1"
}

provider "aws" {
  region  = "us-west-2"
  version = "1.14.1"
  alias   = "us-west-2"
}

provider "aws" {
  region  = "us-west-1"
  version = "1.14.1"
  alias   = "us-west-1"
}

provider "aws" {
  region  = "us-east-1"
  version = "1.14.1"
  alias   = "us-east-1"
}

provider "aws" {
  region  = "us-east-2"
  version = "1.14.1"
  alias   = "us-east-2"
}

provider "aws" {
  region  = "eu-central-1"
  version = "1.14.1"
  alias   = "eu-central-1"
}

provider "aws" {
  region  = "eu-west-1"
  version = "1.14.1"
  alias   = "eu-west-1"
}
