/*Cria uma policy a ser usada na IAM role da instancia*/
data "aws_iam_policy_document" "dataPolicy" {
  statement {
    actions = [
      "ec2:*",
      "s3:*",
      "ecs:*",
      "elasticfilesystem:Describe*",
    ]

    resources = [
      "*",
    ]
  }
}

resource "aws_iam_policy" "iamPolicy" {
  name        = "${var.environment_name}-policy"
  path        = "/"
  description = "IAM Policy for ${var.environment_name}"
  policy      = "${data.aws_iam_policy_document.dataPolicy.json}"
}
