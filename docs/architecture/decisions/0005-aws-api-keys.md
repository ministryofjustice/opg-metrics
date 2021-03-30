# 5. AWS API Keys

Date: 2021-02-17

## Status

Accepted

decisions [1. Record architecture decisions](0001-record-architecture-decisions.md)

## Context

As our API Endpoint will be exposed to the world, we require it to have some sort of protection and authentication against attackers.

We will initially only be connecting internal facing services (AWS) and thrid party tooling, however in the future we would like to begin recording real user metrics (RUM).

We would need to have a way of protecting against attackers spamming our API.

## Decision

We have chosen to use AWS Api Gateway API Keys for our authorisation and usage limits. This will require an AWS Signature being generated from your credentials and API Key.

Each service or integration should have their own key.

Each service should also set their own usage limits which are contextual to their service. For example, CircleCI integration could be monitored for the average use during a day and have this set, as well as having a secure way to request the keys when they are rotated.

We have also looked at [AWS WAFV2](https://docs.aws.amazon.com/waf/latest/APIReference/Welcome.html) and this is something we may look at in the future depending on our usage of the service.

## Consequences

As you need to sign requests using a AccessKey and SecretKey it may make things harder to implement on any client side code. However this should be possible using the CI and scripts to generate tokens on release.
