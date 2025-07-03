provider "aws" {
  region = "us-west-2"  # Change to your preferred region
}

resource "aws_s3_bucket" "my_bucket" {
  bucket = "my-unique-bucket-name-12345"  # Change this to a globally unique name
  

  tags = {
    Name        = "MyS3Bucket"
    Environment = "Dev"
  }
}
