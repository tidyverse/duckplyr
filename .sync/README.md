# sync

Repositories for synchronizing with dplyr.

Initialize with:

```sh
# --reference assumes that dplyr is checked out parallel to duckplyr
cd .sync
hub clone krlmlr/dplyr dplyr-main --reference ../../../tidyverse/dplyr
hub clone krlmlr/dplyr -b f-revdep-duckplyr dplyr-revdep --reference ../../../tidyverse/dplyr
```

or


```sh
# --reference assumes that dplyr is checked out parallel to duckplyr
# hub clone ... can be replaced with an equivalent git clone command if hub is not available
cd .sync
git clone git@github.com:krlmlr/dplyr.git dplyr-main --reference ../../dplyr
git clone git@github.com:krlmlr/dplyr -b f-revdep-duckplyr dplyr-revdep --reference ../../dplyr
```
