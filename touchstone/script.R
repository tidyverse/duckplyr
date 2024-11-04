library(touchstone)

branch_install()

benchmark_run(
  expr_before_benchmark = {
    library(styler)
    cache_deactivate()
  },
  without_cache = style_pkg("touchstone/sources/here", filetype = c("R", "rmd")),
  n = 30
)

clear_branch_caches()
benchmark_run(
  expr_before_benchmark = {
    library(styler)
    cache_activate(gert::git_branch())
  },
  cache_applying = style_pkg("touchstone/sources/here", filetype = c("R", "rmd")),
  n = 30
)

clear_branch_caches()

benchmark_run(
  expr_before_benchmark = {
    library(styler)
    cache_activate(gert::git_branch())
  },
  cache_recording = {
    gert::git_reset_hard(repo = "touchstone/sources/here")
    style_pkg("touchstone/sources/here", filetype = c("R", "rmd"))
  },
  n = 30
)

clear_branch_caches()

benchmark_analyze()
