output "subnet_id" {
  value = module.vpc.public_subnet
}

output "instance_id" {
  value = module.ec2.instance_id
}

output "public_ip" {
  value = module.ec2.public_ip
}