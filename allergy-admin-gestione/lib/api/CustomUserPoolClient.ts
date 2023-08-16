import { Construct } from 'constructs';
import { AwsCustomResource, AwsCustomResourcePolicy, PhysicalResourceId } from 'aws-cdk-lib/custom-resources';
import { UserPoolClient, UserPoolClientProps } from 'aws-cdk-lib/aws-cognito';
import { Stack } from 'aws-cdk-lib';

export class CustomUserPoolClient {
  userPoolClient: UserPoolClient;
  userPoolClientSecret: string;

  constructor(scope: Construct, id: string, props: UserPoolClientProps) {
    this.userPoolClient = new UserPoolClient(scope, id, {
      generateSecret: true,
      ...props,
    });

    const describeCognitoUserPoolClient = new AwsCustomResource(
      scope,
      'DescribeCognitoUserPoolClient',
      {
        resourceType: 'Custom::DescribeCognitoUserPoolClient',
        onCreate: {
          region: Stack.of(scope).region,
          service: 'CognitoIdentityServiceProvider',
          action: 'describeUserPoolClient',
          parameters: {
            UserPoolId: props.userPool.userPoolId,
            ClientId: this.userPoolClient.userPoolClientId,
          },
          physicalResourceId: PhysicalResourceId.of(this.userPoolClient.userPoolClientId),
        },
        policy: AwsCustomResourcePolicy.fromSdkCalls({
          resources: AwsCustomResourcePolicy.ANY_RESOURCE,
        }),
      }
    );

    this.userPoolClientSecret = describeCognitoUserPoolClient.getResponseField(
      'UserPoolClient.ClientSecret'
    );
  }
}