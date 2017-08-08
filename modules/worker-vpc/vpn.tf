# constants for mozilla tunnels; the indexes of values in each variable must match; these
# are not meant to be supplied by the caller
variable "_mozilla_vpn_datacenters" {
  default = ["mdc1", "releng.scl3"]
}

variable "_mozilla_vpn_bgp_asns" {
  default = ["65048", "65026"]
}

variable "_mozilla_vpn_ip_addresses" {
  default = ["63.245.208.251", "63.245.214.82"]
}

resource "aws_vpn_gateway" "vpc-vgw" {
  count  = "${var.mozilla_vpn_tunnel}"
  vpc_id = "${aws_vpc.mod.id}"

  tags {
    Name = "${var.name}"
  }
}

resource "aws_customer_gateway" "vpc-cgw" {
  count      = "${var.mozilla_vpn_tunnel * length(var._mozilla_vpn_datacenters)}"
  bgp_asn    = "${element(var._mozilla_vpn_bgp_asns, count.index)}"
  ip_address = "${element(var._mozilla_vpn_ip_addresses, count.index)}"
  type       = "ipsec.1"

  tags {
    Name = "${var.name}-${element(var._mozilla_vpn_datacenters, count.index)}"
  }
}

resource "aws_vpn_connection" "vpc-vpn" {
  count               = "${var.mozilla_vpn_tunnel * length(var._mozilla_vpn_datacenters)}"
  vpn_gateway_id      = "${aws_vpn_gateway.vpc-vgw.id}"
  customer_gateway_id = "${element(aws_customer_gateway.vpc-cgw.*.id, count.index)}"
  type                = "ipsec.1"
  static_routes_only  = false

  tags {
    Name = "${var.name}-${element(var._mozilla_vpn_datacenters, count.index)}"
  }
}

# propagate routes received via BGP from Mozilla
resource "aws_vpn_gateway_route_propagation" "vpc-vpn" {
  vpn_gateway_id = "${aws_vpn_gateway.vpc-vgw.id}"
  route_table_id = "${aws_route_table.mod.id}"
}
