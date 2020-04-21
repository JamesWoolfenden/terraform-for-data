resource "aws_vpc_endpoint" "s3" {

  vpc_id       = element(tolist(data.aws_vpcs.cluster.ids), 0)
  service_name = "com.amazonaws.${data.aws_region.current.name}.s3"

  tags = var.common_tags
}
