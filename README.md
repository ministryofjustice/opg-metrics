# OPG Metrics


The Office of the Public Guardian metrics service: Managed by opg-org-infra &amp; Terraform

Building a new metrics service for OPG.

## Overview
### Mission Statement

OPG has many 'things' to measure to aid in decision making, but these are not visible to all or easily accessible in one place, making it difficult to see patterns and connections, or high level problems across products.

### Problems this service aims to solve

* A common language that can be used across teams and OPG.
* Encourage and Gamify the culture of celebrating maintenance and managing legacy
* Understanding our users over time
* Hold ourselves accountable throughout the entire service life-cycle
* Think about performance and monitoring at the start and what done/good looks like
* Reduce barriers to entry for getting data

### How should you use this service

This service is not intended to be a place where you debug issues or store logs that you can diagnose problems. It is to enable you to pass key bits of information across multiple services so you can overlay data points, find patterns and maintain visibility of your service.

If you do find something happening you should use other tools that are built for this in mind to dig deeper into the issue.

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

![OPG Metrics Terraform Infrastructure Diagram](./docs/images/infrastructure-diagram.png)

## Using the service

If you choose to use the API Gateway endpoint, you can find more information in our OpenAPI Documentation in [docs/openapi/README.md](docs/openapi/README.md).

## License

The OPG Metrics Service is released under the MIT license, a copy of which can be found in [LICENSE](LICENSE).
