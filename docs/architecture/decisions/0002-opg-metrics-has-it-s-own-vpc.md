# 2. OPG Metrics has it's own VPC

Date: 2020-11-06

## Status

Proposed

## Context

OPG Metrics will live in the opg-management account, which is home to other products and services.

We want to keep OPG Metrics infrasture separate from those other products so that it can be more portable across accounts and avoids impacting the performance or configuration of those other products.

## Decision

OPG Metrics will have it's own VPC.

## Consequences

This will have an impact on cost.
