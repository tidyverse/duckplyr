rel_stats_env <- new.env(parent = emptyenv(), size = 937L)

rel_stats_clean <- function() {
  rm(list = ls(rel_stats_env, all.names = TRUE), pos = rel_stats_env)
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
#' @return A (new/modified) relational object.
#' @name relational
#' @export
#' @examples
#' new_dfrel <- function(x) {
#'   stopifnot(is.data.frame(x))
#'   new_relational(list(x), class = "dfrel")
#' }
#' mtcars_rel <- new_dfrel(mtcars)
new_relational <- function(..., class = NULL) {
  structure(..., class = unique(c(class, "relational")))
}

#' rel_to_df()
#'
#' `rel_to_df()` extracts a data frame representation from a relational object,
#' to be used by `dplyr::collect()`.
#'
#' @param rel The relational object.
#' @param ... Reserved for future extensions, must be empty.
#' @return A data frame.
#' @rdname relational
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
#' `rel_filter()` keeps rows that match a predicate, to be used by `dplyr::filter()`.
#'
#' @inheritParams rel_to_df
#' @param exprs a list of expressions to filter by
#' @return the now filtered relational object
#' @export
#' @examplesIf FALSE
#' rel <- rel_from_df(mtcars)
#' rel2 <- rel_filter(
#'   rel,
#'   list(
#'     relexpr_function(
#'       "gt",
#'       list(relexpr_reference("cyl"), relexpr_constant("6")))
#'   )
#' )
rel_filter <- function(rel, exprs, ...) {
  rel_stats_env$rel_filter <- (rel_stats_env$rel_filter %||% 0L) + 1L
  UseMethod("rel_filter")
}

#' Lazily project a relational object
#'
#' TBD.
#'
#' @inheritParams rel_to_df
#' @param exprs a list of DuckDB expressions to project
#' @return the now projected relational object
#' @export
#' @examplesIf FALSE
#' rel <- rel_from_df(mtcars)
#' rel2 <- rel_project(rel, list(relexpr_reference("cyl"), relexpr_reference("disp")))
rel_project <- function(rel, exprs, ...) {
  rel_stats_env$rel_project <- (rel_stats_env$rel_project %||% 0L) + 1L
  UseMethod("rel_project")
}

#' Lazily aggregate a relational object
#'
#' TBD.
#'
#' @inheritParams rel_to_df
#' @param groups a list of DuckDB expressions to group by
#' @param aggregates a (optionally named) list of DuckDB expressions with aggregates to compute
#' @return the now aggregated relational object
#' @export
#' @examplesIf FALSE
#' rel <- rel_from_df(mtcars)
#' aggrs <- list(avg_hp = relexpr_function("avg", list(relexpr_reference("hp"))))
#' rel2 <- rel_aggregate(rel, list(relexpr_reference("cyl")), aggrs)
rel_aggregate <- function(rel, groups, aggregates, ...) {
  rel_stats_env$rel_aggregate <- (rel_stats_env$rel_aggregate %||% 0L) + 1L
  UseMethod("rel_aggregate")
}

#' Lazily reorder a relational object
#'
#' TBD.
#'
#' @inheritParams rel_to_df
#' @param orders a list of DuckDB expressions to order by
#' @return the now aggregated relational object
#' @export
#' @examplesIf FALSE
#' rel <- rel_from_df(mtcars)
#' rel2 <- rel_order(rel, list(relexpr_reference("hp")))
rel_order <- function(rel, orders, ...) {
  rel_stats_env$rel_order <- (rel_stats_env$rel_order %||% 0L) + 1L
  UseMethod("rel_order")
}

#' Lazily INNER join two relational objects
#'
#' TBD.
#'
#' @inheritParams rel_to_df
#' @param left the left-hand-side relational object
#' @param right the right-hand-side relational object
#' @param conds a list of DuckDB expressions to use for the join
#' @param join type of join
#' @return a new relational object resulting from the join
#' @export
#' @examplesIf FALSE
#' left <- rel_from_df(mtcars)
#' right <- rel_from_df(mtcars)
#' cond <- list(
#'   relexpr_function(
#'     "eq",
#'     list(relexpr_reference("cyl", left), relexpr_reference("cyl", right))
#'   )
#' )
#' rel2 <- rel_join(left, right, cond)
rel_join <- function(left, right, conds, join, ...) {
  rel_stats_env$rel_join <- (rel_stats_env$rel_join %||% 0L) + 1L
  UseMethod("rel_join")
}

#' Lazily limit the rows in a relational object
#'
#' TBD.
#'
#' @inheritParams rel_to_df
#' @param n The number of rows.
#' @return A (new/modified) relational object.
#' @export
#' @examples
#' mtcars_rel <- new_relational(list(mtcars), class = "dfrel")
#' rel_limit.dfrel <- function(rel, n, ...) {
#'   new_relational(
#'     head(unclass(rel)[[1]], n),
#'     class = "dfrel"
#'   )
#' }
#'
rel_limit <- function(rel, n, ...) {
  rel_stats_env$rel_limit <- (rel_stats_env$rel_limit %||% 0L) + 1L
  UseMethod("rel_limit")
}

#' Lazily compute a distinct result on a relational object
#'
#' TBD.
#'
#' @inheritParams rel_to_df
#' @return a new relational object with distinct rows
#' @export
#' @examples
#' rel <- new_relational(c("a", "a", "b"), class = "vecrel")
#' rel_distinct.vecrel <- function(rel, ...) {
#'   class(rel) <- setdiff(class(rel), "relational")
#'   new_relational(unique(rel), class = class(rel))
#' }
#' rel_distinct(rel)
rel_distinct <- function(rel, ...) {
  rel_stats_env$rel_distinct <- (rel_stats_env$rel_distinct %||% 0L) + 1L
  UseMethod("rel_distinct")
}

#' Lazily compute a set_intersect result on a relational object
#'
#' TBD.
#'
#' @inheritParams rel_to_df
#' @param rel_a a DuckDB relational object
#' @param rel_b a DuckDB relational object
#' @return a new relational object with the result
#' @export
#' @examples
#' rel_a <- new_relational(c(1, 1, 2), class = "vecrel")
#' rel_b <- new_relational(c(1, 3, 2), class = "vecrel")
#' rel_set_intersect.vecrel <- function(rel_a, rel_b, ...) {
#'   new_relational(intersect(rel_a, rel_b), class = class(rel_a))
#' }
#' rel_set_intersect(rel_a, rel_b)
rel_set_intersect <- function(rel_a, rel_b, ...) {
  rel_stats_env$rel_set_intersect <- (rel_stats_env$rel_set_intersect %||% 0L) + 1L
  UseMethod("rel_set_intersect")
}

#' Lazily compute a set_diff result on a relational object
#'
#' TBD.
#'
#' @inheritParams rel_to_df
#' @inheritParams rel_set_intersect
#' @return a new relational object with the result
#' @export
#' @examples
#' rel_a <- new_relational(c(1, 1, 2), class = "vecrel")
#' rel_b <- new_relational(c(1, 3, 2), class = "vecrel")
#' rel_set_diff.vecrel <- function(rel_a, rel_b, ...) {
#'   new_relational(setdiff(rel_a, rel_b), class = class(rel_a))
#' }
#' rel_set_diff(rel_a, rel_b)
rel_set_diff <- function(rel_a, rel_b, ...) {
  rel_stats_env$rel_set_diff <- (rel_stats_env$rel_set_diff %||% 0L) + 1L
  UseMethod("rel_set_diff")
}

#' Lazily compute a set_symdiff result on a relational object
#'
#' TBD.
#'
#' @inheritParams rel_to_df
#' @inheritParams rel_set_intersect
#' @return a new relational object with the result
#' @export

#' @examples
#' rel_a <- new_relational(c(1, 1, 2), class = "vecrel")
#' rel_b <- new_relational(c(1, 3, 2), class = "vecrel")
#' rel_set_symdiff.vecrel <- function(rel_a, rel_b, ...) {
#'   class(rel_a) <- setdiff(class(rel_a), "relational")
#'   class(rel_b) <- setdiff(class(rel_b), "relational")
#'   new_relational(
#'     unique(c(setdiff(rel_a, rel_b), setdiff(rel_b, rel_a))),
#'     class = class(rel_a)
#'   )
#' }
#' rel_set_symdiff(rel_a, rel_b)
rel_set_symdiff <- function(rel_a, rel_b, ...) {
  rel_stats_env$rel_set_symdiff <- (rel_stats_env$rel_set_symdiff %||% 0L) + 1L
  UseMethod("rel_set_symdiff")
}

#' Lazily compute a set_union_all result on a relational object
#'
#' TBD.
#'
#' @inheritParams rel_to_df
#' @inheritParams rel_set_intersect
#' @return a new relational object with the result
#' @export
#' @examples
#' rel_a <- new_relational(c(1, 1, 2), class = "vecrel")
#' rel_b <- new_relational(c(1, 3, 2), class = "vecrel")
#' rel_union_all.vecrel <- function(rel_a, rel_b, ...) {
#'   new_relational(union(rel_a, rel_b), class = class(rel_a))
#' }
#' rel_union_all(rel_a, rel_b)
rel_union_all <- function(rel_a, rel_b, ...) {
  rel_stats_env$rel_union_all <- (rel_stats_env$rel_union_all %||% 0L) + 1L
  UseMethod("rel_union_all")
}

#' TBD
#'
#' TBD.
#'
#' @inheritParams rel_to_df
#' @rdname rel
#' @return A (new/modified) relational object.
#' @export
rel_tostring <- function(rel, ...) {
  rel_stats_env$rel_tostring <- (rel_stats_env$rel_tostring %||% 0L) + 1L
  UseMethod("rel_tostring")
}

#' Print the EXPLAIN output for a relational object
#'
#' TBD.
#'
#' @inheritParams rel_to_df
#' @return A (new/modified) relational object.
#' @export
#' @examples
#' mtcars_rel <- new_relational(mtcars, class = "dfrel")
#' rel_explain.dfrel <- function(rel, ...) {
#'   cat("A relational object")
#'   print(rel)
#'   invisible(rel)
#' }
#' rel_explain(mtcars_rel)
rel_explain <- function(rel, ...) {
  rel_stats_env$rel_explain <- (rel_stats_env$rel_explain %||% 0L) + 1L
  UseMethod("rel_explain")
}

#' Get the internal alias for a relational object
#'
#' TBD.
#'
#' @inheritParams rel_to_df
#' @return An alias (character).
#' @export
#' @examples
#' mtcars_rel <- new_relational(mtcars, class = "dfrel")
#' rel_alias.dfrel <- function(rel, ...) tracemem(rel)
#' rel_alias(mtcars_rel)
rel_alias <- function(rel, ...) {
  rel_stats_env$rel_alias <- (rel_stats_env$rel_alias %||% 0L) + 1L
  UseMethod("rel_alias")
}

#' Set the internal alias for a relational object
#'
#' TBD.
#'
#' @inheritParams rel_to_df
#' @param alias the new alias
#' @return A (new/modified) relational object.
#' @export
#' @examples
#' mtcars_rel <- new_relational(mtcars, class = "dfrel")
#' rel_set_alias.dfrel <- function(rel, alias,...) {
#'   attr(rel, "alias") <- alias
#'   rel
#' }
#' mtcars_rel <- rel_set_alias(mtcars_rel, "blop")
#' attr(mtcars_rel, "alias")
rel_set_alias <- function(rel, alias, ...) {
  rel_stats_env$rel_set_alias <- (rel_stats_env$rel_set_alias %||% 0L) + 1L
  UseMethod("rel_set_alias")
}

#' @rdname rel
#' @return A (new/modified) relational object.
#' @export
rel_names <- function(rel, ...) {
  rel_stats_env$rel_names <- (rel_stats_env$rel_names %||% 0L) + 1L
  UseMethod("rel_names")
}
