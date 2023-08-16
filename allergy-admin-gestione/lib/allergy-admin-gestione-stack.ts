import * as cdk from 'aws-cdk-lib';
import { Construct } from 'constructs';
// import * as sqs from 'aws-cdk-lib/aws-sqs';
import {Annotations, RemovalPolicy, Stack, StackProps} from "aws-cdk-lib";
import {
  ProviderAttribute,
  UserPool,
  UserPoolClientIdentityProvider,
  UserPoolIdentityProviderGoogle,
} from "aws-cdk-lib/aws-cognito";

import {StringParameter} from "aws-cdk-lib/aws-ssm";
import {BackendAPI} from "./api/BackendAPI/BackendAPI";
import {CustomUserPoolClient} from "./api/CustomUserPoolClient";
import {PublicEndpoint} from "./api/PublicEndpoint/PublicEndpoint";

export class AllergyAdminGestioneStack extends cdk.Stack {
  constructor(scope: Construct, id: string, props?: cdk.StackProps) {
    super(scope, id, props);
    const uniquePrefix = this.node.tryGetContext('prefix') as string;

    console.log("uniquePrefix: ", uniquePrefix);
    const googleClientId = this.node.tryGetContext('google-client-id') as string;
    const googleClientSecret = this.node.tryGetContext('google-client-secret') as string;

    if (!uniquePrefix) {
        Annotations.of(this).addError(`The context variable "prefix" is not defined. It is used as a unique prefix for your Cognito User Pool's Hosted UI domain and a few other things in the infrastructure. It needs to be defined and globally unique (just like S3 bucket names).`);
    }

    if (!googleClientId || !googleClientSecret) {
        Annotations.of(this).addError(`The context variable "google-client-id" or "google-client-secret" are not defined`);
    }

    const userPool = new UserPool(this, "UserPool", {
        removalPolicy: RemovalPolicy.DESTROY,
    });
    const userPoolDomain = userPool.addDomain("default", {
        cognitoDomain: {
            domainPrefix: uniquePrefix,
        },
    });

    new UserPoolIdentityProviderGoogle(this, "Google", {
        userPool,
        clientId: googleClientId,
        clientSecret: googleClientSecret,

        // Email scope is required, because the default is 'profile' and that doesn't allow Cognito
        // to fetch the user's email from his Google account after the user does an SSO with Google
        scopes: ["email"],

        // Map fields from the user's Google profile to Cognito user fields, when the user is auto-provisioned
        attributeMapping: {
            email: ProviderAttribute.GOOGLE_EMAIL,
        },
    });

    const backend = new BackendAPI(this, 'Backend', {
        uniquePrefix,
        userPool,
    });

    new PublicEndpoint(this, 'PublicEndpoint', {
        restApi: backend.api,
    });

    const client = new CustomUserPoolClient(this, "UserPoolClient", {
        userPool,
        supportedIdentityProviders: [UserPoolClientIdentityProvider.GOOGLE],
        oAuth: {
            callbackUrls: [backend.api.urlForPath("/public")],
        },
    });

    new StringParameter(this, "UserPoolClientId", {
        parameterName: `/${uniquePrefix}/userpool/client_id`,
        stringValue: client.userPoolClient.userPoolClientId,
    });
    new StringParameter(this, "UserPoolClientSecret", {
        parameterName: `/${uniquePrefix}/userpool/client_secret`,
        stringValue: client.userPoolClientSecret
    });
    new StringParameter(this, "UserPoolDomainPrefix", {
        parameterName: `/${uniquePrefix}/userpool/domain_prefix`,
        stringValue: userPoolDomain.domainName,
    });
    new StringParameter(this, "UserPoolRegion", {
        parameterName: `/${uniquePrefix}/userpool/region`,
        stringValue: Stack.of(userPool).region,
    });
    new StringParameter(this, "UserPoolClientCallbackURL", {
        parameterName: `/${uniquePrefix}/userpool/callback-url`,
        stringValue: backend.api.urlForPath("/public"),
    });

  }
}
