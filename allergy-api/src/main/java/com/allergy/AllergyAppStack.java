package com.allergy;

import com.amazonaws.HttpMethod;
import com.allergy.lambda.*;
import software.amazon.awscdk.*;
import software.amazon.awscdk.Stack;
import software.amazon.awscdk.services.apigateway.Resource;
import software.amazon.awscdk.services.apigateway.*;
import software.amazon.awscdk.services.cognito.*;
import software.amazon.awscdk.services.dynamodb.*;

import software.amazon.awscdk.services.lambda.Code;
import software.amazon.awscdk.services.lambda.Function;
import software.amazon.awscdk.services.lambda.FunctionProps;
import software.amazon.awscdk.services.lambda.Runtime;
import software.constructs.Construct;
import software.constructs.IConstruct;

import java.util.*;

public class AllergyAppStack extends Stack {

    private List<IConstruct> constructList = new ArrayList<>();

    public AllergyAppStack(final Construct scope, final String id) {
        this(scope, id, null,null);
    }

    public AllergyAppStack(final Construct scope, final String id, final StackProps props, final Properties properties) {
        super(scope, id, props);

        Table dynamodbTable = createDynamoDB();

        // Setting up of lambda functions
        Map<String, String> lambdaEnvMap = new HashMap<>();
        lambdaEnvMap.put("TABLE_NAME", dynamodbTable.getTableName());
        lambdaEnvMap.put("PRIMARY_KEY", "id");

        // Declaring of Lambda functions, handler name must be same as name of class
        Function createToDoFunction = new Function(this, CreateAllergy.class.getSimpleName(),
                getLambdaFunctionProps(lambdaEnvMap, CreateAllergy.class.getName(), "Create Allergy"));

        Function getAllToDoFunction = new Function(this, GetAllAllergy.class.getSimpleName(),
                getLambdaFunctionProps(lambdaEnvMap, GetAllAllergy.class.getName(), "Get All Allergy"));

        Function getAllByIdToDoFunction = new Function(this, GetAllByUserId.class.getSimpleName(),
                getLambdaFunctionProps(lambdaEnvMap, GetAllByUserId.class.getName(), "Get Allergy By UserId"));

        Function getOneToDoFunction = new Function(this, GetOneAllergy.class.getSimpleName(),
                getLambdaFunctionProps(lambdaEnvMap, GetOneAllergy.class.getName(), "Get One Allergy"));

        Function updateToDoFunction = new Function(this, UpdateAllergy.class.getSimpleName(),
                getLambdaFunctionProps(lambdaEnvMap, UpdateAllergy.class.getName(), "Update Allergy"));

        Function deleteToDoFunction = new Function(this, DeleteAllergy.class.getSimpleName(),
                getLambdaFunctionProps(lambdaEnvMap, DeleteAllergy.class.getName(), "Delete Allergy"));

        dynamodbTable.grantFullAccess(createToDoFunction);
        dynamodbTable.grantFullAccess(getAllToDoFunction);
        dynamodbTable.grantFullAccess(getOneToDoFunction);
        dynamodbTable.grantFullAccess(updateToDoFunction);
        dynamodbTable.grantFullAccess(deleteToDoFunction);
        dynamodbTable.grantFullAccess(getAllByIdToDoFunction);

        IUserPool userPool =  UserPool.fromUserPoolArn(this, "userPool",properties.getProperty("user_pool") );

        CognitoUserPoolsAuthorizer authorizer = new CognitoUserPoolsAuthorizer(
                this,
                "AllergyCognitoAuthorizer",
                CognitoUserPoolsAuthorizerProps.builder()
                        .cognitoUserPools(
                                List.of(
                                        userPool
                                )
                        )
                        .authorizerName("todo-cognito-authorizer")
                        .build());


        LambdaRestApi api = createApiGateway(authorizer, getAllToDoFunction);

        //Set resource path: https://api-gateway/allergy
        Resource todo = api.getRoot().addResource("allergy");

        // HTTP GET https://api-gateway/allergy
        //Endpoint is secured and requires token to call.
        todo.addMethod(HttpMethod.GET.name(), new LambdaIntegration(getAllByIdToDoFunction));


        // HTTP POST https://api-gateway/allergy
        todo.addMethod(HttpMethod.POST.name(), new LambdaIntegration(createToDoFunction));

        //Set {ID} path: https://api-gateway/allergy/{ID}
        Resource todoId = todo.addResource("{id}");

        todoId.addMethod(HttpMethod.GET.name(), new LambdaIntegration(getOneToDoFunction));
        todoId.addMethod(HttpMethod.DELETE.name(), new LambdaIntegration(deleteToDoFunction));
        todoId.addMethod(HttpMethod.PATCH.name(), new LambdaIntegration(updateToDoFunction));

        constructList.add(dynamodbTable);
        constructList.add(userPool);
        constructList.add(authorizer);
        constructList.add(api);
        constructList.add(createToDoFunction);
        constructList.add(getAllToDoFunction);
        constructList.add(getOneToDoFunction);
        constructList.add(updateToDoFunction);
        constructList.add(deleteToDoFunction);
        addTags(constructList);
    }



