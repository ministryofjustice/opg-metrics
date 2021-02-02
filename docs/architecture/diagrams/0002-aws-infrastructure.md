# 2. AWS Infrastructure

Date: 2021-02-02

## Status

Accepted

diagrams [1. Record architecture decisions](0001-record-architecture-decisions.md)

## Context

Based on ADRs and developer need, we need to create a system that is light weight, fully managed and easy to integrate into.

## Decision

To run in a fully managed AWS cloud environment using Terraform to manage it.

## Consequences

The following diagram gives us an overview of what is created through Terraform in AWS.

![OPG Metrics Terraform Infrastructure Diagram](../../images/infrastructure-diagram.png)
