![path_to_live_workflow](https://github.com/ministryofjustice/opg-metrics/actions/workflows/path_to_live_workflow.yml/badge.svg)
![path_to_live_workflow](https://img.shields.io/github/license/ministryofjustice/opg-metrics.svg)
[![pre-commit](https://img.shields.io/badge/pre--commit-enabled-brightgreen?logo=pre-commit&logoColor=white)](https://github.com/pre-commit/pre-commit)
[![pre-commit](https://github.com/ministryofjustice/opg-metrics/workflows/Swagger-Documentation/badge.svg)](https://github.com/ministryofjustice/opg-metrics/workflows/Swagger-Documentation)

# OPG Metrics

The Office of the Public Guardian metrics service: Managed by opg-org-infra &amp; Terraform

Building a new metrics service for OPG.

To find out more about this service, see our [about this service](ABOUT_THIS_SERVICE.md) documentation.

## C4 Model

To understand how the service works [see our C4 Model](docs/architecture/diagrams/0003-c4-model.md).

## Prerequisites

aws-vault for managing AWS access.

`brew install --cask aws-vault`

[https://formulae.brew.sh/cask/aws-vault](https://formulae.brew.sh/cask/aws-vault)

Also see [https://docs.opg.service.justice.gov.uk/documentation/get_started.html#get-started](https://docs.opg.service.justice.gov.uk/documentation/get_started.html#get-started) for a full breakdown on how to setup your local environment for using Terraform and aws-vault.

Terraform CLI for releasing to AWS and validation.

`brew install terraform`

[https://formulae.brew.sh/formula/terraform](https://formulae.brew.sh/formula/terraform)

If developing the app then ensure you have [pre-commit](https://pre-commit.com/) installed to take advantage of the pre-commit [hooks](.pre-commit-config.yaml) we've added to the project to make PRs a more consistent and enjoyable experience.

`brew install pre-commit`

[https://formulae.brew.sh/formula/pre-commit](https://formulae.brew.sh/formula/pre-commit)

## Infrastructure and Architecture

Our decisions are recorded and maintained using the tool [https://github.com/npryce/adr-tools](https://github.com/npryce/adr-tools). As such, all records including diagrams can be found in [docs/architecture/README.md](docs/architecture/README.md)

## Using the service

If you choose to use the API Gateway endpoint, you can find more information in our OpenAPI Documentation in [docs/openapi/README.md](docs/openapi/README.md).

For additional methods see the [Plugins and integrations](#plugins-and-integrations) section below.

## Plugins and integrations

The service is built to allow flexibility and ease of integration into a wide range of services. More information on existing integrations can be found in [docs/integrations/README.md](docs/integrations/README.md).

## Local Development

### Environment Variables

This repository comes with an `.envrc` file containing useful environment variables for working with this repository.

`.envrc` can be sourced automatically using either [direnv](https://direnv.net) or manually with bash.

```bash
cd terraform/account && source .envrc
cd terraform/environment && source .envrc
```

```bash
cd terraform/account && direnv allow
cd terraform/environment && direnv allow
```

### Update .envrc

You'll need to update `TF_WORKSPACE` to point to the environment you want to run a task in.

## AWS Credentials Setup

See [opg-org-infra/AWS-CONSOLE.md](https://github.com/ministryofjustice/opg-org-infra/blob/master/AWS-CONSOLE.md) for setup instructions.


### Terraform Plan and Apply

To test and compare your changes you'll want to do a plan to ensure there are no unexpected changes

```bash
cd terraform/environment && aws-vault exec identity -- terraform plan
```

If everything returns as you expect, you can now do a terraform apply. This will deploy your changes to a development environment.

```bash
cd terraform/environment && aws-vault exec identity -- terraform apply
```

## License

The OPG Metrics Service is released under the MIT license, a copy of which can be found in [LICENCE](LICENCE).
