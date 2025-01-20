variable "vpc_cidr_block" {
  description = "The CIDR block for the VPC."
  type        = string
}

variable "instance_tenancy" {
  description = "The instance tenancy option for the VPC."
  type        = string
}

variable "vpc_name" {
  description = "The name to assign to the VPC."
  type        = string
}

variable "vpc_environment" {
   type = string
}

variable "peer_owner_id" {
   type = string
}

variable "peering_name" {
  type = string
}

variable "peering_to_default_rt_route_table_id" {
  type = string
}

variable "peering_to_default_rt_destination_cidr_block" {
  type = string
}

variable "peering_to_public_rt_destination_cidr_block" {
  type = string
}

variable "peering_to_private_rt_destination_cidr_block" {
  type = string
}

/*-------------------------------------------------------*/

# variable "subnets" {   
#   description = "A list of subnet configurations"
#   type = list(object({
#     cidr_block = list(string)
#     map_public_ip_on_launch = optional(bool, false)
#     availability_zone = string
#     name       = string 
#   }))
# }

variable "public_subnet_cidr" {
  description = "List of CIDR blocks for public subnets"
  type        = list(string)
}

variable "public_sub_az" {
  description = "List of availability zones for public subnets"
  type        = list(string)
}

variable "map_public_ip_on_launch" {
  description = "Whether to map public IP on launch"
  type        = bool
  default     = true
}

variable "public_subnet_name" {
  description = "Base name for the subnets"
  type        = string
}

variable "public_subnet_tags" {
  description = "Additional tags for the subnets"
  type        = map(string)
  default     = {}
}

/*-------------------------------------------------------*/

variable "private_subnet_cidr" {
  description = "List of CIDR blocks for public subnets"
  type        = list(string)
}

variable "private_sub_az" {
  description = "List of availability zones for public subnets"
  type        = list(string)
}

# variable "private_subnet_name" {
#   description = "Base name for the subnets"
#   type        = string
# }

variable "private_subnet_tags" {
  type = list(map(string))
}


/*-------------------------------------------------------*/

variable "igw_name" {
  description = "The name of the internet gateway"
  type = string
}

variable "igw_environment" {
  description = "The environment name of the internet gateway"
  type = string
}

/*-------------------------------------------------------*/

variable "elasticip_name" {
  description = "The name of the internet gateway"
  type = string
}

variable "elasticip_environment"{
    type = string
}

/*-------------------------------------------------------*/

variable "nat_gateway_name"{
    type = string
}

variable "nat_gateway_environment"{
    type = string
}

/*-------------------------------------------------------*/


variable "public_rt_tag" {
  description = "List of tags for public route tables"
  type = list(object({
    name = string
    environment = string
  }))
}

/*-------------------------------------------------------*/

variable "private_rt_tag" {
  description = "List of tags for public route tables"
  type = list(object({
    name = string
    environment = string
  }))
}

/*-------------------------------------------------------*/
# Public Nacl

variable "public_nacl_ingress_rules" {
  description = "List of nacl ingress rules."
  type = list(object({
    protocol   = string
    rule_no    = number
    action     = string
    cidr_block = string
    from_port  = number
    to_port    = number
  }))
}

variable "public_nacl_egress_rules" {
  description = "List of nacl egress rules."
  type = list(object({
    protocol   = string
    rule_no    = number
    action     = string
    cidr_block = string
    from_port  = number
    to_port    = number
  }))
}

variable "public_nacl_tags" {
  description = "Tags to apply to the network ACL, including name and environment."
  type        = map(string)
  default     = {
    name        = "default-name"
    environment = "default-env"
  }
}


/*-------------------------------------------------------*/
# Frontend Nacl

variable "frontend_nacl_ingress_rules" {
  description = "List of nacl ingress rules."
  type = list(object({
    protocol   = string
    rule_no    = number
    action     = string
    cidr_block = string
    from_port  = number
    to_port    = number
  }))
}

variable "frontend_nacl_egress_rules" {
  description = "List of nacl egress rules."
  type = list(object({
    protocol   = string
    rule_no    = number
    action     = string
    cidr_block = string
    from_port  = number
    to_port    = number
  }))
}

variable "frontend_nacl_tags" {
  description = "Tags to apply to the network ACL, including name and environment."
  type        = map(string)
  default     = {
    name        = "default-name"
    environment = "default-env"
  }
}

/*-------------------------------------------------------*/
# Application Nacl

variable "application_nacl_ingress_rules" {
  description = "List of nacl ingress rules."
  type = list(object({
    protocol   = string
    rule_no    = number
    action     = string
    cidr_block = string
    from_port  = number
    to_port    = number
  }))
}

variable "application_nacl_egress_rules" {
  description = "List of nacl egress rules."
  type = list(object({
    protocol   = string
    rule_no    = number
    action     = string
    cidr_block = string
    from_port  = number
    to_port    = number
  }))
}

variable "application_nacl_tags" {
  description = "Tags to apply to the network ACL, including name and environment."
  type        = map(string)
  default     = {
    name        = "default-name"
    environment = "default-env"
  }
}

/*-------------------------------------------------------*/
# Database Nacl

variable "database_nacl_ingress_rules" {
  description = "List of nacl ingress rules."
  type = list(object({
    protocol   = string
    rule_no    = number
    action     = string
    cidr_block = string
    from_port  = number
    to_port    = number
  }))
}

variable "database_nacl_egress_rules" {
  description = "List of nacl egress rules."
  type = list(object({
    protocol   = string
    rule_no    = number
    action     = string
    cidr_block = string
    from_port  = number
    to_port    = number
  }))
}

variable "database_nacl_tags" {
  description = "Tags to apply to the network ACL, including name and environment."
  type        = map(string)
  default     = {
    name        = "default-name"
    environment = "default-env"
  }
}

/*-------------------------------------------------------*/
# ALB Security Group

variable "alb_sg_name" {
  type = list(string)
}

variable "alb_ingress_rule" {
  description = "List of ingress rules for the security group"
  type        = list(object({
    from_port        = number
    to_port          = number
    protocol         = string
    cidr_blocks      = list(string)
    ipv6_cidr_blocks = list(string)
  }))
}

variable "alb_egress_rule" {
  description = "List of egress rules for the security group"
  type        = list(object({
    from_port        = number
    to_port          = number
    protocol         = string
    cidr_blocks      = list(string)
    ipv6_cidr_blocks = list(string)
  }))
}

variable "alb_sg_tag" {
  type = map(string)
}

/*-------------------------------------------------------*/
# Application Load Balancer


variable "alb_name" {
  type = list(string)
}

variable "alb_internal" {
  type = bool
}

variable "alb_balancer_type" {
  type = list(string)
}

/*-------------------------------------------------------*/
# Application Target Group

variable "target_group_name" {
  type = list(string)
}

variable "target_group_port" {
  type = list(number)
}

variable "target_group_protocol" {
  type = list(string)
}

variable "target_group_taget_type" {
  type = list(string)
}

variable "target_group_path" {
  type = list(string)
}

/*-------------------------------------------------------*/
# alb_listener


variable "lb_listener_alb_port" {
  type = list(string)
}

variable "lb_listener_protocol" {
  type = list(string)
}

variable "listener_rule_priority" {
  type = list(string)
}

variable "path_patterns" {
type = list(string)
}

variable "record_name" {
  description = "route53 record name"
  type        = string
}
