terraform {
  backend "s3" {
    bucket  = "terraform-backend-321298294759"
    key     = "staging/terraform.tfstate"
    region  = "eu-north-1"
    encrypt = true
  }
}
