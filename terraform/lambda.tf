resource "aws_lambda_function" "emailsender" {
  //depends_on       = ["aws_iam_role.bia_buy_lambda"]
  function_name    = "sender-${terraform.workspace}"
  role             = "arn:aws:iam::104324328386:role/emailtestrole"
  handler          = "index.handler"
  filename         = "sender-${terraform.workspace}.zip"
  //source_code_hash = "${base64sha256(file(${aws_lambda_function.buyorder.filename}))}"
  runtime          = "nodejs8.10"
  timeout          = "5"
  memory_size      = "1536"

  environment {
    variables = {
      sender = "${var.SENDER}"
      receiver = "${var.RECEIVER}"
    }
  }

  tags {
    Description = "Simple Email Sender"
  }
}
