package com.allergy.lambda;

import com.amazonaws.services.lambda.runtime.Context;
import com.amazonaws.services.lambda.runtime.RequestHandler;
import com.amazonaws.services.lambda.runtime.events.APIGatewayV2HTTPEvent;
import com.amazonaws.services.lambda.runtime.events.APIGatewayV2HTTPResponse;

import java.util.HashMap;

public class HelloWorld implements RequestHandler<APIGatewayV2HTTPEvent, APIGatewayV2HTTPResponse> {
    //TODO: APIGatewayV2HTTPEvent vs APIGatewayProxyRequestEvent vs APIGatewayV2ProxyRequestEvent (Deprecated)
    //All 3 works
    //Source: https://georgemao.medium.com/demystifying-java-aws-lambda-handlers-for-api-gateway-c1e77b7e6a8d
    // APIGatewayV2HTTPEvent for HTTP API Gateway ( Payload 2.0)
    // APIGatewayProxyRequestEvent for HTTP API Gateway ( Payload 1.0)
    // APIGatewayProxyRequestEvent for REST API Gateway


//    Gson gson = new GsonBuilder().setPrettyPrinting().create();
//    @Override
//    public String handleRequest(Map<String,String> event, Context context)
//    {
//        LambdaLogger logger = context.getLogger();
//
//        String response = new String("200 OK");
//        // log execution details
////        logger.log("ENVIRONMENT VARIABLES: " + gson.toJson(System.getenv()));
////        logger.log("CONTEXT: " + gson.toJson(context));
////        // process event
////        logger.log("EVENT: " + gson.toJson(event));
////        logger.log("EVENT TYPE: " + event.getClass().toString());
//        return response;
//    }

//    @Override
//    public APIGatewayV2HTTPResponse handleRequest(APIGatewayV2HTTPEvent apiGatewayV2HTTPEvent, Context context) {
//        APIGatewayV2HTTPResponse apiGatewayV2HTTPResponse = new APIGatewayV2HTTPResponse();
//        apiGatewayV2HTTPResponse.setBody("BODY");
//        apiGatewayV2HTTPResponse.setStatusCode(200);
//        return apiGatewayV2HTTPResponse;
//    }

//    @Override
//    public APIGatewayProxyResponseEvent handleRequest(APIGatewayProxyRequestEvent apiGatewayProxyRequestEvent, Context context) {
//        APIGatewayProxyResponseEvent response = new APIGatewayProxyResponseEvent();
//        response.setIsBase64Encoded(false);
//        response.setStatusCode(200);
//        HashMap<String, String> headers = new HashMap<String, String>();
//        headers.put("Content-Type", "text/html");
//        response.setHeaders(headers);
//        response.setBody("<!DOCTYPE html><html><head><title>Hello World</title></head><body>"+
//                "<h1>Hello World - APIGatewayProxyResponseEvent</h1><p>Page generated by a Lambda function.</p>" +
//                "</body></html>");
//        // log execution details
//        return response;
//    }

    @Override
    public APIGatewayV2HTTPResponse handleRequest(APIGatewayV2HTTPEvent apiGatewayV2HTTPEvent, Context context) {
        APIGatewayV2HTTPResponse response = new APIGatewayV2HTTPResponse();
        response.setIsBase64Encoded(false);
        response.setStatusCode(200);
        HashMap<String, String> headers = new HashMap<String, String>();
        headers.put("Content-Type", "text/html");
        response.setHeaders(headers);
        response.setBody("<!DOCTYPE html><html><head><title>Hello World</title></head><body>"+
                "<h1>Hello World - APIGatewayV2HTTPResponse</h1><p>Page generated by a Lambda function.</p>" +
                "</body></html>");
        // log execution details
        return response;
    }
}