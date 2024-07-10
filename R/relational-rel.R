rel_stats_env <- new.env(parent = emptyenv(), size = 937L)

rel_stats_clean <- function() {
  rm(list = ls(rel_stats_env, all.names = TRUE), pos = rel_stats_env)
}

rel_stats_get <- function() {
  arrange(tibble::enframe(unlist(as.list(rel_stats_env)), "fun", "count"), desc(count))
}

#' Relational implementer's interface
#'
#' @description
#' The constructor and generics described here define a class
#' that helps separating dplyr's user interface from the actual underlying operations.
#' In the longer term, this will help packages that implement the dplyr interface
#' (such as \pkg{dbplyr}, \pkg{dtplyr}, \pkg{arrow} and similar)
#' to focus on the core details of their functionality,
#' rather than on the intricacies of dplyr's user interface.
#'
#' `new_relational()` constructs an object of class `"relational"`.
#' Users are encouraged to provide the `class` argument.
#' The typical use case will be to create a wrapper function.
#'
#' @param ... Passed on to [structure()].
#' @param class Classes added in front of the `"relational"` base class.
#'
#' @return
#' - `new_relational()` returns a new relational object.
#' - `rel_to_df()` returns a data frame.
#' - `rel_names()` returns a character vector.
#' - All other generics return a modified relational object.
#' @name new_relational
#' @export
#' @examples
#' new_dfrel <- function(x) {
#'   stopifnot(is.data.frame(x))
#'   new_relational(list(x), class = "dfrel")
#' }
#' mtcars_rel <- new_dfrel(mtcars[1:5, 1:4])
new_relational <- function(..., class = NULL) {
  structure(..., class = unique(c(class, "relational")))
}

#' rel_to_df()
#'
#' `rel_to_df()` extracts a data frame representation from a relational object,
#' to be used by [dplyr::collect()].
#'
#' @param rel,rel_a,rel_b,left,right A relational object.
#' @param ... Reserved for future extensions, must be empty.
#' @rdname new_relational
#' @export
#' @examples
#'
#' rel_to_df.dfrel <- function(rel, ...) {
#'   unclass(rel)[[1]]
#' }
#' rel_to_df(mtcars_rel)
rel_to_df <- function(rel, ...) {
  rel_stats_env$rel_to_df <- (rel_stats_env$rel_to_df %||% 0L) + 1L
  UseMethod("rel_to_df")
}

#' rel_filter
#'
#' `rel_filter()` keeps rows that match a predicate,
#'  to be used by [dplyr::filter()].
#'
#' @param exprs A list of `"relational_relexpr"` objects to filter by,
#'   created by [new_relexpr()].
#' @rdname new_relational
#' @export
#' @examples
#'
#' rel_filter.dfrel <- function(rel, exprs, ...) {
#'   df <- unclass(rel)[[1]]
#'
#'   # A real implementation would evaluate the predicates defined
#'   # by the exprs argument
#'   new_dfrel(df[seq_len(min(3, nrow(df))), ])
#' }
#'
#' rel_filter(
#'   mtcars_rel,
#'   list(
#'     relexpr_function(
#'       "gt",
#'       list(relexpr_reference("cyl"), relexpr_constant("6"))
#'     )
#'   )
#' )
rel_filter <- function(rel, exprs, ...) {
  rel_stats_env$rel_filter <- (rel_stats_env$rel_filter %||% 0L) + 1L
  UseMethod("rel_filter")
}

#' rel_project
#'
#' `rel_project()` selects columns or creates new columns,
#' to be used by [dplyr::select()], [dplyr::rename()],
#' [dplyr::mutate()], [dplyr::relocate()], and others.
#'
#' @rdname new_relational
#' @export
#' @examples
#'
#' rel_project.dfrel <- function(rel, exprs, ...) {
#'   df <- unclass(rel)[[1]]
#'
#'   # A real implementation would evaluate the expressions defined
#'   # by the exprs argument
#'   new_dfrel(df[seq_len(min(3, ncol(df)))])
#' }
#'
#' rel_project(
#'   mtcars_rel,
#'   list(relexpr_reference("cyl"), relexpr_reference("disp"))
#' )
rel_project <- function(rel, exprs, ...) {
  rel_stats_env$rel_project <- (rel_stats_env$rel_project %||% 0L) + 1L
  UseMethod("rel_project")
}

