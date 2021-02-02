# OPG Metrics

## Integration and Mocking

Within the solution we have provided a [OpenAPI specification](/terraform/environment/api/openapi_spec.json) and an [example JSON packet](/terraform/environment/api/examples/put_metrics.json) for help in understanding the integration.

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


The Office of the Public Guardian metrics service: Managed by opg-org-infra &amp; Terraform

Building a new metrics service for OPG.
