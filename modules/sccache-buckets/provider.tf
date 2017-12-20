provider "aws" {
  region  = "us-west-2"
  version = "~> 1.6"
}

provider "aws" {
  region  = "us-west-2"
  version = "~> 1.6"
  alias   = "us_west_2"
}

provider "aws" {
  region  = "us-west-1"
  version = "~> 1.6"
  alias   = "us_west_1"
}

provider "aws" {
  region  = "us-east-2"
  version = "~> 1.6"
  alias   = "us_east_2"
}

provider "aws" {
  region  = "eu-central-1"
  version = "~> 1.6"
  alias   = "eu_central_1"
}
