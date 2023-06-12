# as seen in https://github.com/r-hub/rhub/blob/c0a3f316a760bbcf865de93188215e56d7d0bccd/R/utils.R#L21
`%||%` <- function(l, r) if (is.null(l)) r else l
