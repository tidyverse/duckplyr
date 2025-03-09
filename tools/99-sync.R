# Once per clone:

# - source("tools/30-tpch-export.R", echo = TRUE)
# - source("tools/31-tpch-load-qs.R", echo = TRUE)
# - Follow instructions in .sync/README.md
# - Clone duckdb/duckdb-r in a directory next to duckplyr
# - Restart R

# Every time you want to sync:

source("tools/80-unsupported.R", echo = TRUE)

# From here on, dplyr is loaded from .sync/dplyr-main
source("tools/01-dplyr-methods.R", echo = TRUE)

# If the code generation is updated, go into the script and stop in the middle
# (search for "# Stop here to overwrite files if the code generation is updated")
# and then rerun
source("tools/02-duckplyr_df-methods.R", echo = TRUE)

source("tools/03-tests.R", echo = TRUE)
source("tools/04-dplyr-tests.R", echo = TRUE)
source("tools/05-duckdb-tests.R", echo = TRUE)
source("tools/06-patch-duckdb.R", echo = TRUE)
source("tools/07-overwrite.R", echo = TRUE)
source("tools/37-tpch-peel.R", echo = TRUE)
source("tools/39-tpch-peel-oo.R", echo = TRUE)
