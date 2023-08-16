package com.allergy;

import software.amazon.awscdk.App;
import software.amazon.awscdk.Environment;
import software.amazon.awscdk.StackProps;

import java.io.IOException;
import java.util.Properties;

public class AllergyApp {
    public static void main(final String[] args) {
        App app = new App();

        Properties props = getProperties();

        String region = props.getProperty("region");
        String account = props.getProperty("account");

        new AllergyAppStack(app, "AllergyAppStack", StackProps.builder()

                .env(Environment.builder()
                        .account(account)
                        .region(region)
                        .build())
                .build(),props);

        app.synth();
    }

    public static Properties getProperties() {
        Properties props = new Properties();
        try {
            props.load(AllergyApp.class.getResourceAsStream("/application.properties"));
        } catch (IOException e) {
            throw new RuntimeException("Failed to load properties file.");
        }
        return props;
    }

}

