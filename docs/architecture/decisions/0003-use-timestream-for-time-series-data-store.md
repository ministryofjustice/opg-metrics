# 3. Use Timestream for time series data store

Date: 2020-11-10

## Status

Accepted

## Context

Data collected within the solution is stored in a Time Series format. This data can be stored in any type of database if needed, however we should use, if possible, a database that natively supports it. This will result in a more optimised system and therefore cheaper to run.

The amount of data that gets sent to the database will grow over time and so it will need to be scalable and managable over this time.

## Decision

We will use Amazon Timeseries for our data store. It is a fast, scalable and serverless time series database that fits well with our existing use of AWS infrastructure.

## Consequences

We are tied into AWS as this is not available in other cloud providers.

Currently Terraform does not support this so we cannot manage it via code. This is in a PR however awaiting approval.

Gives us a Serverless service that auto scales based on demand, simplifying our management of the solution.
