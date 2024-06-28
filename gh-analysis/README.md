# gh-analysis

This directory contains code to analyze [GitHub activity data](https://console.cloud.google.com/marketplace/product/github/github-repos) available on Big Query.
The data is a few years old, but we do not expect major shifts in the outcome of the analysis by using more recent data.

## Setup and queries

The data has been extracted using several SQL queries where each generated an intermediate table stored in the `tinker` dataset.
The queries cost about USD 10 to run in total.
The dataset contains a much smaller set of sample queries for experimentation.

### `tinker.r_repos`

Filter all relevant repositories.

```sql
SELECT 
  DISTINCT repo_name
FROM
  `bigquery-public-data.github_repos.languages` l, UNNEST(language)
WHERE
  name = 'R' AND repo_name NOT LIKE 'cran/%'
ORDER BY
  repo_name
```

### `tinker.r_files`

List files from the relevant repositories.
Only after downloading and analyzing the data, it became apparent that the output has duplicate `id` values, possibly from forks which were not excluded in the previous query.
This leads to a larger output dataset than necessary, but not to increased query costs.

```sql
SELECT
  repo_name, path, id
FROM
  `bigquery-public-data.github_repos.files`
WHERE
  path LIKE '%.R'
  OR path LIKE '%.r'
  AND repo_name IN (SELECT * FROM tinker.r_repos)
```

### `tinker.r_contents`

This is the final dataset, available for download from a [GitHub release](https://github.com/duckdblabs/duckplyr/releases/tag/gh-analysis) in this repository, uploaded with the [piggyback](https://docs.ropensci.org/piggyback) R package.

```sql
SELECT
  r_files.repo_name AS repo_name,
  r_files.path AS path,
  r_files.id AS id,
  content,
  binary
FROM
  tinker.r_files
LEFT JOIN
  `bigquery-public-data.github_repos.contents`
USING
  (id)
```

## Scripts

The scripts are meant to be run from the project root, in succession, like this:

```bash
R -q -f gh-analysis/60-gh.R
```

The scripts expect the data in the `data` subdirectory of this directory.

Each script works in a fresh R session.
Interrupting a script gives partial results, these will not be recomputed when running the script again.

## Results

Results are made available in a vignette.
FIXME.
