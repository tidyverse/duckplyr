#!/bin/bash

#- A script to clone duckplyr on a fresh Ubuntu machine with all helper repositories

set -e
set -x

# sudo apt update
# sudo apt install -y git

# sudo curl -L https://rig.r-pkg.org/deb/rig.gpg -o /etc/apt/trusted.gpg.d/rig.gpg
# sudo sh -c 'echo "deb http://rig.r-pkg.org/deb rig main" > /etc/apt/sources.list.d/rig.list'
# sudo apt update
# sudo apt install r-rig

# rig add release

# git clone https://github.com/tidyverse/duckplyr

# git clone https://github.com/duckdb/duckdb-r

cd duckplyr

# One-time initialization
# cd .sync
# git clone https://github.com/krlmlr/dplyr.git dplyr-main
# git clone https://github.com/krlmlr/dplyr.git -b f-revdep-duckplyr dplyr-revdep --reference dplyr-main
# cd ..

# R -q -e 'pak::pak()'

git checkout .
git -C /Users/kirill/git/R/duckplyr diff | patch -p1

# R -q -e 'pak::pak(dependencies = "Config/Needs/development")'

# R -q -e 'source("tools/30-tpch-export.R", echo = TRUE)'
# R -q -e 'source("tools/31-tpch-load-qs.R", echo = TRUE)'

# R -q -e 'source("tools/80-unsupported.R", echo = TRUE)'
# R -q -e 'source("tools/01-dplyr-methods.R", echo = TRUE)'
# R -q -e 'source("tools/02-duckplyr_df-methods.R", echo = TRUE)'
# R -q -e 'source("tools/03-tests.R", echo = TRUE)'
# R -q -e 'source("tools/04-dplyr-tests.R", echo = TRUE)'

# R -q -e 'source("tools/05-duckdb-tests.R", echo = TRUE)'

# R -q -e 'source("tools/06-patch-duckdb.R", echo = TRUE)'
# R -q -e 'source("tools/07-overwrite.R", echo = TRUE)'
R -q -e 'source("tools/37-tpch-peel.R", echo = TRUE)'
R -q -e 'source("tools/39-tpch-peel-oo.R", echo = TRUE)'