    private FunctionProps getLambdaFunctionProps(Map<String, String> lambdaEnvMap, String handler, String description) {
        return FunctionProps.builder()
                //Note: Use of Maven Shade plugin to include dependency JARs into final jar file
                .code(Code.fromAsset("./target/todo-api-0.1.jar"))
                .handler(handler)
                .runtime(Runtime.JAVA_11)
                .environment(lambdaEnvMap)
                .timeout(Duration.seconds(30))
                .memorySize(512)
                .description(description)
                .build();
    }

    /**
     * @return
     */
    private Table createDynamoDB() {
        //DynamoDB Partition(Primary) Key
        Attribute partitionKey = Attribute.builder()
                .name("id")
                .type(AttributeType.STRING)
                .build();

        TableProps tableProps = TableProps.builder()
                .tableName("Allergy")
                .partitionKey(partitionKey)
                // The default removal policy is RETAIN, which means that cdk destroy will not attempt to delete
                // the new table, and it will remain in your account until manually deleted. By setting the policy to
                // DESTROY, cdk destroy will delete the table (even if it has data in it)
                .removalPolicy(RemovalPolicy.DESTROY)
//                .removalPolicy(RemovalPolicy.RETAIN)
                .readCapacity(1)
                .writeCapacity(1)
                .billingMode(BillingMode.PROVISIONED)
                .build();

        return new Table(this, "AllergyTable", tableProps);
    }

    /**
     * @return
     */
    private CognitoUserPoolsAuthorizer createCognitoAuthorizer(UserPoolClient userPoolClient) {
        //Below code will create a new UserPool
        //UserPool userPool = new UserPool(this, "userPool");
        //However, we want to use an existing UserPool in our dev env

        IUserPool userPool = UserPool.fromUserPoolId(this, userPoolClient.getUserPoolClientName(), userPoolClient.getUserPoolClientId());

        //Declare a Cognito Authorizer to secure endpoint
        return CognitoUserPoolsAuthorizer.Builder
                .create(this, "AllergyCognitoAuthorizer")
                .cognitoUserPools(
                        List.of(userPool)
                )
                .authorizerName("todo-cognito-authorizer")
                .build();
    }

    /**
     * Requires ID Token to get access.
     * Access Token with Custom Scope can be used. Refer to:
     * https://stackoverflow.com/questions/50404761/aws-api-gateway-using-access-token-with-cognito-user-pool-authorizer
     * This custom-scope added is only available for token retrieved via
     *
     * @param authorizer
     * @param getAllToDoFunction
     * @return
     */
    private LambdaRestApi createApiGateway(CognitoUserPoolsAuthorizer authorizer, Function getAllToDoFunction) {

        return LambdaRestApi.Builder.create(this, "ApiGateway Allergy")
                .restApiName("Allergy REST API Gateway")
                .description("REST API Gateway for Allergy backend")
                .deployOptions(
                        StageOptions.builder()
                                .stageName("dev")
                                .description("For Development Environment")
                                .build()
                )
                .defaultMethodOptions(
                        MethodOptions.builder()
                                .authorizer(authorizer)
                                .authorizationType(AuthorizationType.COGNITO)
                                .build()
                )
                .handler(getAllToDoFunction)
                .build();
    }

