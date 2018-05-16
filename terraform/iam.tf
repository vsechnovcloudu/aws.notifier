data "aws_iam_policy_document" "sender-ses-allow" {

  statement {
    sid = "1"

    actions = [
      "ses:sendEmail"
    ]
    
    resources = ["*"]
  }
}

data "aws_iam_policy_document" "sender-assume-role-policy" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "sender_lambda" {
  depends_on = ["data.aws_iam_policy_document.sender-assume-role-policy"]
  name = "sender-${terraform.workspace}"
  assume_role_policy = "${data.aws_iam_policy_document.sender-assume-role-policy.json}"
  description = "Role allowing Lambda to use SES to send emails."
}

resource "aws_iam_policy" "sender-ses-allow" {
  name   = "sender-${terraform.workspace}"
  path   = "/"
  policy = "${data.aws_iam_policy_document.sender-ses-allow.json}"
  description = "Allowing to send an email."
}

resource "aws_iam_role_policy_attachment" "sender" {
  depends_on = ["aws_iam_role.sender_lambda"]
  role       = "${aws_iam_role.sender_lambda.name}"
  policy_arn = "${aws_iam_policy.sender-ses-allow.arn}"
}
