terraform {
    required_providers {
        aws = {
            source = "hashicorp/aws"
            version = "5.31.0"
        }
    }
    
    backend "s3" {
        bucket  = "mohana-remote-state"
        key     = "provisioner"
        region  = "us-east-1"
        dynamodb_table = "mohana-locking"
    }
}

provider "aws" {
   region = "us-east-1" 
}