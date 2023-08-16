# Serverless To Do REST API

This project is a serverless REST API for a To Do App. It is built using AWS Cloud Development Kit (CDK) with the following AWS services:

1. AWS REST API Gateway
2. AWS Lambda
3. AWS Cognito User Pool
4. AWS DynamoDB

AWS CDK is an open-source software development framework for defining cloud infrastructure as code with modern programming languages and deploying it through AWS CloudFormation.

## Project Status

|Feature|Status  |
|--|--|
|CRUD on models|Completed  |
|Endpoint secured via Cognito|Completed  |
|Display results in JSON | Completed
| Deployed on AWS| Completed


## Useful commands
This project does not run locally, it requires CDK CLI to deploy it onto AWS.
Guide on installing CDK CLI is [available here.](https://docs.aws.amazon.com/cdk/v2/guide/cli.html)

 * `mvn package`     compile and run tests
 * `cdk ls`          list all stacks in the app
 * `cdk synth`       emits the synthesized CloudFormation template
 * `cdk deploy`      deploy this stack to default AWS account/region
 * `cdk diff`        compare deployed stack with current state
 * `cdk docs`        open CDK documentation


## Notes on the API Gateway

### Securing the API Gateway

1. Endpoint is secured using AWS Cognito User Pool
2. By default, ID token is used as part of Authentication bearer token. 
3. Access token can be used however it requires a custom client scope set in Cognito

For Testing Purpose
1. Client Credentials flow is set up to easily retrieve token
2. This requires custom client scope hence, access token is used

Reference: https://docs.aws.amazon.com/apigateway/latest/developerguide/apigateway-enable-cognito-user-pool.html

## Reflection
Cloud computing is ubiquitous, and AWS is one of the leaders in this space. Some firms are using serverless approach to cut out complexity in handling their technology pipeline. As a developer, it is important to keep myself updated with what's happening in the space. 

Developing a serverless application is a completely different paradigm. One has to think in terms of services when it comes to application design. Building it out on the cloud also requires a certain level of knowledge of the services these cloud computing providers have.

These lambda functions were written in vanilla Java. Some of these functions are tedious and verbose. As a Spring framework developer, I appreciate what the Spring framework does by creating common classes or simplifying common patterns through the use of annotations.

The other challenge faced was that Java is not a popular language when it comes to lambda and AWS CDK. Finding resources or guides was challenging but the AWS guides were well-written and sufficient. 

Reason for choosing AWS amongst other cloud providers was to aid my learning for my AWS certifications. The use of CDK is pretty awesome for lack of a better word. It is similar to Terraform or other Code as a Infrastructure product. I created an entirely serverless REST API with authentication using lines of code. CDK is based on AWS Cloudformation. 

#### Tools used 
1. Postman  - to test the endpoints
2. Intellij IDE


curl --location 'https://8u93ded9o0.execute-api.us-east-1.amazonaws.com/dev/todo' \
--header 'Content-Type: application/json' \
--header 'Authorization: Bearer eyJraWQiOiJIM2JOYXBQZzg2VWN1eHBwMmttOVRtN1dmXC9UQTM1XC9obXRnbG43MWs4TTQ9IiwiYWxnIjoiUlMyNTYifQ.eyJzdWIiOiIwMTdmMjU4NS02NzFmLTQ4MWItYTIzYS0xOTBmN2U3MzhkMGEiLCJlbWFpbF92ZXJpZmllZCI6ZmFsc2UsImlzcyI6Imh0dHBzOlwvXC9jb2duaXRvLWlkcC51cy1lYXN0LTEuYW1hem9uYXdzLmNvbVwvdXMtZWFzdC0xX3RyOENJVnRrOSIsImNvZ25pdG86dXNlcm5hbWUiOiIwMTdmMjU4NS02NzFmLTQ4MWItYTIzYS0xOTBmN2U3MzhkMGEiLCJvcmlnaW5fanRpIjoiNDg2NWUzZGQtMjczMS00ODkxLWJkNWItNDRmMjIyMDczMGJiIiwiYXVkIjoiNGhrcmZvOXZicTcwMWY4Y3M1OWdkN3I3a2giLCJldmVudF9pZCI6ImZkNjJlZjhhLWZlNmMtNDM2OC1hMWQ4LWY3OGMwYzFiMGE0MSIsInRva2VuX3VzZSI6ImlkIiwiYXV0aF90aW1lIjoxNjkxODkzMDM1LCJuYW1lIjoiSmVpc3NvbiBQYWxhY2lvIiwiZXhwIjoxNjkxODk2NjM1LCJpYXQiOjE2OTE4OTMwMzUsImp0aSI6IjA0OTRiZDk2LWM3ZTItNDYxNy04Nzc2LTYwYmIwYTUxMTM4ZiIsImVtYWlsIjoieWVpYW5kcmVzNTZAZ21haWwuY29tIn0.eirFZyv4pW5nK1WO2cvgt1aeXRLQgTWNWVWiuiVm1nPiIWboufL9dhHVe56K95ccNzSFDqOygRRJPyONFFSWpeHUXseNDfZf8CUb4rxYRSg7n7XNrmS78eI4z4UuYZbuY1eb6NElGC171DgCTzsebtji0IlutBH1P3hen8gdhmkFlKf80bMhLzmqzCaGl5Y0qoMUpewJGXw3yde2K8N-XT5mO-ZXZ70A3WcDXuwhXbY02SHlHXeUhxYtJvL4SgXfFaAOt6KmkubYiFJQ0M1A-mMR7m3HSkJ1T2vbzog9uw8swhV7cmPR59_an_pEMJTalsQLPCAtl3TtTu5qhsE1cQ' \
--data '{
"id": 1,
"description": "Comprar leche",
"priority": 1,
"dueDate": "2022-12-31"
}'