package com.allergy.models;

import com.amazonaws.services.dynamodbv2.datamodeling.DynamoDBAttribute;
import com.amazonaws.services.dynamodbv2.datamodeling.DynamoDBHashKey;
import com.amazonaws.services.dynamodbv2.datamodeling.DynamoDBTable;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.util.Date;

@Data
@Builder
@AllArgsConstructor
@NoArgsConstructor
@DynamoDBTable(tableName="Allergy")
public class Allergy {
    @DynamoDBHashKey
    private String id;

    @DynamoDBAttribute
    private String generalStatus;

    @DynamoDBAttribute
    private String status;

    @DynamoDBAttribute
    private Boolean inhaler;

    @DynamoDBAttribute
    private Double percentage;

    @DynamoDBAttribute
    private Double pm25;

    @DynamoDBAttribute
    private Date date;

    @DynamoDBAttribute
    private String cognito_sub;

    @DynamoDBAttribute
    private String cognito_username;

    @DynamoDBAttribute
    private String cognito_email;
}
