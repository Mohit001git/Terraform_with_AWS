terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.16"
    }
  }

  required_version = ">= 1.2.0"
}

provider "aws" {
  region  = "us-east-1"
  access_key = ""
  secret_key = ""
  
}



//create s3 bucket
resource "aws_s3_bucket" "mybucket" {
  bucket = var.bucketname
}


resource "aws_s3_bucket_ownership_controls" "example" {
  bucket = aws_s3_bucket.mybucket.id

  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}


resource "aws_s3_bucket_public_access_block" "example" {
  bucket = aws_s3_bucket.mybucket.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}


resource "aws_s3_bucket_acl" "example" {
  depends_on = [
    aws_s3_bucket_ownership_controls.example,
    aws_s3_bucket_public_access_block.example,
  ]

  bucket = aws_s3_bucket.mybucket.id
  acl    = "public-read"
}

resource "aws_s3_object" "index" {
  bucket =aws_s3_bucket.mybucket.id
  key  ="index.html"
  source = "index.html"
  acl ="public-read"
  content_type = "text/html"
}

resource "aws_s3_object" "error" {
  bucket =aws_s3_bucket.mybucket.id
  key  ="error.html"
  source = "error.html"
  acl ="public-read"
  content_type = "text/html"
}

resource "aws_s3_object" "profile" {
  bucket = aws_s3_bucket.mybucket.id
  key ="profile.png"
  source ="profile.png"
  acl = "public-read"
}

resource "aws_s3_bucket_website_configuration" "website" {
  bucket =aws_s3_bucket.mybucket.id
  index_document {
    suffix ="index.html"
  }

  error_document {
    key ="error.html"
  }

  depends_on = [ aws_s3_bucket_acl.example ]

}






# resource "aws_vpc" "first-vpc" {
#   cidr_block = "10.0.0.0/16"
#   tags = {
#      Name = "production"
#   }
# }

# resource "aws_subnet" "subnet-1" {
#   vpc_id     = aws_vpc.first-vpc.id
#   cidr_block = "10.0.1.0/24"

#   tags = {
#     Name = "pr_buckod-subnet"
#   }
# }





# resource "aws_instance"  "my-first-instance" {
#   ami           = "ami-0d7a109bf30624c99"
#   instance_type = "t2.micro"

#   tags = {
#     Name = "Hello World"
#   }
# }

