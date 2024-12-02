terraform {
  backend "s3" {
    bucket         = "development-estate-remote-backend"
    key            = "backend/Development_estate.tfstate"
    region         = "us-east-1"
    dynamodb_table = "development-estate-remote-backend"
  }
}