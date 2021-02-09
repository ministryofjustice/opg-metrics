# 4. Use Grafana for our data visualisation

Date: 2020-11-10

## Status

Accepted

## Context

We need a way to visualise our time series data for users to view and analyse data.

We need the ability for authenticating users with levels of permissions for creation and viewing. A way to organise dashboards by project or area of interest should also be available from the solution to help navigate to information.

It is not to be used for debugging, we have other solutions that provide and handle this sort of functionality. This should be for analysing metrics across a spectrum of sources and be able to overlay key points on top of each other.

## Decision

We have chosen Grafana for its ease of use, popularity, plugin support and Open Source status.

## Consequences

It is not available as a managed service within AWS, this means we will have to maintain security patches and updates throughout its usage.

We will be able to access data from our time series database with its connectivity and also connect to other services which we can overlay on top of one another. Exxamples of this are Cloudwatch, Jira, and Prometheus (Should this be something we want to look at in the future).

The connection to the data source means we can swap Grafana out for another tool in the future should we wish without losing data.
