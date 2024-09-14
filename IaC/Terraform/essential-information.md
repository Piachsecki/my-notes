# Terraform


## Terms

# 1 
Terraform is a tool that is not tight-nit with some cloud provider,
that's why it is used, because once written configuration
can be used in different clouds.


> Terraform is a tool that is used to provision new things.


> Ansible is a tool for a management of already existing tools.


> Kubernetes

So, we can use Terraform to create new EC2 Instance and then
use Ansible to specify which OS system should be running 
under this EC2 instance for example. Or provisioning new
cluster's in the cloud and then manage and organize how
our pods are deployed by kubernetes


Terraform architecture
```bash

terraform state     <--->
                            Terraform Core   --->  CLOUD PROVIDER
terraform config    ---->

```

Process of setting up the terraform on your AWS

1) Create IAM User
2) `aws configure` in the right directory
3) `terraform init` 
4) `terraform plan` - checks current state of the resources
5) `terraform apply` - applies the commands specified
6) `terraform destroy` - cleaning resources after working with them



# PART 3

```bash
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }
}

#This piece of code is specified at the beginning with the 
#cloud provider we are going to use and below we can specify 
#the settings for this cloud provider such as

provider "aws" {
  region = "eu-central-1"
}
```

3) 
But very important aspect:
After terraform init we create this tree structure:

```bash
└───.terraform
    └───providers
        └───registry.terraform.io
            └───hashicorp
                └───aws
                    └───3.76.1
                        └───windows_386
└───.terraform.lock.hcl
└───.main.tf
```

And every after apply the state file is being created that is a representation
of infomations about our every resource that was deployed by terraform

In this state file there are sensitive data too, so we have to encrypt it 
and provide right permissions to the certain users

Normally state file is stored locally in our working directory,
but a better practice is to store is in the cloud - in an S3 instance
for example, to provide there encryption, make it available to the other
engineers too and make it available for some type of automatation by GithubActions


But this process is a little bit tricky.
We have to apply this changes first only locally so with:


backend "s3" {
bucket         = "devops-directive-tf-state" # REPLACE WITH YOUR BUCKET NAME
key            = "03-basics/import-bootstrap/terraform.tfstate"
region         = "us-east-1"
dynamodb_table = "terraform-state-locking"
encrypt        = true
}


this lines commented.

And afterwards uncomment it and then run again terraform init
to make this changes in aws - so make it as the backend for our state files.

```bash
terraform {
  ############################################################
  # AFTER RUNNING TERRAFORM APPLY (WITH LOCAL BACKEND)
  # YOU WILL UNCOMMENT THIS CODE THEN RERUN TERRAFORM INIT
  # TO SWITCH FROM LOCAL BACKEND TO REMOTE AWS BACKEND
  ############################################################
  backend "s3" {
    bucket         = "devops-directive-tf-state" # REPLACE WITH YOUR BUCKET NAME
    key            = "03-basics/import-bootstrap/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "terraform-state-locking"
    encrypt        = true
  }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }
}
```



4) terraform plan

It checks the desired state (the one specified in our config file)
such as main.tf WITH the actual state(the one that was already provisioned)








