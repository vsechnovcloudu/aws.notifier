resource "aws_lambda_function" "emailsender" {
  depends_on       = ["aws_iam_role.sender_lambda"]
  function_name    = "sender-${terraform.workspace}"
  role             = "${aws_iam_role.sender_lambda.arn}"
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

resource "aws_lambda_permission" "allow-apigw" {
  depends_on     = ["aws_api_gateway_method.senderpost"]
  statement_id   = "AllowExecutionFromAPIGW"
  action         = "lambda:InvokeFunction"
  function_name  = "${aws_lambda_function.emailsender.function_name}"
  principal      = "apigateway.amazonaws.com"
  source_arn     = "arn:aws:execute-api:${var.REGION}:${var.aws_account_id}:${aws_api_gateway_rest_api.sender.id}/*/${aws_api_gateway_method.senderpost.http_method}/"
}