#' rel_aggregate
#'
#' `rel_aggregate()` combines several rows into one,
#' to be used by [dplyr::summarize()].
#'
#' @param groups A list of expressions to group by.
#' @param aggregates A list of expressions with aggregates to compute.
#' @rdname new_relational
#' @export
rel_aggregate <- function(rel, groups, aggregates, ...) {
  rel_stats_env$rel_aggregate <- (rel_stats_env$rel_aggregate %||% 0L) + 1L
  UseMethod("rel_aggregate")
}

#' rel_order
#'
#' `rel_order()` reorders rows by columns or expressions,
#' to be used by [dplyr::arrange()].
#'
#' @param orders A list of expressions to order by.
#' @param ascending A logical vector describing the sort order.
#' @rdname new_relational
#' @export
#' @examples
#'
#' rel_order.dfrel <- function(rel, exprs, ...) {
#'   df <- unclass(rel)[[1]]
#'
#'   # A real implementation would evaluate the expressions defined
#'   # by the exprs argument
#'   new_dfrel(df[order(df[[1]]), ])
#' }
#'
#' rel_order(
#'   mtcars_rel,
#'   list(relexpr_reference("mpg"))
#' )
rel_order <- function(rel, orders, ascending, ...) {
  rel_stats_env$rel_order <- (rel_stats_env$rel_order %||% 0L) + 1L
  UseMethod("rel_order")
}

#' rel_join
#'
#' `rel_join()` joins or merges two tables,
#' to be used by [dplyr::left_join()], [dplyr::right_join()],
#' [dplyr::inner_join()], [dplyr::full_join()], [dplyr::cross_join()],
#' [dplyr::semi_join()], and [dplyr::anti_join()].
#'
#' @param conds A list of expressions to use for the join.
#' @param join The type of join.
#' @param join_ref_type The ref type of join.
#' @rdname new_relational
#' @export
#' @examplesIf requireNamespace("dplyr", quietly = TRUE)
#' rel_join.dfrel <- function(left, right, conds, join, ...) {
#'   left_df <- unclass(left)[[1]]
#'   right_df <- unclass(right)[[1]]
#'
#'   # A real implementation would evaluate the expressions
#'   # defined by the conds argument,
#'   # use different join types based on the join argument,
#'   # and implement the join itself instead of relaying to left_join().
#'   new_dfrel(dplyr::left_join(left_df, right_df))
#' }
#'
#' rel_join(new_dfrel(data.frame(mpg = 21)), mtcars_rel)
rel_join <- function(left,
                     right,
                     conds,
                     join = c("inner", "left", "right", "outer", "cross", "semi", "anti"),
                     join_ref_type = c("regular", "natural", "cross", "positional", "asof"),
                     ...) {
  rel_stats_env$rel_join <- (rel_stats_env$rel_join %||% 0L) + 1L
  UseMethod("rel_join")
}

#' rel_limit
#'
#' `rel_limit()` limits the number of rows in a table,
#' to be used by [utils::head()].
#'
#' @param n The number of rows.
#' @rdname new_relational
#' @export
#' @examples
#'
#' rel_limit.dfrel <- function(rel, n, ...) {
#'   df <- unclass(rel)[[1]]
#'
#'   new_dfrel(df[seq_len(n), ])
#' }
#'
#' rel_limit(mtcars_rel, 3)
rel_limit <- function(rel, n, ...) {
  rel_stats_env$rel_limit <- (rel_stats_env$rel_limit %||% 0L) + 1L
  UseMethod("rel_limit")
}

