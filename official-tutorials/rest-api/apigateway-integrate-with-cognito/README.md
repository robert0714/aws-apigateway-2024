# Control access to REST APIs using Amazon Cognito user pools as an authorizer
* reference:
  * https://docs.aws.amazon.com/apigateway/latest/developerguide/apigateway-integrate-with-cognito.html
  * https://www.youtube.com/watch?v=LI31QxfAgho

## Usage
### Deployment
In a shell, navigate to the sample's folder and use the SAM CLI to build a deployable package
```bash
## Using aws sam

$ sam deploy --s3-bucket $CF_BUCKET \
   --stack-name apigateway-integrate-with-cognito \
   --capabilities CAPABILITY_IAM

## Using aws cloudformation
$ aws cloudformation create-stack \
    --stack-name apigateway-integrate-with-cognito \
    --template-body file://cf-template.yml \
    --capabilities CAPABILITY_NAMED_IAM
```
#### Using Terraform
```bash
terraform init
terraform plan 
terraform apply 

//opensource of terraform
tofu init
tofu plan 
tofu validate 
tofu apply 
```

# TEARING DOWN RESOURCES
When you run `sam deploy`, it creates or updates a CloudFormation `stack`—a set of resources that has a name, which you’ve seen already with the `--stack-name` parameter of `sam deploy`.

When you want to clean up your AWS account after trying an example, the simplest method is to find the corresponding CloudFormation stack in the AWS Web Console (in the CloudFormation section) and delete the stack using the **Delete** button.

Alternatively, you can tear down the stack from the command line. For example, to tear down the **apigateway-integrate-with-cognito** stack, run the following:
```bash
$ PIPELINE_BUCKET="$(aws cloudformation describe-stack-resource --stack-name apigateway-integrate-with-cognito --logical-resource-id PipelineStartBucket --query 'StackResourceDetail.PhysicalResourceId' --output text)" 
$ aws s3 rm s3://${PIPELINE_BUCKET} --recursive
$ aws cloudformation delete-stack --stack-name apigateway-integrate-with-cognito

$ tofu destroy
```
### References
* https://github.com/aws-samples/multiple-identity-providers-amazon-api-gateway
* https://github.com/aws-samples/amazon-cognito-api-gateway
* https://github.com/aws-samples/amazon-cognito-and-api-gateway-based-machine-to-machine-authorization-using-aws-cdk
* https://github.com/aws-samples/apigw-cognito-context
* https://github.com/aws-samples/amazon-cognito-and-api-gateway-based-machine-to-machine-authorization-using-aws-cdk
* https://github.com/aws-samples/http-api-gateway-jwt-cognito
* https://github.com/aws-samples/amazon-cognito-api-gateway