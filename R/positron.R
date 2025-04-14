on_load({
  ark_register_methods()
})

ark_register_methods <- function() {
  ark_register_method(
    "ark_positron_variable_display_value",
    "duckplyr_df",
    duckplyr_df_variable_display_value
  )
  ark_register_method(
    "ark_positron_variable_display_type",
    "duckplyr_df",
    duckplyr_df_variable_display_type
  )
  ark_register_method(
    "ark_positron_variable_has_children",
    "duckplyr_df",
    duckplyr_df_variable_has_children
  )
  ark_register_method(
    "ark_positron_has_value",
    "duckplyr_df",
    duckplyr_df_has_value
  )
}

# Registration either succeeds or silently fails to be as unobtrusive as possible
ark_register_method <- function(generic, class, method) {
  tryCatch(
    eval(call(
      ".ark.register_method",
      quote(generic),
      quote(class),
      quote(method)
    )),
    error = function(cnd) {
      # Errors indicate that we aren't in ark and `.ark.register_method()`
      # doesn't exist, or we called it wrong.
      NULL
    },
    warning = function(cnd) {
      # Warnings likely indicate that we are in ark < 0.1.176, where duckplyr
      # was not yet allowed to register ark methods, and ark would warn about
      # this.
      NULL
    }
  )
}

duckplyr_df_variable_display_value <- function(x, ...) {
  n_col <- df_n_col(x)

  if (n_col == 1L) {
    col_word <- "column"
  } else {
    col_word <- "columns"
  }

  paste0("<duckplyr_df> [", n_col, " ", col_word, "] ")
}

# You don't ever see this on the Positron side because it's a table and we
# show the table icon instead, but we still need this because Ark will otherwise
# try and compute the number of rows (materializing the query).
duckplyr_df_variable_display_type <- function(x, ...) {
  "duckplyr_df"
}

# We disable children and kind for safety,
# until Positron catches errors in materialization
duckplyr_df_variable_has_children <- function(x, ...) {
  FALSE
}

# This is to hide the viewer button,
# until the viewer can handle thrifty duckplyr frames
duckplyr_df_variable_has_value <- function(x, ...) {
  FALSE
}
