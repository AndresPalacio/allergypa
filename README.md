<h1 align="center">
  Allergyap
  <br>
</h1>

<h4 align="center"><a href="#" target="_blank">Allergypa,</a> is Serverless App With Flutter entirely using AWS services and adheres to established best practices.</h4>

[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](https://opensource.org/licenses/MIT)

<p align="center">
 <a href="#folder-structure">Folder Structure</a> •
  <a href="#key-features">Services Used</a> •
  <a href="#how-to-use">How To Use</a> •
  <a href="#architecture">Architecture</a> •
  <a href="#documentation">Documentation</a> •
  <a href="#you-may-also-like">Related</a> •
  <a href="#license">License</a>
</p>

## Folder Structure
This project contains source code for a serverless that can be deployed using the serverless framework. It also contains frontend code built using Next.js that can also be easily deployed or run locally. Also added are the architecture diagrams for the project.

- [admin](https://github.com/AndresPalacio/allergypa/tree/master/admin) - Admin code for the application.
- [allergy-architecture](https://github.com/AndresPalacio/allergypa/tree/master/architecture) - Contains architectural diagram and workflows for the application
- [backend-cognito](https://github.com/AndresPalacio/allergypa/tree/master/serverless-new-backend) - Contains the backend/serverless portion of the application built using the serverless framework
- [backend-java](https://github.com/AndresPalacio/allergypa/tree/master/todo-rest-api) - Contains the backend java 

## Services Used

The application utilizes the event driven architecure and is built using AWS services powered by the serverless framework. The following are the AWS services explicitly used

- Amazon S3
- Amazon DynamoDB
- AWS Lambda
- Amazon API Gateway
- Amazon Cognito
- AWS CloudFormation
- AWS STS

## How To Use

To clone and run this application, you'll need [Git](https://git-scm.com) and [Node.js](https://nodejs.org/en/download/) v16+ (which comes with [npm](http://npmjs.com)) installed on your computer. Also create an account with AWS, install the AWS CLI in locally, create an IAM user and add this user to AWS CLI as a profile. This profile user should have necessary permissions to deploy the backend section to AWS. Next, add required credentials to the .env file created from the command below. From your command line:

```bash
# Clone this repository
$ git clone https://github.com/AndresPalacio/allergypa/tree/master

# Go into the repository
$ cd allergypa

# Copy environment variable

# Deploy backend (run from folder root)
$ npm i serverless -g
$ cd serverless-backend && npm i && serverless deploy


# Run Admin (run from folder root)
$ cd admin && npm i && npm run dev


```
## Architecture

## Documentation

You can find an article that explains the project [here](https://github.com/AndresPalacio/allergypa)


## License

MIT

---
> LinkedIn [@jeisson-palacio](https://www.linkedin.com/in/jeisson-palacio/)



### Create a test user
In order to test the application, you will need a test-user in your Cognito User Pool. You can create a user by going to the User Pool directly in the AWS Console or you can run the following two CLI commands (which requires AWS credentials with the right permissions):
```shell
aws cognito-idp admin-create-user --user-pool-id <your_user_pool_id> --username <your_user_id>
```
```shell
aws cognito-idp admin-set-user-password --user-pool-id <your_user_pool_id> --username <your_user_id> --password <your_password> --permanent
``` 

exmaple


aws cognito-idp sign-up --client-id <your_cliend_id> --username correoadmin@gmail.com --password Prueba1234* --user-attributes Name="email",Value="correoadmin@gmail.com" Name="name",Value="Jeisson Palacio" --region us-east-1 --profile default

aws cognito-idp admin-confirm-sign-up --user-pool-id <your_pool_id> --username correoadmin@gmail.com --region us-east-1

- Create a new Cognito user pool:

`aws cognito-idp create-user-pool --pool-name {{name}}`

- List all user pools:

`aws cognito-idp list-user-pools --max-results {{10}}`

- Delete a specific user pool:

`aws cognito-idp delete-user-pool --user-pool-id {{user_pool_id}}`

- Create a user in a specific pool:

`aws cognito-idp admin-create-user --username {{username}} --user-pool-id {{user_pool_id}}`

- List the users of a specific pool:

`aws cognito-idp list-users --user-pool-id {{user_pool_id}}`

- Delete a user from a specific pool:

`aws cognito-idp admin-delete-user --username {{username}} --user-pool-id {{user_pool_id}}`


