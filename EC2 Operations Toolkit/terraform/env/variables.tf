variable "project_name" {
    type = string
}

variable "region" {
  type = string
}

variable "vpc_name" {
  type = string
}

variable "cidr" {
  type = string
}

variable "private_subnet" {
  type = map(object({
    ip = string
    az = string 
  }))
}

variable "public_subnet" {
  type = map(object({
    ip = string
    az = string
  }))
}