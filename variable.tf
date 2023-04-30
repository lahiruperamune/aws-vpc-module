variable "vpc_name" {
  description = "VPC name"
  type = string
}

variable "vpc_cidr_block" {
  description = "CIDR block for the VPC"
  type = string
}

variable "azs" {
  type        = list(string)
  description = "Availability Zones"
  validation {
    error_message = "should be 1 or 2 AZs"
    condition     = !can(length(var.azs) > 2)
  }
}

variable "public_subnet_cidrs" {
  type        = list(string)
  description = "Public Subnet CIDR"
}

variable "private_subnet_cidrs" {
  type        = list(string)
  description = "Private Subnet CIDR"
}

variable "tags" {
  description = "Map of tags to apply to all resources"
  type        = map(string)
  default = {
    "Owner"     = "admin"
    "CreatedBy" = "admin"
  }
}

variable "instance_tenancy" {
  description = "VPC tenancy, default is default"
  type        = string
  default     = "default"
}

variable "enable_ipv6" {
  description = "Enable IPv6 for VPC, default is false"
  type        = bool
  default     = false
}

variable "enable_dns_hostnames" {
  description = "Enable DNS hostname, default is true"
  default     = true
}

variable "enable_dns_support" {
  description = "Enable DNS resolution, default is true"
  type        = bool
  default     = true
}

variable "enable_nat_gateway" {
  description = "Enabling NAT gateway"
  default     = true
}

variable "enable_flow_logs" {
  description = "Whether or not to enable VPC Flow Logs"
  type        = bool
  default     = true
}

variable "public_route_cidr_block" {
  description = "public route table cidr"
  type = string
}

variable "private_route_cidr_block" {
  description = "private route table cidr"
  type = string
}

variable "cloudwatch_log_group" {
  description = "destination cloudwatch log group "
  type = string
}

variable "flow_log_role_arn" {
  description = "arn of the flow log role"
  type = string
}