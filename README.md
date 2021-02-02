[![CircleCI](https://circleci.com/gh/ministryofjustice/opg-metrics.svg?style=shield)](https://circleci.com/gh/ministryofjustice/opg-metrics)
[![pre-commit](https://img.shields.io/badge/pre--commit-enabled-brightgreen?logo=pre-commit&logoColor=white)](https://github.com/pre-commit/pre-commit)
[![pre-commit](https://github.com/ministryofjustice/opg-metrics/workflows/Swagger-Documentation/badge.svg)](https://github.com/ministryofjustice/opg-metrics/workflows/Swagger-Documentation)

# OPG Metrics

The Office of the Public Guardian metrics service: Managed by opg-org-infra &amp; Terraform

Building a new metrics service for OPG.

To find out more about this service, see our [about this service](ABOUT_THIS_SERVICE.md) documentation.

## Plugins and integrations

The service is built to allow flexibility and ease of integration into a wide range of services. More information on existing integrations can be found in [docs/integrations/README.md](docs/integrations/README.md).

## Prerequisites

aws-vault for managing AWS access.

`brew install --cask aws-vault`

[https://formulae.brew.sh/cask/aws-vault](https://formulae.brew.sh/cask/aws-vault)

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

# opg-sirius-infrastructure

Sirius Infrastructure: Managed by opg-org-infra &amp; Terraform

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

## AWS Credentials Setup

See [opg-org-infra/AWS-CONSOLE.md](https://github.com/ministryofjustice/opg-org-infra/blob/master/AWS-CONSOLE.md) for setup instructions.

## Planning locally

```bash
cd terraform/environment && aws-vault exec identity -- terraform plan
```

### Update .envrc

You'll need to update `TF_WORKSPACE` to point to the environment you want to run a task in.

### Terraform Plan and Apply

You need to perform terraform apply in order to generate some outputs which are needed
by the ecs-runner tool. First you'll want to do a plan to ensure there are no unexpected changes

```bash
cd terraform/environment && aws-vault exec identity -- terraform plan
```

Terraform should want to create 3 resources, these should all be local files. If there are any other
changes listed, ask someone in #opg-starfox to help you out.

You can now do a terraform apply

```bash
cd terraform/environment && aws-vault exec identity -- terraform apply
```

After the apply is finished, you'll need to send all the outputs to one file using the command below

```bash
cd terraform/environment && aws-vault exec identity -- terraform output -json > terraform.output.json
```

## License

The OPG Metrics Service is released under the MIT license, a copy of which can be found in [LICENSE](LICENSE).