    private void createApiGatewayNotCognito(){

    }
    private void addTags(List<IConstruct> constructList) {
        constructList.forEach(construct -> {
                    Tags.of(construct).add("project", "AllergyApp");
                    Tags.of(construct).add("environment", "dev");
                }
        );
    }


    private void cognito(){

        UserPool userPool = UserPool.Builder.create(this,"awesome-cognito-user-pool")
                .accountRecovery(AccountRecovery.EMAIL_ONLY)
                .removalPolicy(RemovalPolicy.DESTROY)
                .build();

        ResourceServerScope resourceServerScope = ResourceServerScope.Builder.create()
                .scopeName("awesomeapi.read")
                .scopeDescription("awesomeapi read scope")
                .build();

        // create UserPoolResourceServer
        UserPoolResourceServer userPoolResourceServer = UserPoolResourceServer.Builder.create(this, "awesome-resource-server")
                .identifier("awesomeapi-resource-server")
                .userPool(userPool)
                .scopes(List.of(resourceServerScope))
                .build();


        UserPoolClient userPoolClient = UserPoolClient.Builder.create(this, "awesome-user-pool-client")
                .userPool(userPool)
                .accessTokenValidity(Duration.minutes(60))
                .generateSecret(true)
                .refreshTokenValidity(Duration.days(1))
                .enableTokenRevocation(true)
                .oAuth(OAuthSettings.builder()
                        .flows(
                                OAuthFlows.builder()
                                        .clientCredentials(true)
                                        .build()
                        )
                        .scopes(List.of(OAuthScope.resourceServer(userPoolResourceServer, resourceServerScope)))
                        .build())
                .build();


        CognitoDomainOptions domainOptions = CognitoDomainOptions.builder()
                .domainPrefix("buraktas-awesome-domain-account")
                .build();

        UserPoolDomain userPoolDomain =  UserPoolDomain.Builder.create(this,"awesome-cognito-domain")
                .userPool(userPool)
                .cognitoDomain(domainOptions)
                .build();

    }

    private void cognitoNow(){


        UserPool userPool = UserPool.Builder.create(this, "MyUserPool")
                .userPoolName("my-user-pool")
                .passwordPolicy(
                        PasswordPolicy.builder()
                                .minLength(6)
                                .requireLowercase(false)
                                .requireDigits(true)
                                .requireSymbols(false)
                                .requireUppercase(true)
                                .build()
                )
                .standardAttributes(
                        StandardAttributes.builder()

                                .email(StandardAttribute.builder()
                                        .required(true)
                                        .build()
                                )
                                .build()
                )

                .build();

        UserPoolClient userPoolClient = UserPoolClient.Builder.create(this, "MyUserPoolClient")
                .userPool(userPool)
                .userPoolClientName("my-user-pool-client")
                .authFlows(AuthFlow.builder()
                        .build())

                .oAuth(OAuthSettings.builder()
                        .callbackUrls(List.of("https://aws.amazon.com/"))
                        .build())
                .build();


        // domainPrefix "book-api-${Stage}-${AWS::AccountId}"
        CognitoDomainOptions domainOptions = CognitoDomainOptions.builder()
                .domainPrefix("todo-api-dev-account")
                .build();


        UserPoolDomain userPoolDomain =  UserPoolDomain.Builder.create(this,"userPoolDomain")
                .userPool(userPool)
                .cognitoDomain(domainOptions)
                .build();


        CognitoUserPoolsAuthorizer authorizer = createCognitoAuthorizer(userPoolClient);

    }

// https://github.com/ddzmitry/100days-of-codeV2
}
