# 3. Use Timestream for time series data store

Date: 2020-11-10

## Status

Accepted

## Context

Data collected within the solution is stored in a Time Series format. This data can be stored in any type of database
if needed, however we should use, if possible, a database that natively supports it.

## Decision

We will use Amazon Timeseries for our data store. It is a fast, scalable and serverless time series database that fits
well with our existing use of AWS infrastructure.

## Consequences

* We are tied into AWS as this is not available in other cloud providers
* Currently Terraform does not support this so we cannot manage it via code. This is in a PR however awaiting approval.
