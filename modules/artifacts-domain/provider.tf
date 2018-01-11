provider "aws" {
  // default, for global resources
  region  = "us-west-2"
  version = "~> 1.6"
}

provider "aws" {
  region  = "us-west-2"
  version = "~> 1.6"
  alias   = "us-west-2"
}

provider "aws" {
  region  = "us-west-1"
  version = "~> 1.6"
  alias   = "us-west-1"
}

provider "aws" {
  region  = "us-east-1"
  version = "~> 1.6"
  alias   = "us-east-1"
}

provider "aws" {
  region  = "us-east-2"
  version = "~> 1.6"
  alias   = "us-east-2"
}

provider "aws" {
  region  = "eu-central-1"
  version = "~> 1.6"
  alias   = "eu-central-1"
}
