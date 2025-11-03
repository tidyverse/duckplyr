# Retrieve details about the most recent computation

Before a result is computed, it is specified as a "relation" object.
This function retrieves this object for the last computation that led to
the materialization of a data frame.

## Usage

``` r
last_rel()
```

## Value

A duckdb "relation" object, or `NULL` if no computation has been
performed yet.
