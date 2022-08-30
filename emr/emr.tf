resource "aws_emr_cluster" "cluster" {
  name          = "IData Pipeline Cluster"
  release_label = "emr-6.3.0"
  applications  = ["Spark", "Hive", "Livy"]

  termination_protection            = false
  keep_job_flow_alive_when_no_steps = true

  ec2_attributes {
    subnet_id                         = "${var.subnet}"
    emr_managed_master_security_group = aws_security_group.allow_access.id
    emr_managed_slave_security_group  = aws_security_group.allow_access.id
    instance_profile                  = aws_iam_instance_profile.emr_profile.arn
  }

  master_instance_group {
    instance_type = "m5.xlarge"
  }

  core_instance_group {
    instance_count = 1
    instance_type  = "m5.xlarge"
  }

  tags = {
    name = "${var.environment_name}"
  }

  # Shutdown the cluster afte 4 hours of inactivity
  auto_termination_policy {
    idle_timeout = 14400 
  }


  configurations_json = <<EOF
[{
    "classification": "emrfs-site",
    "properties": {
      "fs.s3.multipart.th.fraction.parts.completed": "0.99"
    },
    "configurations": []
  },
  {
    "classification": "spark-defaults",
    "properties": {
      "spark.rpc.message.maxSize": "1024",
      "spark.sql.hive.convertMetastoreParquet": "false",
      "spark.sql.legacy.parquet.datetimeRebaseModeInRead": "LEGACY",
      "spark.sql.legacy.parquet.int96RebaseModeInRead": "LEGACY",
      "spark.driver.maxResultSize": "8192M",
      "spark.network.timeout": "600s",
      "spark.sql.sources.partitionOverwriteMode": "dynamic",
      "spark.sql.legacy.parquet.datetimeRebaseModeInWrite": "LEGACY",
      "spark.sql.legacy.timeParserPolicy": "LEGACY",
      "spark.sql.session.timeZone": "America/New_York",
      "spark.serializer": "org.apache.spark.serializer.KryoSerializer",
      "spark.sql.orc.enableVectorizedReader": "false",
      "spark.executor.extraJavaOptions": "-Duser.timezone=America/New_York",
      "spark.sql.legacy.parquet.int96RebaseModeInWrite": "LEGACY",
      "spark.driver.extraJavaOptions": "-Duser.timezone=America/New_York"
    },
    "configurations": []
  }
]
EOF

  service_role = aws_iam_role.iam_emr_service_role.arn
}

resource "aws_security_group" "allow_access" {
  name        = "allow_access"
  description = "Allow inbound traffic"
  vpc_id     = data.terraform_remote_state.vpc.outputs.vpc_id

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = [data.terraform_remote_state.vpc.outputs.vpc_cidr_block]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  depends_on = [data.terraform_remote_state.vpc.outputs.private_subnets]

  lifecycle {
    ignore_changes = [
      ingress,
      egress,
    ]
  }

  tags = {
    name = "${var.environment_name}"
  }
}


###

# IAM Role setups

###

# IAM role for EMR Service
resource "aws_iam_role" "iam_emr_service_role" {
  name = "iam_emr_service_role"

  assume_role_policy = <<EOF
{
  "Version": "2008-10-17",
  "Statement": [
    {
      "Sid": "",
      "Effect": "Allow",
      "Principal": {
        "Service": "elasticmapreduce.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy" "iam_emr_service_policy" {
  name = "iam_emr_service_policy"
  role = aws_iam_role.iam_emr_service_role.id

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [{
        "Effect": "Allow",
        "Resource": "*",
        "Action": [
            "ec2:AuthorizeSecurityGroupEgress",
            "ec2:AuthorizeSecurityGroupIngress",
            "ec2:CancelSpotInstanceRequests",
            "ec2:CreateNetworkInterface",
            "ec2:CreateSecurityGroup",
            "ec2:CreateTags",
            "ec2:DeleteNetworkInterface",
            "ec2:DeleteSecurityGroup",
            "ec2:DeleteTags",
            "ec2:DescribeAvailabilityZones",
            "ec2:DescribeAccountAttributes",
            "ec2:DescribeDhcpOptions",
            "ec2:DescribeInstanceStatus",
            "ec2:DescribeInstances",
            "ec2:DescribeKeyPairs",
            "ec2:DescribeNetworkAcls",
            "ec2:DescribeNetworkInterfaces",
            "ec2:DescribePrefixLists",
            "ec2:DescribeRouteTables",
            "ec2:DescribeSecurityGroups",
            "ec2:DescribeSpotInstanceRequests",
            "ec2:DescribeSpotPriceHistory",
            "ec2:DescribeSubnets",
            "ec2:DescribeVpcAttribute",
            "ec2:DescribeVpcEndpoints",
            "ec2:DescribeVpcEndpointServices",
            "ec2:DescribeVpcs",
            "ec2:DetachNetworkInterface",
            "ec2:ModifyImageAttribute",
            "ec2:ModifyInstanceAttribute",
            "ec2:RequestSpotInstances",
            "ec2:RevokeSecurityGroupEgress",
            "ec2:RunInstances",
            "ec2:TerminateInstances",
            "ec2:DeleteVolume",
            "ec2:DescribeVolumeStatus",
            "ec2:DescribeVolumes",
            "ec2:DetachVolume",
            "iam:GetRole",
            "iam:GetRolePolicy",
            "iam:ListInstanceProfiles",
            "iam:ListRolePolicies",
            "iam:PassRole",
            "cloudwatch:*",
            "dynamodb:*",
            "s3:*",
            "sns:*",
            "glue:*",
            "secretsmanager:*",
            "athena:*",
            "aws-marketplace:*"
        ]
    }]
}
EOF
}

# IAM Role for EC2 Instance Profile
resource "aws_iam_role" "iam_emr_profile_role" {
  name = "iam_emr_profile_role"

  assume_role_policy = <<EOF
{
  "Version": "2008-10-17",
  "Statement": [
    {
      "Sid": "",
      "Effect": "Allow",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

resource "aws_iam_instance_profile" "emr_profile" {
  name = "emr_profile"
  role = aws_iam_role.iam_emr_profile_role.name
}

resource "aws_iam_role_policy" "iam_emr_profile_policy" {
  name = "iam_emr_profile_policy"
  role = aws_iam_role.iam_emr_profile_role.id

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [{
        "Effect": "Allow",
        "Resource": "*",
        "Action": [
            "ec2:*",
            "elasticmapreduce:*",
            "cloudwatch:*",
            "dynamodb:*",
            "s3:*",
            "sns:*",
            "glue:*",
            "secretsmanager:*",
            "athena:*",
            "aws-marketplace:*"
        ]
    }]
}
EOF
}