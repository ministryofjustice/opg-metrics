# 6. Timestream retention policy

Date: 2022-01-10

## Status

Accepted

## Context

We should setup an efficient storage and retention policy for the collection of data within Timestream. [AWS Storage Overview](https://docs.aws.amazon.com/timestream/latest/developerguide/storage.html)

We have two types of storage/retention policy we need to configure.

### Magnetic Storage

Magnetic Storage is used for the long term storage of data. It is intended for high performance queries and reads. After the period set, data is automatically deleted from the database.

### Memory Storage

Memory Storage is used for fast writes and allows the consumption of large amounts of data to be recorded. When the data has been in Memory Storage for the allocated time, it is written to Magnetic Storage.

If the timestamp passed in the data exceeds the time that the Memory Storage retention policy is set to, then the data will be rejected. We should bare this in mind when thinking about potential delays in data being added or data being added in bulk covering a wide timeframe.

[AWS Configuration Guide](https://docs.aws.amazon.com/timestream/latest/developerguide/configuration.html)

## Decision

We will set Magnetic Storage to hold data for 365 days.

We will set Memory Storage to hold data for 24 hours. This will support automated processes that run and insert data for the past 24 hours.

## Consequences

Having the Memory Storage rention policy set to 24 hours means any input that updates over a longer period will be rejected by Timestream.

If we have data being written over longer periods to Memory Storage, we should consider creating a seperate table to handle the retention policy needs.
