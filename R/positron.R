ark_register_methods <- function() {
  # TODO: Actually bump this to 0.1.176 after Ark PR merges and we bump the version
  if (!ark_has_version("0.1.174")) {
    return()
  }

  tryCatch(
    ark_register_methods_impl(),
    error = function(err) {
      cli::cli_warn("Failed to register Ark methods.", parent = err)
    }
  )
}

ark_register_methods_impl <- function() {
  ark_register_method(
    "ark_positron_variable_display_value",
    "duckplyr_df",
    function(x, ...) {
      duckplyr_df_variable_display_value(x)
    }
  )

  ark_register_method(
    "ark_positron_variable_display_type",
    "duckplyr_df",
    function(x, ...) {
      duckplyr_df_variable_display_type(x)
    }
  )
}

ark_register_method <- function(generic, class, method) {
  ARK_REGISTER_METHOD_FUNCTION <- ".ark.register_method"

  if (!exists(ARK_REGISTER_METHOD_FUNCTION, mode = "function")) {
    return()
  }

  call <- call(
    ARK_REGISTER_METHOD_FUNCTION,
    quote(generic),
    quote(class),
    quote(method)
  )

  eval(call, envir = environment())
}

# This Ark API for the Ark version is not stable, so we carefully bail
# and return `FALSE` if anything looks wrong
ark_has_version <- function(minimum_version) {
  ARK_VERSION_FUNCTION <- ".ps.ark.version"

  if (!exists(ARK_VERSION_FUNCTION, mode = "function")) {
    return(FALSE)
  }

  call <- call(ARK_VERSION_FUNCTION)
  info <- eval(call, envir = environment())
  version <- info[["version"]]

  if (!is_string(version)) {
    return(FALSE)
  }

  tryCatch(
    numeric_version(version) >= numeric_version(minimum_version),
    error = function(cnd) {
      FALSE
    }
  )
}

duckplyr_df_variable_display_value <- function(x) {
  n_col <- df_n_col(x)

  if (n_col == 1L) {
    col_word <- "column"
  } else {
    col_word <- "columns"
  }

  sprintf("[? rows x %s %s] <duckplyr_df>", n_col, col_word)
}

duckplyr_df_variable_display_type <- function(x) {
  "duckplyr_df"
}
