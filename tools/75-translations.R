path <- file.path("R", "translate.R")
xml <- path |>
  parse(keep.source = TRUE) |>
  xmlparsedata::xml_parse_data(pretty = TRUE) |>
  xml2::read_xml()

switch_call <- xml2::xml_find_first(
  xml,
  ".//SYMBOL_FUNCTION_CALL[text()='switch']"
)
siblings <- xml2::xml_siblings(xml2::xml_parent(switch_call))
equals <- purrr::keep(siblings, \(x) xml2::xml_name(x) == "EQ_SUB")

treat_equal <- function(equal_node) {
  left <- xml2::xml_find_all(equal_node, "preceding-sibling::*[1]") |>
    xml2::xml_text()
  right <- xml2::xml_find_all(equal_node, "following-sibling::*[1]") |>
    xml2::xml_text()
  tibble::tibble(
    fun = gsub('"', '', left),
    pkgs = right
  )
}

translated <- purrr::map_df(equals, treat_equal)
write.csv(translated, file.path("inst", "translated.csv"), row.names = FALSE)
