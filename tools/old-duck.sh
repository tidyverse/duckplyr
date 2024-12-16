#!/bin/sh

# A script to install legacy versions of the duckdb R package

set -e
set -x

# 0.7.0
R -q -e 'install.packages("duckdb", repos = "https://packagemanager.posit.co/cran/2023-03-01"); packageVersion("duckdb")'
# 0.7.1-1
R -q -e 'install.packages("duckdb", repos = "https://packagemanager.posit.co/cran/2023-05-23"); packageVersion("duckdb")'
# 0.8.0
R -q -e 'install.packages("duckdb", repos = "https://packagemanager.posit.co/cran/2023-06-16"); packageVersion("duckdb")'
# 0.8.1
R -q -e 'install.packages("duckdb", repos = "https://packagemanager.posit.co/cran/2023-07-17"); packageVersion("duckdb")'
# 0.8.1-1
R -q -e 'install.packages("duckdb", repos = "https://packagemanager.posit.co/cran/2023-08-25"); packageVersion("duckdb")'
# 0.8.1-2
R -q -e 'install.packages("duckdb", repos = "https://packagemanager.posit.co/cran/2023-09-01"); packageVersion("duckdb")'
# 0.8.1-3
R -q -e 'install.packages("duckdb", repos = "https://packagemanager.posit.co/cran/2023-10-13"); packageVersion("duckdb")'
# 0.9.1
R -q -e 'install.packages("duckdb", repos = "https://packagemanager.posit.co/cran/2023-10-30"); packageVersion("duckdb")'
# 0.9.1-1
R -q -e 'install.packages("duckdb", repos = "https://packagemanager.posit.co/cran/2023-11-17"); packageVersion("duckdb")'
# 0.9.2
R -q -e 'install.packages("duckdb", repos = "https://packagemanager.posit.co/cran/2023-11-28"); packageVersion("duckdb")'
# 0.9.2-1
R -q -e 'install.packages("duckdb", repos = "https://packagemanager.posit.co/cran/2024-03-12"); packageVersion("duckdb")'
# 0.10.0
R -q -e 'install.packages("duckdb", repos = "https://packagemanager.posit.co/cran/2024-04-02"); packageVersion("duckdb")'
# 0.10.1
R -q -e 'install.packages("duckdb", repos = "https://packagemanager.posit.co/cran/2024-05-01"); packageVersion("duckdb")'
# 0.10.2
R -q -e 'install.packages("duckdb", repos = "https://packagemanager.posit.co/cran/2024-06-13"); packageVersion("duckdb")'
# 1.0.0
R -q -e 'install.packages("duckdb", repos = "https://packagemanager.posit.co/cran/2024-07-09"); packageVersion("duckdb")'
# 1.0.0-1
R -q -e 'install.packages("duckdb", repos = "https://packagemanager.posit.co/cran/2024-07-19"); packageVersion("duckdb")'
# 1.0.0-2
R -q -e 'install.packages("duckdb", repos = "https://packagemanager.posit.co/cran/2024-09-24"); packageVersion("duckdb")'
# 1.1.0
R -q -e 'install.packages("duckdb", repos = "https://packagemanager.posit.co/cran/2024-10-16"); packageVersion("duckdb")'
# 1.1.1
R -q -e 'install.packages("duckdb", repos = "https://packagemanager.posit.co/cran/2024-10-30"); packageVersion("duckdb")'
# 1.1.2
R -q -e 'install.packages("duckdb", repos = "https://packagemanager.posit.co/cran/2024-11-21"); packageVersion("duckdb")'
