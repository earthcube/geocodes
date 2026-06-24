output "public_ip" {
  description = "Elastic IP address of the geocodes instance"
  value       = aws_eip.geocodes.public_ip
}

output "instance_id" {
  description = "EC2 instance ID"
  value       = aws_instance.geocodes.id
}

output "s3_bucket" {
  description = "S3 bucket name"
  value       = aws_s3_bucket.geocodes.id
}

output "s3_bucket_arn" {
  description = "S3 bucket ARN"
  value       = aws_s3_bucket.geocodes.arn
}

output "iam_user" {
  description = "IAM user name for the scheduler"
  value       = aws_iam_user.geocodes.name
}

output "iam_access_key_id" {
  description = "AWS access key ID written to the instance .env"
  value       = aws_iam_access_key.geocodes.id
  sensitive   = true
}

output "iam_secret_access_key" {
  description = "AWS secret access key written to the instance .env"
  value       = aws_iam_access_key.geocodes.secret
  sensitive   = true
}

output "facetsearch_url" {
  description = "FacetSearch UI"
  value       = "http://${aws_eip.geocodes.public_ip}/"
}

output "dagster_url" {
  description = "Dagster Dagit UI"
  value       = "http://${aws_eip.geocodes.public_ip}:3001/"
}

output "qlever_ui_url" {
  description = "Qlever web UI"
  value       = "http://${aws_eip.geocodes.public_ip}:7000/"
}

output "sparql_endpoint" {
  description = "SPARQL endpoint (proxied by Nginx)"
  value       = "http://${aws_eip.geocodes.public_ip}/sparql"
}

output "ssh_command" {
  description = "SSH command to connect to the instance"
  value       = "ssh ubuntu@${aws_eip.geocodes.public_ip}"
}

output "bootstrap_log" {
  description = "Cloud-init log path on the instance"
  value       = "/var/log/geocodes-setup.log"
}
