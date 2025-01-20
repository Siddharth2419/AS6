resource "aws_vpc" "dev_vpc" {
  cidr_block       = var.vpc_cidr_block
  instance_tenancy = var.instance_tenancy

  tags = {
    Name = var.vpc_name
    Environment = var.vpc_environment
  }
}

data "aws_vpc" "management_vpc" {
  id = "vpc-0e67c673521a9d9e5"
}

resource "aws_vpc_peering_connection" "peering_connection" {
  peer_owner_id = var.peer_owner_id
  peer_vpc_id   = aws_vpc.dev_vpc.id
  vpc_id        = data.aws_vpc.management_vpc.id
  auto_accept = true
  tags = {
    Name = var.peering_name
  }
}

resource "aws_route" "peering_to_default_rt" {
  route_table_id            = var.peering_to_default_rt_route_table_id
  destination_cidr_block    = var.peering_to_default_rt_destination_cidr_block
  vpc_peering_connection_id = aws_vpc_peering_connection.peering_connection.id
}


resource "aws_route" "peering_to_public_rt" {
  route_table_id            = aws_route_table.public_rt[0].id
  destination_cidr_block    = var.peering_to_public_rt_destination_cidr_block
  vpc_peering_connection_id = aws_vpc_peering_connection.peering_connection.id
}

resource "aws_route" "peering_to_private_rt" {
  route_table_id            = aws_route_table.private_rt[0].id
  destination_cidr_block    = var.peering_to_private_rt_destination_cidr_block
  vpc_peering_connection_id = aws_vpc_peering_connection.peering_connection.id
}


resource "aws_subnet" "public" {
  count                   = length(var.public_subnet_cidr)
  availability_zone       = element(var.public_sub_az, count.index )
  cidr_block              = element(var.public_subnet_cidr, count.index)
  map_public_ip_on_launch = var.map_public_ip_on_launch
  vpc_id                  = aws_vpc.dev_vpc.id

  tags = merge(
    {
    Type = "Public"
    Name = format("%s-subnet-%d", var.public_subnet_name,count.index+1)
  },
    var.public_subnet_tags,

  )
}


/*-------------------------------------------------------*/

resource "aws_subnet" "private" {
  count                   = length(var.private_subnet_cidr)
  availability_zone       = element(var.private_sub_az, count.index )
  cidr_block              = element(var.private_subnet_cidr, count.index)
  vpc_id                  = aws_vpc.dev_vpc.id

 tags = merge(
    {
      Name        = element(var.private_subnet_tags, count.index)["name"]
      Environment = element(var.private_subnet_tags, count.index)["environment"]
    },
    element(var.private_subnet_tags, count.index)
  )

}




/*-------------------------------------------------------*/

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.dev_vpc.id

  tags = {
    Name =  var.igw_name
    Environment = var.igw_environment
  }
}

/*-------------------------------------------------------*/

resource "aws_eip" "elasticip" {
  domain = "vpc"
  tags = {
    Name = var.elasticip_name
    Environment = var.elasticip_environment
  }
}

/*-------------------------------------------------------*/

resource "aws_nat_gateway" "nat_gateway" {
  allocation_id = aws_eip.elasticip.id
  subnet_id     = element(aws_subnet.public.*.id,0)

  tags = {
    Name = var.nat_gateway_name
    Environment = var.nat_gateway_environment
  }
}

# /*-------------------------------------------------------*/

resource "aws_route_table" "public_rt" {
  count = length(var.public_rt_tag)
  vpc_id = aws_vpc.dev_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = var.public_rt_tag[count.index].name
    Environment = var.public_rt_tag[count.index].environment
  }
}


# /*-------------------------------------------------------*/

resource "aws_route_table" "private_rt" {
  count = length(var.private_rt_tag)
  vpc_id = aws_vpc.dev_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.nat_gateway.id
  }

  tags = {
    Name = var.private_rt_tag[count.index].name
    Environment = var.private_rt_tag[count.index].environment
  }
}

# /*-------------------------------------------------------*/

resource "aws_route_table_association" "public_route_table_assosciation" {
  count = length(aws_subnet.public)
  subnet_id      = element(aws_subnet.public[*].id, count.index)
  route_table_id = element(aws_route_table.public_rt[*].id, count.index)
}

resource "aws_route_table_association" "private_route_table_assosciation" {
  count = length(aws_subnet.private)
  subnet_id      = element(aws_subnet.private[*].id, count.index)
  route_table_id = element(aws_route_table.private_rt[*].id, count.index)
}

# /*-------------------------------------------------------*/
# Public Nacl

