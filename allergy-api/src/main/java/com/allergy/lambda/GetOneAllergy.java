package com.allergy.lambda;

import com.amazonaws.regions.Regions;
import com.amazonaws.services.dynamodbv2.AmazonDynamoDB;
import com.amazonaws.services.dynamodbv2.AmazonDynamoDBClientBuilder;
import com.amazonaws.services.dynamodbv2.datamodeling.DynamoDBMapper;
import com.amazonaws.services.lambda.runtime.Context;
import com.amazonaws.services.lambda.runtime.LambdaLogger;
import com.amazonaws.services.lambda.runtime.RequestHandler;
import com.amazonaws.services.lambda.runtime.events.APIGatewayProxyRequestEvent;
import com.amazonaws.services.lambda.runtime.events.APIGatewayProxyResponseEvent;
import com.google.gson.Gson;
import com.allergy.models.Allergy;
import org.apache.http.HttpHeaders;
import org.apache.http.HttpStatus;

import java.util.HashMap;

public class GetOneAllergy implements RequestHandler<APIGatewayProxyRequestEvent, APIGatewayProxyResponseEvent> {
    // APIGatewayV2HTTPEvent for HTTP API Gateway (Payload 2.0)
    // APIGatewayProxyRequestEvent for HTTP API Gateway (Payload 1.0)
    // APIGatewayProxyRequestEvent for REST API Gateway
    //Source: https://georgemao.medium.com/demystifying-java-aws-lambda-handlers-for-api-gateway-c1e77b7e6a8d
    private Regions REGION = Regions.US_EAST_1;

    @Override
    public APIGatewayProxyResponseEvent handleRequest(APIGatewayProxyRequestEvent requestEvent, Context context) {
        Gson gson = new Gson();
        LambdaLogger logger = context.getLogger();
        logger.log("APIGatewayProxyRequestEvent::" + requestEvent.toString());

        DynamoDBMapper mapper = getDynamoDB();

        final String id = requestEvent.getPathParameters().get("id");

        Allergy allergy = mapper.load(Allergy.class, id);
        logger.log("ToDo Retrieved: "+ allergy.toString());

        APIGatewayProxyResponseEvent response = new APIGatewayProxyResponseEvent();
        response.setStatusCode(HttpStatus.SC_OK);
        response.setBody(gson.toJson(allergy));
        HashMap<String, String> header = new HashMap<>();
        header.put(HttpHeaders.CONTENT_TYPE,"application/json");
        response.setHeaders(header);
        return response;
    }

    private DynamoDBMapper getDynamoDB() {
        //Initializing db settings
        AmazonDynamoDB client = AmazonDynamoDBClientBuilder.standard()
                .withRegion(REGION)
                .build();
        return new DynamoDBMapper(client);
    }
}