#' rel_distinct()
#'
#' `rel_distinct()` only keeps the distinct rows in a table,
#' to be used by [dplyr::distinct()].
#'
#' @rdname new_relational
#' @export
#' @examples
#'
#' rel_distinct.dfrel <- function(rel, ...) {
#'   df <- unclass(rel)[[1]]
#'
#'   new_dfrel(df[!duplicated(df), ])
#' }
#'
#' rel_distinct(new_dfrel(mtcars[1:3, 1:4]))
rel_distinct <- function(rel, ...) {
  rel_stats_env$rel_distinct <- (rel_stats_env$rel_distinct %||% 0L) + 1L
  UseMethod("rel_distinct")
}

#' rel_set_intersect()
#'
#' `rel_set_intersect()` returns rows present in both tables,
#' to be used by [intersect()].
#'
#' @rdname new_relational
#' @export
rel_set_intersect <- function(rel_a, rel_b, ...) {
  rel_stats_env$rel_set_intersect <- (rel_stats_env$rel_set_intersect %||% 0L) + 1L
  UseMethod("rel_set_intersect")
}

#' rel_set_diff()
#'
#' `rel_set_diff()` returns rows present in any of both tables,
#' to be used by [setdiff()].
#'
#' @rdname new_relational
#' @export
rel_set_diff <- function(rel_a, rel_b, ...) {
  rel_stats_env$rel_set_diff <- (rel_stats_env$rel_set_diff %||% 0L) + 1L
  UseMethod("rel_set_diff")
}

#' rel_set_symdiff()
#'
#' `rel_set_symdiff()` returns rows present in any of both tables,
#' to be used by [dplyr::symdiff()].
#'
#' @rdname new_relational
#' @export
rel_set_symdiff <- function(rel_a, rel_b, ...) {
  rel_stats_env$rel_set_symdiff <- (rel_stats_env$rel_set_symdiff %||% 0L) + 1L
  UseMethod("rel_set_symdiff")
}

#' rel_union_all()
#'
#' `rel_union_all()` returns rows present in any of both tables,
#' to be used by [dplyr::union_all()].
#'
#' @rdname new_relational
#' @export
rel_union_all <- function(rel_a, rel_b, ...) {
  rel_stats_env$rel_union_all <- (rel_stats_env$rel_union_all %||% 0L) + 1L
  UseMethod("rel_union_all")
}

#' rel_explain
#'
#' `rel_explain()` prints an explanation of the plan
#' executed by the relational object.
#'
#' @rdname new_relational
#' @export
rel_explain <- function(rel, ...) {
  rel_stats_env$rel_explain <- (rel_stats_env$rel_explain %||% 0L) + 1L
  UseMethod("rel_explain")
}

#' rel_alias
#'
#' `rel_alias()` returns the alias name for a relational object.
#'
#' @rdname new_relational
#' @export
rel_alias <- function(rel, ...) {
  rel_stats_env$rel_alias <- (rel_stats_env$rel_alias %||% 0L) + 1L
  UseMethod("rel_alias")
}

#' rel_set_alias
#'
#' `rel_set_alias()` sets the alias name for a relational object.
#'
#' @rdname new_relational
#' @param alias the new alias
#' @export
rel_set_alias <- function(rel, alias, ...) {
  rel_stats_env$rel_set_alias <- (rel_stats_env$rel_set_alias %||% 0L) + 1L
  UseMethod("rel_set_alias")
}

#' rel_names()
#'
#' `rel_names()` returns the column names as character vector,
#' to be used by [colnames()].
#'
#' @rdname new_relational
#' @export
#' @examples
#'
#' rel_names.dfrel <- function(rel, ...) {
#'   df <- unclass(rel)[[1]]
#'
#'   names(df)
#' }
#'
#' rel_names(mtcars_rel)
rel_names <- function(rel, ...) {
  rel_stats_env$rel_names <- (rel_stats_env$rel_names %||% 0L) + 1L
  UseMethod("rel_names")
}
