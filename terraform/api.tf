resource "aws_api_gateway_rest_api" "sender" {
  depends_on  = ["aws_lambda_function.emailsender"]
  name        = "SenderAPI-${terraform.workspace}"
  description = "The way of sending emails from our website!"
}

resource "aws_api_gateway_resource" "sender" {
  depends_on  = ["aws_api_gateway_rest_api.sender"]
  rest_api_id = "${aws_api_gateway_rest_api.sender.id}"
  parent_id   = "${aws_api_gateway_rest_api.sender.root_resource_id}"
  path_part   = "sender"
}

resource "aws_api_gateway_method" "senderpost" {
  depends_on    = ["aws_api_gateway_rest_api.sender"]
  rest_api_id   = "${aws_api_gateway_rest_api.sender.id}"
  resource_id   = "${aws_api_gateway_resource.sender.id}"
  http_method   = "POST"
  authorization = "NONE"
}

resource "aws_api_gateway_method_response" "senderpost" {
  depends_on  = ["aws_api_gateway_method.senderpost"]
  rest_api_id = "${aws_api_gateway_rest_api.sender.id}"
  resource_id = "${aws_api_gateway_resource.sender.id}"
  http_method = "${aws_api_gateway_method.senderpost.http_method}"
  status_code = "200"
  response_models {
    "application/json" = "Empty"
  }
  response_parameters {
    "method.response.header.Access-Control-Allow-Origin"  = true
  }
}

resource "aws_api_gateway_integration" "senderpost" {
  depends_on              = ["aws_api_gateway_method.senderpost"]
  rest_api_id             = "${aws_api_gateway_rest_api.sender.id}"
  resource_id             = "${aws_api_gateway_resource.sender.id}"
  http_method             = "${aws_api_gateway_method.senderpost.http_method}"
  integration_http_method = "POST"
  type                    = "AWS"
  uri                     = "arn:aws:apigateway:${var.REGION}:lambda:path/2015-03-31/functions/${aws_lambda_function.emailsender.arn}/invocations"
}

resource "aws_api_gateway_integration_response" "senderpost" {
  depends_on  = ["aws_api_gateway_method_response.senderpost"]
  rest_api_id = "${aws_api_gateway_rest_api.sender.id}"
  resource_id = "${aws_api_gateway_resource.sender.id}"
  http_method = "${aws_api_gateway_method.senderpost.http_method}"
  status_code = "${aws_api_gateway_method_response.senderpost.status_code}"

  response_templates {
    "application/json" = ""
  }

  response_parameters {
    "method.response.header.Access-Control-Allow-Origin" = "'${var.origin}'"
  }
}
