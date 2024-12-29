# Configure AWS Provider
provider "aws" {
  # Configure the AWS Provider
  # region = "us-east-1" # Change this to your desired region
}

# Create API Gateway REST API
resource "aws_api_gateway_rest_api" "http_proxy" {
  name        = "HTTPProxyAPI"
  description = "A simple API with HTTP proxy integration"

  endpoint_configuration {
    types = ["REGIONAL"]
  }
}

# Create API Gateway Resource
resource "aws_api_gateway_resource" "proxy" {
  rest_api_id = aws_api_gateway_rest_api.http_proxy.id
  parent_id   = aws_api_gateway_rest_api.http_proxy.root_resource_id
  path_part   = "{proxy+}"
}

# Create API Gateway Method
resource "aws_api_gateway_method" "proxy" {
  rest_api_id   = aws_api_gateway_rest_api.http_proxy.id
  resource_id   = aws_api_gateway_resource.proxy.id
  http_method   = "ANY"
  authorization = "NONE"

  request_parameters = {
    "method.request.path.proxy" = true
  }
}

# Create API Gateway Integration
resource "aws_api_gateway_integration" "proxy" {
  rest_api_id = aws_api_gateway_rest_api.http_proxy.id
  resource_id = aws_api_gateway_resource.proxy.id
  http_method = aws_api_gateway_method.proxy.http_method

  type                    = "HTTP_PROXY"
  integration_http_method = "ANY"
  uri                     = "http://petstore-demo-endpoint.execute-api.com/{proxy}"
  passthrough_behavior    = "WHEN_NO_MATCH"

  request_parameters = {
    "integration.request.path.proxy" = "method.request.path.proxy"
  }
}

# Create API Gateway Deployment
resource "aws_api_gateway_deployment" "test" {
  rest_api_id = aws_api_gateway_rest_api.http_proxy.id
  
  depends_on = [
    aws_api_gateway_method.proxy,
    aws_api_gateway_integration.proxy
  ]

  lifecycle {
    create_before_destroy = true
  }
}

# Create API Gateway Stage
resource "aws_api_gateway_stage" "test" {
  deployment_id = aws_api_gateway_deployment.test.id
  rest_api_id   = aws_api_gateway_rest_api.http_proxy.id
  stage_name    = "test"
}

# Output
output "api_url" {
  description = "The URL of the HTTP Proxy API Gateway"
  value       = "${aws_api_gateway_rest_api.http_proxy.execution_arn}/test/{proxy}"
}