resource "aws_network_acl" "public_nacl" {
  vpc_id = aws_vpc.dev_vpc.id

  dynamic "ingress" {
    for_each = var.public_nacl_ingress_rules
    content {
      protocol   = ingress.value.protocol
      rule_no    = ingress.value.rule_no
      action     = ingress.value.action
      cidr_block = ingress.value.cidr_block
      from_port  = ingress.value.from_port
      to_port    = ingress.value.to_port
    }
  }

  dynamic "egress" {
    for_each = var.public_nacl_egress_rules
    content {
      protocol   = egress.value.protocol
      rule_no    = egress.value.rule_no
      action     = egress.value.action
      cidr_block = egress.value.cidr_block
      from_port  = egress.value.from_port
      to_port    = egress.value.to_port
    }
  }

  tags = merge(
    {
      Name        = var.public_nacl_tags["name"]
      Environment = var.public_nacl_tags["environment"]
    },
    var.public_nacl_tags
  )
}

# /*-------------------------------------------------------*/
# public nacl subnet assosciation

resource "aws_network_acl_association" "nacl_public_subnet_assoscition_1" {
  count = length(aws_subnet.public)
  network_acl_id = aws_network_acl.public_nacl.id
  subnet_id      = element(aws_subnet.public[*].id , count.index)
}

# /*-------------------------------------------------------*/
# Frontend Nacl

resource "aws_network_acl" "frontend_nacl" {
  vpc_id = aws_vpc.dev_vpc.id
  subnet_ids = [ aws_subnet.private[0].id, aws_subnet.private[3].id ]

  dynamic "ingress" {
    for_each = var.frontend_nacl_ingress_rules
    content {
      protocol   = ingress.value.protocol
      rule_no    = ingress.value.rule_no
      action     = ingress.value.action
      cidr_block = ingress.value.cidr_block
      from_port  = ingress.value.from_port
      to_port    = ingress.value.to_port
    }
  }

  dynamic "egress" {
    for_each = var.frontend_nacl_egress_rules
    content {
      protocol   = egress.value.protocol
      rule_no    = egress.value.rule_no
      action     = egress.value.action
      cidr_block = egress.value.cidr_block
      from_port  = egress.value.from_port
      to_port    = egress.value.to_port
    }
  }

  tags = merge(
    {
      Name        = var.frontend_nacl_tags["name"]
      Environment = var.frontend_nacl_tags["environment"]
    },
    var.frontend_nacl_tags
  )
}

# /*-------------------------------------------------------*/
# Frontend nacl subnet assosciation
# WRONG BLOCK is not able to associate private subnets and fetch nacl id when applied with loop
# Use subnet_ids in aws_network_acl instead

# resource "aws_network_acl_association" "frontend_nacl_subnet_assoscition" {
#   count = length(aws_subnet.private)
#   network_acl_id = aws_network_acl.frontend_nacl.id
#   subnet_id      = element(aws_subnet.private.*.id, 0)

#   depends_on = [
#     aws_subnet.private,
#     aws_network_acl.application_nacl
#   ]

#   lifecycle {
#     create_before_destroy = true
#   }
# }

# /*-------------------------------------------------------*/
# Application Nacl

resource "aws_network_acl" "application_nacl" {
  vpc_id = aws_vpc.dev_vpc.id
  subnet_ids = [ aws_subnet.private[1].id, aws_subnet.private[4].id ]

  dynamic "ingress" {
    for_each = var.application_nacl_ingress_rules
    content {
      protocol   = ingress.value.protocol
      rule_no    = ingress.value.rule_no
      action     = ingress.value.action
      cidr_block = ingress.value.cidr_block
      from_port  = ingress.value.from_port
      to_port    = ingress.value.to_port
    }
  }

  dynamic "egress" {
    for_each = var.application_nacl_egress_rules
    content {
      protocol   = egress.value.protocol
      rule_no    = egress.value.rule_no
      action     = egress.value.action
      cidr_block = egress.value.cidr_block
      from_port  = egress.value.from_port
      to_port    = egress.value.to_port
    }
  }

  tags = merge(
    {
      Name        = var.application_nacl_tags["name"]
      Environment = var.application_nacl_tags["environment"]
    },
    var.application_nacl_tags
  )
}

# /*-------------------------------------------------------*/
# Database Nacl

