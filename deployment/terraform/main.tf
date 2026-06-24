terraform {
  required_version = ">= 1.3"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
}

# ── Current AWS account (used to build unique bucket name) ─────────────────────
data "aws_caller_identity" "current" {}

# ── Resolve default VPC when vpc_id is not provided ───────────────────────────
data "aws_vpc" "selected" {
  id      = var.vpc_id != "" ? var.vpc_id : null
  default = var.vpc_id == "" ? true : null
}

data "aws_subnets" "public" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.selected.id]
  }
  filter {
    name   = "map-public-ip-on-launch"
    values = ["true"]
  }
}

locals {
  subnet_id = var.subnet_id != "" ? var.subnet_id : tolist(data.aws_subnets.public.ids)[0]
}

# ── Latest Ubuntu 22.04 LTS (x86_64) ──────────────────────────────────────────
data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"] # Canonical

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }
  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

locals {
  ami_id = var.ami_id != "" ? var.ami_id : data.aws_ami.ubuntu.id
}

# ── Security group ─────────────────────────────────────────────────────────────
resource "aws_security_group" "geocodes" {
  name        = "${var.project_name}-geocodes"
  description = "Geocodes stack: SSH, HTTP (FacetSearch/SPARQL), Dagster UI, Qlever UI"
  vpc_id      = data.aws_vpc.selected.id

  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = var.allowed_ssh_cidrs
  }

  ingress {
    description = "HTTP — FacetSearch UI + SPARQL proxy"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = var.allowed_http_cidrs
  }

  ingress {
    description = "Dagster Dagit"
    from_port   = 3001
    to_port     = 3001
    protocol    = "tcp"
    cidr_blocks = var.allowed_http_cidrs
  }

  ingress {
    description = "Qlever UI"
    from_port   = 7000
    to_port     = 7000
    protocol    = "tcp"
    cidr_blocks = var.allowed_http_cidrs
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name    = "${var.project_name}-geocodes"
    Project = var.project_name
  }
}

# ── EC2 instance ───────────────────────────────────────────────────────────────
resource "aws_instance" "geocodes" {
  ami                         = local.ami_id
  instance_type               = var.instance_type
  key_name                    = var.key_name
  subnet_id                   = local.subnet_id
  vpc_security_group_ids      = [aws_security_group.geocodes.id]
  associate_public_ip_address = true

  root_block_device {
    volume_type           = "gp3"
    volume_size           = var.root_volume_size_gb
    encrypted             = true
    delete_on_termination = true
    tags = {
      Name    = "${var.project_name}-geocodes-root"
      Project = var.project_name
    }
  }

  user_data = templatefile("${path.module}/user_data.sh", {
    project_name     = var.project_name
    repo_url         = var.deployment_repo_url
    repo_branch      = var.deployment_branch
    deployment_path  = var.deployment_path
    s3_bucket        = local.s3_bucket_name
    aws_region       = var.aws_region
    iam_access_key   = aws_iam_access_key.geocodes.id
    iam_secret_key   = aws_iam_access_key.geocodes.secret
  })

  tags = {
    Name    = "${var.project_name}-geocodes"
    Project = var.project_name
  }

  # user_data depends on the IAM access key being created first
  depends_on = [aws_iam_access_key.geocodes]
}

# ── Elastic IP ─────────────────────────────────────────────────────────────────
resource "aws_eip" "geocodes" {
  instance = aws_instance.geocodes.id
  domain   = "vpc"

  tags = {
    Name    = "${var.project_name}-geocodes"
    Project = var.project_name
  }
}
