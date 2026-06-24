variable "project_name" {
  description = "Short identifier used in resource names (e.g. 'geocodes', 'myproject')"
  type        = string
  default     = "geocodes"
}

variable "aws_region" {
  description = "AWS region to deploy into"
  type        = string
  default     = "us-east-1"
}

variable "instance_type" {
  description = "EC2 instance type. t3.xlarge (4 vCPU / 16 GB) is recommended; Qlever index builds are memory-intensive"
  type        = string
  default     = "t3.xlarge"
}

variable "ami_id" {
  description = "EC2 AMI ID. Leave blank to use the latest Ubuntu 22.04 LTS in the selected region"
  type        = string
  default     = ""
}

variable "key_name" {
  description = "Name of an existing EC2 key pair for SSH access"
  type        = string
}

variable "vpc_id" {
  description = "VPC ID to deploy into. Leave blank to use the default VPC"
  type        = string
  default     = ""
}

variable "subnet_id" {
  description = "Subnet ID for the EC2 instance. Leave blank to pick the first public subnet in the VPC"
  type        = string
  default     = ""
}

variable "root_volume_size_gb" {
  description = "EC2 root EBS volume size (GB). Holds Qlever index data and Dagster SQLite state"
  type        = number
  default     = 100
}

variable "allowed_ssh_cidrs" {
  description = "CIDR blocks allowed SSH (port 22) access"
  type        = list(string)
  default     = ["0.0.0.0/0"]
}

variable "allowed_http_cidrs" {
  description = "CIDR blocks allowed HTTP (80), Dagster UI (3001), and Qlever UI (7000) access"
  type        = list(string)
  default     = ["0.0.0.0/0"]
}

variable "s3_bucket_name" {
  description = "S3 bucket name (must be globally unique). Leave blank to auto-generate as <project>-geocodes-<account_id>"
  type        = string
  default     = ""
}

variable "s3_graphs_public" {
  description = "Allow public read access to graphs/latest/* in S3 (required for Qlever to download release files without credentials)"
  type        = bool
  default     = true
}

variable "deployment_repo_url" {
  description = "Git repository URL cloned on the instance during cloud-init"
  type        = string
  default     = "https://github.com/earthcube/geocodes.git"
}

variable "deployment_branch" {
  description = "Git branch checked out during cloud-init bootstrap"
  type        = string
  default     = "main"
}

variable "deployment_path" {
  description = "Path on the instance where the repository is cloned"
  type        = string
  default     = "/opt/geocodes"
}
