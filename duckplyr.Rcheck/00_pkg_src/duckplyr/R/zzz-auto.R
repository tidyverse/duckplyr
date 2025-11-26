on_load({
  if (Sys.getenv("DUCKPLYR_METHODS_OVERWRITE") == "TRUE") {
    methods_overwrite()
  }
})
