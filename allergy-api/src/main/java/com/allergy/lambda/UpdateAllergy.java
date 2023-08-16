package com.allergy.lambda;

import com.amazonaws.regions.Regions;
import com.amazonaws.services.dynamodbv2.AmazonDynamoDB;
import com.amazonaws.services.dynamodbv2.AmazonDynamoDBClientBuilder;
import com.amazonaws.services.dynamodbv2.datamodeling.DynamoDBMapper;
import com.amazonaws.services.dynamodbv2.datamodeling.DynamoDBMapperConfig;
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

public class UpdateAllergy implements RequestHandler<APIGatewayProxyRequestEvent, APIGatewayProxyResponseEvent> {

    private Regions REGION = Regions.US_EAST_1;

    @Override
    public APIGatewayProxyResponseEvent handleRequest(APIGatewayProxyRequestEvent request, Context context) {
        Gson gson = new Gson();
        LambdaLogger logger = context.getLogger();
        logger.log("APIGatewayProxyRequestEvent::" + request.toString());

        DynamoDBMapper mapper = getDynamoDB();

        final String id = request.getPathParameters().get("id");
        Allergy requestAllergy = gson.fromJson(request.getBody(), Allergy.class);

        APIGatewayProxyResponseEvent responseEvent = new APIGatewayProxyResponseEvent();

        try {
            Allergy allergy = mapper.load(Allergy.class, id);
            allergy.setPm25(requestAllergy.getPm25());
            allergy.setPercentage(requestAllergy.getPercentage());

            mapper.save(allergy,
                    DynamoDBMapperConfig.builder()
                            .withSaveBehavior(DynamoDBMapperConfig.SaveBehavior.UPDATE_SKIP_NULL_ATTRIBUTES)
                            .build());
            responseEvent.setStatusCode(HttpStatus.SC_OK);

            Allergy newAllergy = mapper.load(Allergy.class, id);
            responseEvent.setBody(gson.toJson(newAllergy));
        } catch (Exception e) {
            logger.log(e.getMessage());
            responseEvent.setStatusCode(HttpStatus.SC_BAD_REQUEST);
        }

        //Setting headers
        HashMap<String, String> header = new HashMap<>();
        header.put(HttpHeaders.CONTENT_TYPE, "application/json");
        responseEvent.setHeaders(header);
        return responseEvent;
    }

    private DynamoDBMapper getDynamoDB() {
        //Initializing db settings
        AmazonDynamoDB client = AmazonDynamoDBClientBuilder.standard()
                .withRegion(REGION)
                .build();
        return new DynamoDBMapper(client);
    }
}
