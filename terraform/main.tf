provider "aws" {
  access_key = "${var.AWS_ACCESS_KEY_ID}"
  secret_key = "${var.AWS_SECRET_ACCESS_KEY}"
  region     = "${var.region}"
}

data "aws_caller_identity" "current" {}

resource "aws_iam_role" "iam_role_for_lambda" {
  name = "iam_role_for_lambda"
  assume_role_policy = "${file("policies/lambda-role.json")}"
}

module "lambda" {
  source = "./lambda"
  name = "index"
  runtime = "nodejs4.3"
  role = "${aws_iam_role.iam_role_for_lambda.arn}"
}

module "lambda_post" {
  source = "./lambda"
  name = "index"
  handler = "post_handler"
  runtime = "nodejs4.3"
  role = "${aws_iam_role.iam_role_for_lambda.arn}"
}

resource "aws_api_gateway_rest_api" "hello_api" {
  name = "Hello API"
}

resource "aws_api_gateway_resource" "hello_api_res_hello" {
  rest_api_id = "${aws_api_gateway_rest_api.hello_api.id}"
  parent_id   = "${aws_api_gateway_rest_api.hello_api.root_resource_id}"
  path_part   = "hello"
}

module "hello_get" {
  source      = "./api_method"
  rest_api_id = "${aws_api_gateway_rest_api.hello_api.id}"
  resource_id = "${aws_api_gateway_resource.hello_api_res_hello.id}"
  method      = "GET"
  path        = "${aws_api_gateway_resource.hello_api_res_hello.path}"
  lambda      = "${module.lambda.name}"
  region      = "${var.aws_region}"
  account_id  = "${data.aws_caller_identity.current.account_id}"
}

# This is the code for method POST /hello, that will talk to the second lambda
module "hello_post" {
  source      = "./api_method"
  rest_api_id = "${aws_api_gateway_rest_api.hello_api.id}"
  resource_id = "${aws_api_gateway_resource.hello_api_res_hello.id}"
  method      = "POST"
  path        = "${aws_api_gateway_resource.hello_api_res_hello.path}"
  lambda      = "${module.lambda_post.name}"
  region      = "${var.aws_region}"
  account_id  = "${data.aws_caller_identity.current.account_id}"
}

# We can deploy the API now! (i.e. make it publicly available)
resource "aws_api_gateway_deployment" "hello_api_deployment" {
  rest_api_id = "${aws_api_gateway_rest_api.hello_api.id}"
  stage_name  = "production"
  description = "Deploy methods: ${module.hello_get.http_method} ${module.hello_post.http_method}"
}

output "dev_url" {
  value = "https://${aws_api_gateway_deployment.hello_api_deployment.rest_api_id}.execute-api.${var.region}.amazonaws.com/${aws_api_gateway_deployment.hello_api_deployment.stage_name}/${aws_api_gateway_resource.hello_api_res_hello.path_part}"
}
