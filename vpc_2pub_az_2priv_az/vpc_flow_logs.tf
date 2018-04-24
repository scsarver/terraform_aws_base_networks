resource "aws_flow_log" "primary_zone_flow_log" {
  iam_role_arn   = "${aws_iam_role.role_primary_vpc_flow_log.arn}"
  log_group_name = "${aws_cloudwatch_log_group.primary_zone_vpc_flow_log_group.name}"
  traffic_type   = "ALL"
  vpc_id         = "${aws_vpc.primary_zone.id}"
}

resource "aws_cloudwatch_log_group" "primary_zone_vpc_flow_log_group" {
  name = "primary-zone-log-group"

  #retention_in_days = "-1"
}

resource "aws_iam_role" "role_primary_vpc_flow_log" {
  assume_role_policy = "${data.aws_iam_policy_document.assume_policy_document_primary_vpc_flow_log.json}"
  name               = "primary-vpc-flow-log"
}

resource "aws_iam_role_policy" "role_policy_primary_vpc_flow_log" {
  name   = "primary-vpc-flow-log"
  policy = "${data.aws_iam_policy_document.policy_document_primary_vpc_flow_log.json}"
  role   = "${aws_iam_role.role_primary_vpc_flow_log.name}"
}

data "aws_iam_policy_document" "assume_policy_document_primary_vpc_flow_log" {
  statement {
    actions = [
      "sts:AssumeRole",
    ]

    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["vpc-flow-logs.amazonaws.com"]
    }
  }
}

data "aws_iam_policy_document" "policy_document_primary_vpc_flow_log" {
  statement {
    actions = [
      "logs:CreateLogGroup",
      "logs:CreateLogStream",
      "logs:DescribeLogGroups",
      "logs:DescribeLogStreams",
      "logs:PutLogEvents",
    ]

    effect = "Allow"

    resources = [
      "*",
    ]
  }
}
