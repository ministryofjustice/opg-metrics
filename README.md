# OPG Metrics

## Integration and Mocking

Within the solution we have provided a swagger doc and example packet for help in understanding the integration.

This swagger document can be used to build out a Mock service of your choosing. Below is an example using Prism.

To install Prism locally run

`npm install -g @stoplight/prism-cli`

Then from the root of the package run

`prism mock terraform/environment/api/swagger.json`

This will bring up a new API for you to test against locally.

Alternatively you can run a Docker version as part of your `docker-compose`.

```
sirius-api:
    image: stoplight/prism:latest
    ports:
      - 4010:4010
    command:
      - mock
      - https://github.com/ministryofjustice/opg-metrics/tree/main/terraform/environment/api/swagger.json
      - -h
      - 0.0.0.0
      - --dynamic
```


The Office of the Public Guardian metrics service: Managed by opg-org-infra &amp; Terraform

Building a new metrics service for OPG.