resource "aws_network_acl" "database_nacl" {
  vpc_id = aws_vpc.dev_vpc.id
  subnet_ids = [aws_subnet.private[2].id, aws_subnet.private[5].id]

  dynamic "ingress" {
    for_each = var.database_nacl_ingress_rules
    content {
      protocol   = ingress.value.protocol
      rule_no    = ingress.value.rule_no
      action     = ingress.value.action
      cidr_block = ingress.value.cidr_block
      from_port  = ingress.value.from_port
      to_port    = ingress.value.to_port
    }
  }

  dynamic "egress" {
    for_each = var.database_nacl_egress_rules
    content {
      protocol   = egress.value.protocol
      rule_no    = egress.value.rule_no
      action     = egress.value.action
      cidr_block = egress.value.cidr_block
      from_port  = egress.value.from_port
      to_port    = egress.value.to_port
    }
  }

  tags = merge(
    {
      Name        = var.database_nacl_tags["name"]
      Environment = var.database_nacl_tags["environment"]
    },
    var.database_nacl_tags
  )
}

# /*-------------------------------------------------------*/
# ALB security group

resource "aws_security_group" "alb_security_group" {
  count = length(var.alb_sg_name)
  vpc_id = aws_vpc.dev_vpc.id
  name = element(var.alb_sg_name , count.index)

  tags = merge(
    {
      Name        = var.alb_sg_tag["name"]
      Environment = var.alb_sg_tag["environment"]
    },
    var.alb_sg_tag
  )
  
dynamic "ingress" {
    for_each = var.alb_ingress_rule
    content {
      from_port   = ingress.value.from_port
      to_port     = ingress.value.to_port
      protocol    = ingress.value.protocol
      cidr_blocks = ingress.value.cidr_blocks
      ipv6_cidr_blocks = ingress.value.ipv6_cidr_blocks
    }
  }

  dynamic "egress" {
    for_each = var.alb_egress_rule
    content {
      from_port   = egress.value.from_port
      to_port     = egress.value.to_port
      protocol    = egress.value.protocol
      cidr_blocks = egress.value.cidr_blocks
      ipv6_cidr_blocks = egress.value.ipv6_cidr_blocks
    }
  }
}

# /*-------------------------------------------------------*/
# Application Load Balancer

resource "aws_lb" "ot_load_balancer" {
  count = length(var.alb_name)
  name               =  element(var.alb_name , count.index)
  internal           = var.alb_internal
  load_balancer_type = element(var.alb_balancer_type , count.index)
  security_groups    = element([aws_security_group.alb_security_group[*].id] , count.index )
  subnets             = element([aws_subnet.public[*].id] , count.index)
}


# /*-------------------------------------------------------*/
# Alb Target Group

resource "aws_lb_target_group" "target_group" {
  count = length(var.target_group_name)
  name     =  element(var.target_group_name , count.index)
  port     = element(var.target_group_port , count.index)
  protocol = element(var.target_group_protocol , count.index)
  target_type = element(var.target_group_taget_type , count.index)
  vpc_id   = aws_vpc.dev_vpc.id

    health_check {
    path                = element(var.target_group_path , count.index)
    interval            = 300
    timeout             = 60
    healthy_threshold   = 2
    unhealthy_threshold = 5
    matcher             = "200"
  }
}

# /*-------------------------------------------------------*/
# alb_listener

resource "aws_lb_listener" "lb_listener" {
  count            = length(var.lb_listener_alb_port)
  load_balancer_arn = element(aws_lb.ot_load_balancer[*].arn, count.index)
  port              = element(var.lb_listener_alb_port , count.index)
  protocol          = element(var.lb_listener_protocol , count.index)

  default_action {
    type             = "forward"
    target_group_arn = element(aws_lb_target_group.target_group[*].arn , 0)
  }
}

# /*-------------------------------------------------------*/
# listener rule

resource "aws_lb_listener_rule" "listener_rule" {
  count = length(var.path_patterns)
  listener_arn = element(aws_lb_listener.lb_listener[*].arn, 0)
  # listener_arn = element(aws_lb_listener.lb_listener[*].arn, 0)
  priority     = element(var.listener_rule_priority , count.index)
  action {
    type             = "forward"
    target_group_arn = element(aws_lb_target_group.target_group[*].arn , count.index)
  }

  condition {
    path_pattern {
      values = [var.path_patterns[count.index]]
    }
  }
}

# /*-------------------------------------------------------*/

# Route53

data "aws_route53_zone" "selected" {
  name         = "indiantech.fun"
  private_zone = false
}

# ROUTE 53

resource "aws_route53_record" "this" {
  depends_on = [ aws_lb.ot_load_balancer ]
  zone_id = data.aws_route53_zone.selected.zone_id
  name    = var.record_name
  type    = "A"

  alias {
    name                   = "dualstack.${aws_lb.ot_load_balancer[0].dns_name}"
    zone_id                = aws_lb.ot_load_balancer[0].zone_id
    evaluate_target_health = true
  }
}
