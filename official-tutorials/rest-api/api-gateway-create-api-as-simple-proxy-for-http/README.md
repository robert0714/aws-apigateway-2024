# Tutorial: Create a REST API with an HTTP proxy integration
* reference:
  * https://docs.aws.amazon.com/zh_tw/apigateway/latest/developerguide/api-gateway-create-api-as-simple-proxy-for-http.html
  * https://docs.aws.amazon.com/serverless-application-model/latest/developerguide/sam-resource-api.html

## Usage
### Deployment
In a shell, navigate to the sample's folder and use the SAM CLI to build a deployable package
```bash
## Using aws sam

$ sam deploy --s3-bucket $CF_BUCKET \
   --stack-name api-gateway-create-api-as-simple-proxy-for-http \
   --capabilities CAPABILITY_IAM

## Using aws cloudformation
$ aws cloudformation create-stack \
    --stack-name api-gateway-create-api-as-simple-proxy-for-http \
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

Alternatively, you can tear down the stack from the command line. For example, to tear down the **api-gateway-create-api-as-simple-proxy-for-http** stack, run the following:
```bash
$ PIPELINE_BUCKET="$(aws cloudformation describe-stack-resource --stack-name api-gateway-create-api-as-simple-proxy-for-http --logical-resource-id PipelineStartBucket --query 'StackResourceDetail.PhysicalResourceId' --output text)" 
$ aws s3 rm s3://${PIPELINE_BUCKET} --recursive
$ aws cloudformation delete-stack --stack-name api-gateway-create-api-as-simple-proxy-for-http

$ tofu destroy
```

# SAM LOCAL
## Ready
```bash
vagrant up
vagrant ssh
sudo apt install -y wget unzip


curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
sudo ./aws/install
aws --version

wget https://github.com/aws/aws-sam-cli/releases/latest/download/aws-sam-cli-linux-x86_64.zip
unzip aws-sam-cli-linux-x86_64.zip -d sam-installation
sudo ./sam-installation/install
sam --version
```
## Test in sam Local
```bash
cd /vagrant/official-tutorials/rest-api/api-gateway-create-api-as-simple-proxy-for-http/
sam local start-api
```
another terminal
```bash
vagrant@sam:~$ curl --location 'http://127.0.0.1:3000/test/petstore/pets?type=fish' \
--header 'Content-Type: application/json'  
```

In Postman, choose POST, the http://localhost:3000/test/petstore/pets?type=fish URL, and the JSON format input.
```json
[
  {
    "id": 1,
    "type": "fish",
    "price": 249.99
  },
  {
    "id": 2,
    "type": "fish",
    "price": 124.99
  },
  {
    "id": 3,
    "type": "fish",
    "price": 0.99
  }
]
```
