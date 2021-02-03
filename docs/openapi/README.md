# OpenAPI

The OPG Metrics Service allows you to send a PUT request to a endpoint with a JSON package in the body to record data. You don't have to use this point of entry however, the service is designed in a way that should you choose to, you can integrate directly with the Timestream database or the Kinesis Data Stream.

Within the solution we have provided a [OpenAPI specification](/terraform/environment/api/openapi_spec.json) and an [example JSON packet](/terraform/environment/api/examples/put_metrics.json) for help in understanding the integration.

## Documentation

Upon a merge into `main` a Github Action will build and publish HTML documentation to github pages. This can be found here [https://ministryofjustice.github.io/opg-metrics/](https://ministryofjustice.github.io/opg-metrics/).

## Integration and Mocking

This OpenAPI specification can be used to build out a Mock service of your choosing. Below is an example using Prism.

You can run the Docker version of prism as part of your `docker-compose`.

```
metrics-api:
    image: stoplight/prism:latest
    ports:
      - 4010:4010
    command:
      - mock
      - https://github.com/ministryofjustice/opg-metrics/tree/main/terraform/environment/api/openapi_spec.json
      - -h
      - 0.0.0.0
      - --dynamic
```
