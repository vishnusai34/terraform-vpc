resource "aws_vpc_peering_connection" "default" {
    count = var.is_peering_required ? 1 : 0
    vpc_id        = aws_vpc.main.id
    peer_vpc_id   = data.aws_vpc.default.id
    auto_accept   = true

    accepter {
        allow_remote_vpc_dns_resolution = true
  
    }
    requester {
        allow_remote_vpc_dns_resolution = true
    }
    
    tags = merge(
        var.vpc_peering_tags,
        local.common_tags,
        {
        Name = "${var.project}-${var.environment}-default"
        }
    )
  
}

resource "aws_route" "public_peering" {
    count = var.is_peering_required ? 1 : 0
    route_table_id = aws_route_table.public.id
    destination_cidr_block = data.aws_vpc.default.cidr_block
    vpc_peering_connection_id = aws_vpc_peering_connection.default[count.index].id

  
}

resource "aws_route" "default_peering" {
    count = var.is_peering_required ? 1 : 0
    route_table_id = data.aws_route_table.main.id
    destination_cidr_block = var.cidr_block
    vpc_peering_connection_id = aws_vpc_peering_connection.default[count.index].id
  
}