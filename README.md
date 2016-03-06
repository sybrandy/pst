# Pipeable Statistics

## Overview

This tool will accept a list of newline separated numbers via STDIN and output
one or more statistical measures to STDOUT.  For example, if you have a log
for a web service and you want to know the average and maximum request times,
you can do something like this:

    grep REQ_TIME /var/log/myservice.log | awk '{print $NF}' | pst --stats=avg,max

For larger workloads this will support using multiple threads to allow
multiple measures to be calculated concurrently.  This will be explicitly
specified to ensure that the user has control over how many system resources
are used.  By default, the tool will run in a single thread.

## Usage

### Options

    -h                 = Help
    -p, --percentiles  = A comma separated list of percentiles.  Only
                         applicable if percentiles is specified for --stats.
    -s, --stats        = A comma separated list of statistical measures
    -t, --threads      = The number of worker threads to use.

### Measures

* count
* sum
* mean
* median
* mode
* stddev (Standard Deviation)
* range
* percentiles

### Examples

#### Get a single statistic

    pst -s mean

### Get multiple statistics

    pst -s mean,median,stddev

### Get several percentiles

    pst -s percentiles -p 50,90,99

### Use 3 worker threads

    pst -s mean,median,stddev -t 3

# Version

## 1.0.0 (Not Released)

This version will implement all of the above features.

## 1.1.0 (Planned)

The goal for this version will be to support grouping statistics by a key.
For example, we could calculate the mean response time for a service by day or
hour.

## 1.2.0 (Planned)

The goal for this release is to support generating charts and graphs based on
the output of the tool.  Gnuplot is the most likely tool to be used for this.
