resource "aws_vpc_peering_connection" "nomad" {
  for_each = var.vpc_peering

  region = each.value.peer_requestor_region

  vpc_id      = module.nomad_vpc[each.value.peer_requestor_region].vpc_id
  peer_vpc_id = module.nomad_vpc[each.value.peer_accepter_region].vpc_id
  peer_region = each.value.peer_accepter_region

  tags = {
    Name = "${var.prefix}-vpc-peering-${each.key}"
  }
}


resource "aws_vpc_peering_connection_accepter" "nomad" {
  for_each                  = var.vpc_peering
  region                    = each.value.peer_accepter_region
  vpc_peering_connection_id = aws_vpc_peering_connection.nomad[each.key].id
  auto_accept               = true
}
