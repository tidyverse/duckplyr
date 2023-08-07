# sync

Repositories for synchronizing with dplyr.

Initialize with:

```sh
# --reference assumes that dplyr is checked out parallel to duckplyr
# hub clone ... can be replaced with an equivalent git clone command if hub is not available
hub clone tidyverse/dplyr dplyr-main --reference ../../dplyr
hub clone krlmlr/dplyr -b f-revdep-duckplyr dplyr-revdep --reference ../../dplyr
```
