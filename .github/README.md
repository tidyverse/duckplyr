<!-- README.md is generated from README.Rmd. Please edit that file -->

# duckplyr <a href="https://duckplyr.tidyverse.org"><img src="logo.png" align="right" height="138" /></a>

<!-- badges: start -->

[![Lifecycle: experimental](https://img.shields.io/badge/lifecycle-experimental-orange.svg)](https://lifecycle.r-lib.org/articles/stages.html#experimental) [![R-CMD-check](https://github.com/tidyverse/duckplyr/actions/workflows/R-CMD-check.yaml/badge.svg)](https://github.com/tidyverse/duckplyr/actions/workflows/R-CMD-check.yaml)

<!-- badges: end -->

The goal of the duckplyr R package is to provide a drop-in replacement for [dplyr](https://dplyr.tidyverse.org/) that uses [DuckDB](https://duckdb.org/) as a backend for fast operation. DuckDB is an in-process OLAP database management system, dplyr is the grammar of data manipulation in the tidyverse.

duckplyr also defines a set of generics that provide a low-level implementer’s interface for dplyr’s high-level user interface.

## Installation

Install duckplyr from CRAN with:

<pre class='chroma'>
<span><span class='nf'><a href='https://rdrr.io/r/utils/install.packages.html'>install.packages</a></span><span class='o'>(</span><span class='s'>"duckplyr"</span><span class='o'>)</span></span></pre>

You can also install the development version of duckplyr from R-universe:

<pre class='chroma'>
<span><span class='nf'><a href='https://rdrr.io/r/utils/install.packages.html'>install.packages</a></span><span class='o'>(</span><span class='s'>"duckplyr"</span>, repos <span class='o'>=</span> <span class='nf'><a href='https://rdrr.io/r/base/c.html'>c</a></span><span class='o'>(</span><span class='s'>"https://tidyverse.r-universe.dev"</span>, <span class='s'>"https://cloud.r-project.org"</span><span class='o'>)</span><span class='o'>)</span></span></pre>

Or from [GitHub](https://github.com/) with:

<pre class='chroma'>
<span><span class='c'># install.packages("pak", repos = sprintf("https://r-lib.github.io/p/pak/stable/%s/%s/%s", .Platform$pkgType, R.Version()$os, R.Version()$arch))</span></span>
<span><span class='nf'>pak</span><span class='nf'>::</span><span class='nf'><a href='https://pak.r-lib.org/reference/pak.html'>pak</a></span><span class='o'>(</span><span class='s'>"tidyverse/duckplyr"</span><span class='o'>)</span></span></pre>

## Examples

<pre class='chroma'>
<span><span class='kr'><a href='https://rdrr.io/r/base/library.html'>library</a></span><span class='o'>(</span><span class='nv'><a href='https://conflicted.r-lib.org/'>conflicted</a></span><span class='o'>)</span></span>
<span><span class='kr'><a href='https://rdrr.io/r/base/library.html'>library</a></span><span class='o'>(</span><span class='nv'><a href='https://dplyr.tidyverse.org'>dplyr</a></span><span class='o'>)</span></span>
<span><span class='nf'><a href='https://conflicted.r-lib.org/reference/conflict_prefer.html'>conflict_prefer</a></span><span class='o'>(</span><span class='s'>"filter"</span>, <span class='s'>"dplyr"</span><span class='o'>)</span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'>[conflicted]</span> Will prefer <span style='color: #0000BB; font-weight: bold;'>dplyr</span>::filter over any</span></span>
<span><span class='c'>#&gt; other package.</span></span></pre>

There are two ways to use duckplyr.

1.  To enable duckplyr for individual data frames, use [`duckplyr::as_duckplyr_tibble()`](https://tidyverse.github.io/duckplyr/reference/as_duckplyr_df.html) as the first step in your pipe, without attaching the package.
2.  By calling [`library(duckplyr)`](https://duckplyr.tidyverse.org), it overwrites dplyr methods and is automatically enabled for the entire session without having to call `as_duckplyr_tibble()`. To turn this off, call `methods_restore()`.

The examples below illustrate both methods. See also the companion [demo repository](https://github.com/Tmonster/duckplyr_demo) for a use case with a large dataset.

### Usage for individual data frames

This example illustrates usage of duckplyr for individual data frames.

Use [`duckplyr::as_duckplyr_tibble()`](https://tidyverse.github.io/duckplyr/reference/as_duckplyr_df.html) to enable processing with duckdb:

<pre class='chroma'>
<span><span class='nv'>out</span> <span class='o'>&lt;-</span></span>
<span>  <span class='nf'>palmerpenguins</span><span class='nf'>::</span><span class='nv'><a href='https://allisonhorst.github.io/palmerpenguins/reference/penguins.html'>penguins</a></span> <span class='o'><a href='https://magrittr.tidyverse.org/reference/pipe.html'>%&gt;%</a></span></span>
<span>  <span class='c'># CAVEAT: factor columns are not supported yet</span></span>
<span>  <span class='nf'><a href='https://dplyr.tidyverse.org/reference/mutate.html'>mutate</a></span><span class='o'>(</span><span class='nf'><a href='https://dplyr.tidyverse.org/reference/across.html'>across</a></span><span class='o'>(</span><span class='nf'><a href='https://tidyselect.r-lib.org/reference/where.html'>where</a></span><span class='o'>(</span><span class='nv'>is.factor</span><span class='o'>)</span>, <span class='nv'>as.character</span><span class='o'>)</span><span class='o'>)</span> <span class='o'><a href='https://magrittr.tidyverse.org/reference/pipe.html'>%&gt;%</a></span></span>
<span>  <span class='nf'>duckplyr</span><span class='nf'>::</span><span class='nf'><a href='https://tidyverse.github.io/duckplyr/reference/as_duckplyr_df.html'>as_duckplyr_tibble</a></span><span class='o'>(</span><span class='o'>)</span> <span class='o'><a href='https://magrittr.tidyverse.org/reference/pipe.html'>%&gt;%</a></span></span>
<span>  <span class='nf'><a href='https://dplyr.tidyverse.org/reference/mutate.html'>mutate</a></span><span class='o'>(</span>bill_area <span class='o'>=</span> <span class='nv'>bill_length_mm</span> <span class='o'>*</span> <span class='nv'>bill_depth_mm</span><span class='o'>)</span> <span class='o'><a href='https://magrittr.tidyverse.org/reference/pipe.html'>%&gt;%</a></span></span>
<span>  <span class='nf'><a href='https://dplyr.tidyverse.org/reference/summarise.html'>summarize</a></span><span class='o'>(</span>.by <span class='o'>=</span> <span class='nf'><a href='https://rdrr.io/r/base/c.html'>c</a></span><span class='o'>(</span><span class='nv'>species</span>, <span class='nv'>sex</span><span class='o'>)</span>, mean_bill_area <span class='o'>=</span> <span class='nf'><a href='https://rdrr.io/r/base/mean.html'>mean</a></span><span class='o'>(</span><span class='nv'>bill_area</span><span class='o'>)</span><span class='o'>)</span> <span class='o'><a href='https://magrittr.tidyverse.org/reference/pipe.html'>%&gt;%</a></span></span>
<span>  <span class='nf'><a href='https://dplyr.tidyverse.org/reference/filter.html'>filter</a></span><span class='o'>(</span><span class='nv'>species</span> <span class='o'>!=</span> <span class='s'>"Gentoo"</span><span class='o'>)</span></span></pre>

The result is a tibble, with its own class.

<pre class='chroma'>
<span><span class='nf'><a href='https://rdrr.io/r/base/class.html'>class</a></span><span class='o'>(</span><span class='nv'>out</span><span class='o'>)</span></span>
<span><span class='c'>#&gt; [1] "duckplyr_df" "tbl_df"      "tbl"         "data.frame"</span></span>
<span><span class='nf'><a href='https://rdrr.io/r/base/names.html'>names</a></span><span class='o'>(</span><span class='nv'>out</span><span class='o'>)</span></span>
<span><span class='c'>#&gt; [1] "species"        "sex"            "mean_bill_area"</span></span></pre>

duckdb is responsible for eventually carrying out the operations. Despite the late filter, the summary is not computed for the Gentoo species.

<pre class='chroma'>
<span><span class='nv'>out</span> <span class='o'><a href='https://magrittr.tidyverse.org/reference/pipe.html'>%&gt;%</a></span></span>
<span>  <span class='nf'><a href='https://dplyr.tidyverse.org/reference/explain.html'>explain</a></span><span class='o'>(</span><span class='o'>)</span></span>
<span><span class='c'>#&gt; ┌───────────────────────────┐</span></span>
<span><span class='c'>#&gt; │          ORDER_BY         │</span></span>
<span><span class='c'>#&gt; │    ────────────────────   │</span></span>
<span><span class='c'>#&gt; │      dataframe_42_42      │</span></span>
<span><span class='c'>#&gt; │    42.___row_number ASC   │</span></span>
<span><span class='c'>#&gt; └─────────────┬─────────────┘</span></span>
<span><span class='c'>#&gt; ┌─────────────┴─────────────┐</span></span>
<span><span class='c'>#&gt; │           FILTER          │</span></span>
<span><span class='c'>#&gt; │    ────────────────────   │</span></span>
<span><span class='c'>#&gt; │   "r_base::!="(species,   │</span></span>
<span><span class='c'>#&gt; │         'Gentoo')         │</span></span>
<span><span class='c'>#&gt; │                           │</span></span>
<span><span class='c'>#&gt; │          ~34 Rows         │</span></span>
<span><span class='c'>#&gt; └─────────────┬─────────────┘</span></span>
<span><span class='c'>#&gt; ┌─────────────┴─────────────┐</span></span>
<span><span class='c'>#&gt; │         PROJECTION        │</span></span>
<span><span class='c'>#&gt; │    ────────────────────   │</span></span>
<span><span class='c'>#&gt; │             #0            │</span></span>
<span><span class='c'>#&gt; │             #1            │</span></span>
<span><span class='c'>#&gt; │             #2            │</span></span>
<span><span class='c'>#&gt; │             #3            │</span></span>
<span><span class='c'>#&gt; │                           │</span></span>
<span><span class='c'>#&gt; │         ~172 Rows         │</span></span>
<span><span class='c'>#&gt; └─────────────┬─────────────┘</span></span>
<span><span class='c'>#&gt; ┌─────────────┴─────────────┐</span></span>
<span><span class='c'>#&gt; │      STREAMING_WINDOW     │</span></span>
<span><span class='c'>#&gt; │    ────────────────────   │</span></span>
<span><span class='c'>#&gt; │        Projections:       │</span></span>
<span><span class='c'>#&gt; │    ROW_NUMBER() OVER ()   │</span></span>
<span><span class='c'>#&gt; └─────────────┬─────────────┘</span></span>
<span><span class='c'>#&gt; ┌─────────────┴─────────────┐</span></span>
<span><span class='c'>#&gt; │          ORDER_BY         │</span></span>
<span><span class='c'>#&gt; │    ────────────────────   │</span></span>
<span><span class='c'>#&gt; │      dataframe_42_42      │</span></span>
<span><span class='c'>#&gt; │    42.___row_number ASC   │</span></span>
<span><span class='c'>#&gt; └─────────────┬─────────────┘</span></span>
<span><span class='c'>#&gt; ┌─────────────┴─────────────┐</span></span>
<span><span class='c'>#&gt; │       HASH_GROUP_BY       │</span></span>
<span><span class='c'>#&gt; │    ────────────────────   │</span></span>
<span><span class='c'>#&gt; │          Groups:          │</span></span>
<span><span class='c'>#&gt; │             #0            │</span></span>
<span><span class='c'>#&gt; │             #1            │</span></span>
<span><span class='c'>#&gt; │                           │</span></span>
<span><span class='c'>#&gt; │        Aggregates:        │</span></span>
<span><span class='c'>#&gt; │          min(#2)          │</span></span>
<span><span class='c'>#&gt; │          mean(#3)         │</span></span>
<span><span class='c'>#&gt; │                           │</span></span>
<span><span class='c'>#&gt; │         ~172 Rows         │</span></span>
<span><span class='c'>#&gt; └─────────────┬─────────────┘</span></span>
<span><span class='c'>#&gt; ┌─────────────┴─────────────┐</span></span>
<span><span class='c'>#&gt; │         PROJECTION        │</span></span>
<span><span class='c'>#&gt; │    ────────────────────   │</span></span>
<span><span class='c'>#&gt; │          species          │</span></span>
<span><span class='c'>#&gt; │            sex            │</span></span>
<span><span class='c'>#&gt; │       ___row_number       │</span></span>
<span><span class='c'>#&gt; │         bill_area         │</span></span>
<span><span class='c'>#&gt; │                           │</span></span>
<span><span class='c'>#&gt; │         ~344 Rows         │</span></span>
<span><span class='c'>#&gt; └─────────────┬─────────────┘</span></span>
<span><span class='c'>#&gt; ┌─────────────┴─────────────┐</span></span>
<span><span class='c'>#&gt; │         PROJECTION        │</span></span>
<span><span class='c'>#&gt; │    ────────────────────   │</span></span>
<span><span class='c'>#&gt; │             #0            │</span></span>
<span><span class='c'>#&gt; │             #1            │</span></span>
<span><span class='c'>#&gt; │             #2            │</span></span>
<span><span class='c'>#&gt; │             #3            │</span></span>
<span><span class='c'>#&gt; │                           │</span></span>
<span><span class='c'>#&gt; │         ~344 Rows         │</span></span>
<span><span class='c'>#&gt; └─────────────┬─────────────┘</span></span>
<span><span class='c'>#&gt; ┌─────────────┴─────────────┐</span></span>
<span><span class='c'>#&gt; │      STREAMING_WINDOW     │</span></span>
<span><span class='c'>#&gt; │    ────────────────────   │</span></span>
<span><span class='c'>#&gt; │        Projections:       │</span></span>
<span><span class='c'>#&gt; │    ROW_NUMBER() OVER ()   │</span></span>
<span><span class='c'>#&gt; └─────────────┬─────────────┘</span></span>
<span><span class='c'>#&gt; ┌─────────────┴─────────────┐</span></span>
<span><span class='c'>#&gt; │         PROJECTION        │</span></span>
<span><span class='c'>#&gt; │    ────────────────────   │</span></span>
<span><span class='c'>#&gt; │          species          │</span></span>
<span><span class='c'>#&gt; │            sex            │</span></span>
<span><span class='c'>#&gt; │         bill_area         │</span></span>
<span><span class='c'>#&gt; │                           │</span></span>
<span><span class='c'>#&gt; │         ~344 Rows         │</span></span>
<span><span class='c'>#&gt; └─────────────┬─────────────┘</span></span>
<span><span class='c'>#&gt; ┌─────────────┴─────────────┐</span></span>
<span><span class='c'>#&gt; │     R_DATAFRAME_SCAN      │</span></span>
<span><span class='c'>#&gt; │    ────────────────────   │</span></span>
<span><span class='c'>#&gt; │         data.frame        │</span></span>
<span><span class='c'>#&gt; │                           │</span></span>
<span><span class='c'>#&gt; │        Projections:       │</span></span>
<span><span class='c'>#&gt; │          species          │</span></span>
<span><span class='c'>#&gt; │       bill_length_mm      │</span></span>
<span><span class='c'>#&gt; │       bill_depth_mm       │</span></span>
<span><span class='c'>#&gt; │            sex            │</span></span>
<span><span class='c'>#&gt; │                           │</span></span>
<span><span class='c'>#&gt; │         ~344 Rows         │</span></span>
<span><span class='c'>#&gt; └───────────────────────────┘</span></span></pre>

All data frame operations are supported. Computation happens upon the first request.

<pre class='chroma'>
<span><span class='nv'>out</span><span class='o'>$</span><span class='nv'>mean_bill_area</span></span>
<span><span class='c'>#&gt; materializing:</span></span>
<span><span class='c'>#&gt; ---------------------</span></span>
<span><span class='c'>#&gt; --- Relation Tree ---</span></span>
<span><span class='c'>#&gt; ---------------------</span></span>
<span><span class='c'>#&gt; Projection [species as species, sex as sex, mean_bill_area as mean_bill_area]</span></span>
<span><span class='c'>#&gt;   Order [___row_number ASC]</span></span>
<span><span class='c'>#&gt;     Filter ["!="(species, 'Gentoo')]</span></span>
<span><span class='c'>#&gt;       Projection [species as species, sex as sex, mean_bill_area as mean_bill_area, row_number() OVER () as ___row_number]</span></span>
<span><span class='c'>#&gt;         Projection [species as species, sex as sex, mean_bill_area as mean_bill_area]</span></span>
<span><span class='c'>#&gt;           Order [___row_number ASC]</span></span>
<span><span class='c'>#&gt;             Aggregate [species, sex, min(___row_number), mean(bill_area)]</span></span>
<span><span class='c'>#&gt;               Projection [species as species, island as island, bill_length_mm as bill_length_mm, bill_depth_mm as bill_depth_mm, flipper_length_mm as flipper_length_mm, body_mass_g as body_mass_g, sex as sex, "year" as year, bill_area as bill_area, row_number() OVER () as ___row_number]</span></span>
<span><span class='c'>#&gt;                 Projection [species as species, island as island, bill_length_mm as bill_length_mm, bill_depth_mm as bill_depth_mm, flipper_length_mm as flipper_length_mm, body_mass_g as body_mass_g, sex as sex, "year" as year, "*"(bill_length_mm, bill_depth_mm) as bill_area]</span></span>
<span><span class='c'>#&gt;                   r_dataframe_scan(0xdeadbeef)</span></span>
<span><span class='c'>#&gt; </span></span>
<span><span class='c'>#&gt; ---------------------</span></span>
<span><span class='c'>#&gt; -- Result Columns  --</span></span>
<span><span class='c'>#&gt; ---------------------</span></span>
<span><span class='c'>#&gt; - species (VARCHAR)</span></span>
<span><span class='c'>#&gt; - sex (VARCHAR)</span></span>
<span><span class='c'>#&gt; - mean_bill_area (DOUBLE)</span></span>
<span><span class='c'>#&gt; </span></span>
<span><span class='c'>#&gt; [1] 770.2627 656.8523 694.9360 819.7503 984.2279</span></span></pre>

After the computation has been carried out, the results are available immediately:

<pre class='chroma'>
<span><span class='nv'>out</span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'># A tibble: 5 × 3</span></span></span>
<span><span class='c'>#&gt;   <span style='font-weight: bold;'>species</span>   <span style='font-weight: bold;'>sex</span>    <span style='font-weight: bold;'>mean_bill_area</span></span></span>
<span><span class='c'>#&gt;   <span style='color: #555555; font-style: italic;'>&lt;chr&gt;</span>     <span style='color: #555555; font-style: italic;'>&lt;chr&gt;</span>           <span style='color: #555555; font-style: italic;'>&lt;dbl&gt;</span></span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'>1</span> Adelie    male             770.</span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'>2</span> Adelie    female           657.</span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'>3</span> Adelie    <span style='color: #BB0000;'>NA</span>               695.</span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'>4</span> Chinstrap female           820.</span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'>5</span> Chinstrap male             984.</span></span></pre>

### Session-wide usage

This example illustrates usage of duckplyr for all data frames in the R session.

Use [`library(duckplyr)`](https://duckplyr.tidyverse.org) or [`duckplyr::methods_overwrite()`](https://tidyverse.github.io/duckplyr/reference/methods_overwrite.html) to overwrite dplyr methods and enable processing with duckdb for all data frames:

<pre class='chroma'>
<span><span class='nf'>duckplyr</span><span class='nf'>::</span><span class='nf'><a href='https://tidyverse.github.io/duckplyr/reference/methods_overwrite.html'>methods_overwrite</a></span><span class='o'>(</span><span class='o'>)</span></span>
<span><span class='c'>#&gt; <span style='color: #00BB00;'>✔</span> Overwriting <span style='color: #0000BB;'>dplyr</span> methods with <span style='color: #0000BB;'>duckplyr</span> methods.</span></span>
<span><span class='c'>#&gt; <span style='color: #00BBBB;'>ℹ</span> Turn off with `duckplyr::methods_restore()`.</span></span></pre>

This is the same query as above, without `as_duckplyr_tibble()`:

<pre class='chroma'>
<span><span class='nv'>out</span> <span class='o'>&lt;-</span></span>
<span>  <span class='nf'>palmerpenguins</span><span class='nf'>::</span><span class='nv'><a href='https://allisonhorst.github.io/palmerpenguins/reference/penguins.html'>penguins</a></span> <span class='o'><a href='https://magrittr.tidyverse.org/reference/pipe.html'>%&gt;%</a></span></span>
<span>  <span class='c'># CAVEAT: factor columns are not supported yet</span></span>
<span>  <span class='nf'><a href='https://dplyr.tidyverse.org/reference/mutate.html'>mutate</a></span><span class='o'>(</span><span class='nf'><a href='https://dplyr.tidyverse.org/reference/across.html'>across</a></span><span class='o'>(</span><span class='nf'><a href='https://tidyselect.r-lib.org/reference/where.html'>where</a></span><span class='o'>(</span><span class='nv'>is.factor</span><span class='o'>)</span>, <span class='nv'>as.character</span><span class='o'>)</span><span class='o'>)</span> <span class='o'><a href='https://magrittr.tidyverse.org/reference/pipe.html'>%&gt;%</a></span></span>
<span>  <span class='nf'><a href='https://dplyr.tidyverse.org/reference/mutate.html'>mutate</a></span><span class='o'>(</span>bill_area <span class='o'>=</span> <span class='nv'>bill_length_mm</span> <span class='o'>*</span> <span class='nv'>bill_depth_mm</span><span class='o'>)</span> <span class='o'><a href='https://magrittr.tidyverse.org/reference/pipe.html'>%&gt;%</a></span></span>
<span>  <span class='nf'><a href='https://dplyr.tidyverse.org/reference/summarise.html'>summarize</a></span><span class='o'>(</span>.by <span class='o'>=</span> <span class='nf'><a href='https://rdrr.io/r/base/c.html'>c</a></span><span class='o'>(</span><span class='nv'>species</span>, <span class='nv'>sex</span><span class='o'>)</span>, mean_bill_area <span class='o'>=</span> <span class='nf'><a href='https://rdrr.io/r/base/mean.html'>mean</a></span><span class='o'>(</span><span class='nv'>bill_area</span><span class='o'>)</span><span class='o'>)</span> <span class='o'><a href='https://magrittr.tidyverse.org/reference/pipe.html'>%&gt;%</a></span></span>
<span>  <span class='nf'><a href='https://dplyr.tidyverse.org/reference/filter.html'>filter</a></span><span class='o'>(</span><span class='nv'>species</span> <span class='o'>!=</span> <span class='s'>"Gentoo"</span><span class='o'>)</span></span></pre>

The result is a plain tibble now:

<pre class='chroma'>
<span><span class='nf'><a href='https://rdrr.io/r/base/class.html'>class</a></span><span class='o'>(</span><span class='nv'>out</span><span class='o'>)</span></span>
<span><span class='c'>#&gt; [1] "tbl_df"     "tbl"        "data.frame"</span></span></pre>

Querying the number of rows also starts the computation:

<pre class='chroma'>
<span><span class='nf'><a href='https://rdrr.io/r/base/nrow.html'>nrow</a></span><span class='o'>(</span><span class='nv'>out</span><span class='o'>)</span></span>
<span><span class='c'>#&gt; materializing:</span></span>
<span><span class='c'>#&gt; ---------------------</span></span>
<span><span class='c'>#&gt; --- Relation Tree ---</span></span>
<span><span class='c'>#&gt; ---------------------</span></span>
<span><span class='c'>#&gt; Projection [species as species, sex as sex, mean_bill_area as mean_bill_area]</span></span>
<span><span class='c'>#&gt;   Order [___row_number ASC]</span></span>
<span><span class='c'>#&gt;     Filter ["!="(species, 'Gentoo')]</span></span>
<span><span class='c'>#&gt;       Projection [species as species, sex as sex, mean_bill_area as mean_bill_area, row_number() OVER () as ___row_number]</span></span>
<span><span class='c'>#&gt;         Projection [species as species, sex as sex, mean_bill_area as mean_bill_area]</span></span>
<span><span class='c'>#&gt;           Order [___row_number ASC]</span></span>
<span><span class='c'>#&gt;             Aggregate [species, sex, min(___row_number), mean(bill_area)]</span></span>
<span><span class='c'>#&gt;               Projection [species as species, island as island, bill_length_mm as bill_length_mm, bill_depth_mm as bill_depth_mm, flipper_length_mm as flipper_length_mm, body_mass_g as body_mass_g, sex as sex, "year" as year, bill_area as bill_area, row_number() OVER () as ___row_number]</span></span>
<span><span class='c'>#&gt;                 Projection [species as species, island as island, bill_length_mm as bill_length_mm, bill_depth_mm as bill_depth_mm, flipper_length_mm as flipper_length_mm, body_mass_g as body_mass_g, sex as sex, "year" as year, "*"(bill_length_mm, bill_depth_mm) as bill_area]</span></span>
<span><span class='c'>#&gt;                   r_dataframe_scan(0xdeadbeef)</span></span>
<span><span class='c'>#&gt; </span></span>
<span><span class='c'>#&gt; ---------------------</span></span>
<span><span class='c'>#&gt; -- Result Columns  --</span></span>
<span><span class='c'>#&gt; ---------------------</span></span>
<span><span class='c'>#&gt; - species (VARCHAR)</span></span>
<span><span class='c'>#&gt; - sex (VARCHAR)</span></span>
<span><span class='c'>#&gt; - mean_bill_area (DOUBLE)</span></span>
<span><span class='c'>#&gt; [1] 5</span></span></pre>

Restart R, or call [`duckplyr::methods_restore()`](https://tidyverse.github.io/duckplyr/reference/methods_overwrite.html) to revert to the default dplyr implementation.

<pre class='chroma'>
<span><span class='nf'>duckplyr</span><span class='nf'>::</span><span class='nf'><a href='https://tidyverse.github.io/duckplyr/reference/methods_overwrite.html'>methods_restore</a></span><span class='o'>(</span><span class='o'>)</span></span>
<span><span class='c'>#&gt; <span style='color: #00BBBB;'>ℹ</span> Restoring <span style='color: #0000BB;'>dplyr</span> methods.</span></span></pre>

dplyr is active again:

<pre class='chroma'>
<span><span class='nf'>palmerpenguins</span><span class='nf'>::</span><span class='nv'><a href='https://allisonhorst.github.io/palmerpenguins/reference/penguins.html'>penguins</a></span> <span class='o'><a href='https://magrittr.tidyverse.org/reference/pipe.html'>%&gt;%</a></span></span>
<span>  <span class='c'># CAVEAT: factor columns are not supported yet</span></span>
<span>  <span class='nf'><a href='https://dplyr.tidyverse.org/reference/mutate.html'>mutate</a></span><span class='o'>(</span><span class='nf'><a href='https://dplyr.tidyverse.org/reference/across.html'>across</a></span><span class='o'>(</span><span class='nf'><a href='https://tidyselect.r-lib.org/reference/where.html'>where</a></span><span class='o'>(</span><span class='nv'>is.factor</span><span class='o'>)</span>, <span class='nv'>as.character</span><span class='o'>)</span><span class='o'>)</span> <span class='o'><a href='https://magrittr.tidyverse.org/reference/pipe.html'>%&gt;%</a></span></span>
<span>  <span class='nf'><a href='https://dplyr.tidyverse.org/reference/mutate.html'>mutate</a></span><span class='o'>(</span>bill_area <span class='o'>=</span> <span class='nv'>bill_length_mm</span> <span class='o'>*</span> <span class='nv'>bill_depth_mm</span><span class='o'>)</span> <span class='o'><a href='https://magrittr.tidyverse.org/reference/pipe.html'>%&gt;%</a></span></span>
<span>  <span class='nf'><a href='https://dplyr.tidyverse.org/reference/summarise.html'>summarize</a></span><span class='o'>(</span>.by <span class='o'>=</span> <span class='nf'><a href='https://rdrr.io/r/base/c.html'>c</a></span><span class='o'>(</span><span class='nv'>species</span>, <span class='nv'>sex</span><span class='o'>)</span>, mean_bill_area <span class='o'>=</span> <span class='nf'><a href='https://rdrr.io/r/base/mean.html'>mean</a></span><span class='o'>(</span><span class='nv'>bill_area</span><span class='o'>)</span><span class='o'>)</span> <span class='o'><a href='https://magrittr.tidyverse.org/reference/pipe.html'>%&gt;%</a></span></span>
<span>  <span class='nf'><a href='https://dplyr.tidyverse.org/reference/filter.html'>filter</a></span><span class='o'>(</span><span class='nv'>species</span> <span class='o'>!=</span> <span class='s'>"Gentoo"</span><span class='o'>)</span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'># A tibble: 5 × 3</span></span></span>
<span><span class='c'>#&gt;   <span style='font-weight: bold;'>species</span>   <span style='font-weight: bold;'>sex</span>    <span style='font-weight: bold;'>mean_bill_area</span></span></span>
<span><span class='c'>#&gt;   <span style='color: #555555; font-style: italic;'>&lt;chr&gt;</span>     <span style='color: #555555; font-style: italic;'>&lt;chr&gt;</span>           <span style='color: #555555; font-style: italic;'>&lt;dbl&gt;</span></span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'>1</span> Adelie    male             770.</span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'>2</span> Adelie    female           657.</span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'>3</span> Adelie    <span style='color: #BB0000;'>NA</span>                <span style='color: #BB0000;'>NA</span> </span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'>4</span> Chinstrap female           820.</span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'>5</span> Chinstrap male             984.</span></span></pre>

## Telemetry

We would like to guide our efforts towards improving duckplyr, focusing on the features with the most impact. To this end, duckplyr collects and uploads telemetry data, but only if permitted by the user:

- No collection will happen unless the user explicitly opts in.
- Uploads are done upon request only.
- There is an option to automatically upload when the package is loaded, this is also opt-in.

The data collected contains:

- The package version
- The error message
- The operation being performed, and the arguments
  - For the input data frames, only the structure is included (column types only), no column names or data

The first time the package encounters an unsupported function, data type, or operation, instructions are printed to the console.

<pre class='chroma'>
<span><span class='nf'>palmerpenguins</span><span class='nf'>::</span><span class='nv'><a href='https://allisonhorst.github.io/palmerpenguins/reference/penguins.html'>penguins</a></span> <span class='o'><a href='https://magrittr.tidyverse.org/reference/pipe.html'>%&gt;%</a></span></span>
<span>  <span class='nf'>duckplyr</span><span class='nf'>::</span><span class='nf'><a href='https://tidyverse.github.io/duckplyr/reference/as_duckplyr_df.html'>as_duckplyr_tibble</a></span><span class='o'>(</span><span class='o'>)</span> <span class='o'><a href='https://magrittr.tidyverse.org/reference/pipe.html'>%&gt;%</a></span></span>
<span>  <span class='nf'><a href='https://dplyr.tidyverse.org/reference/transmute.html'>transmute</a></span><span class='o'>(</span>bill_area <span class='o'>=</span> <span class='nv'>bill_length_mm</span> <span class='o'>*</span> <span class='nv'>bill_depth_mm</span><span class='o'>)</span> <span class='o'><a href='https://magrittr.tidyverse.org/reference/pipe.html'>%&gt;%</a></span></span>
<span>  <span class='nf'><a href='https://rdrr.io/r/utils/head.html'>head</a></span><span class='o'>(</span><span class='m'>3</span><span class='o'>)</span></span>
<span><span class='c'>#&gt; The <span style='color: #0000BB;'>duckplyr</span> package is configured to fall back to <span style='color: #0000BB;'>dplyr</span> when it encounters an incompatibility. Fallback events can be collected and uploaded</span></span>
<span><span class='c'>#&gt; for analysis to guide future development. By default, no data will be collected or uploaded.</span></span>
<span><span class='c'>#&gt; <span style='color: #00BBBB;'>ℹ</span> A fallback situation just occurred. The following information would have been recorded:</span></span>
<span><span class='c'>#&gt;   {"version":"0.4.1","message":"Can't convert columns of class &lt;factor&gt; to relational. Affected column:</span></span>
<span><span class='c'>#&gt;   `...1`.","name":"transmute","x":{"...1":"factor","...2":"factor","...3":"numeric","...4":"numeric","...5":"integer","...6":"integer","...7":"factor","...8":"integer"},"args":{"dots":{"...9":"...3</span></span>
<span><span class='c'>#&gt;   * ...4"}}}</span></span>
<span><span class='c'>#&gt; → Run `duckplyr::fallback_sitrep()` to review the current settings.</span></span>
<span><span class='c'>#&gt; → Run `Sys.setenv(DUCKPLYR_FALLBACK_COLLECT = 1)` to enable fallback logging, and `Sys.setenv(DUCKPLYR_FALLBACK_VERBOSE = TRUE)` in addition</span></span>
<span><span class='c'>#&gt;   to enable printing of fallback situations to the console.</span></span>
<span><span class='c'>#&gt; → Run `duckplyr::fallback_review()` to review the available reports, and `duckplyr::fallback_upload()` to upload them.</span></span>
<span><span class='c'>#&gt; <span style='color: #00BBBB;'>ℹ</span> See `?duckplyr::fallback()` for details.</span></span>
<span><span class='c'>#&gt; <span style='color: #00BBBB;'>ℹ</span> <span style='color: #555555;'>This message will be displayed once every eight hours.</span></span></span>
<span><span class='c'>#&gt; materializing:</span></span>
<span><span class='c'>#&gt; ---------------------</span></span>
<span><span class='c'>#&gt; --- Relation Tree ---</span></span>
<span><span class='c'>#&gt; ---------------------</span></span>
<span><span class='c'>#&gt; Limit 3</span></span>
<span><span class='c'>#&gt;   r_dataframe_scan(0xdeadbeef)</span></span>
<span><span class='c'>#&gt; </span></span>
<span><span class='c'>#&gt; ---------------------</span></span>
<span><span class='c'>#&gt; -- Result Columns  --</span></span>
<span><span class='c'>#&gt; ---------------------</span></span>
<span><span class='c'>#&gt; - bill_area (DOUBLE)</span></span>
<span><span class='c'>#&gt; </span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'># A tibble: 3 × 1</span></span></span>
<span><span class='c'>#&gt;   <span style='font-weight: bold;'>bill_area</span></span></span>
<span><span class='c'>#&gt;       <span style='color: #555555; font-style: italic;'>&lt;dbl&gt;</span></span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'>1</span>      731.</span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'>2</span>      687.</span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'>3</span>      725.</span></span></pre>

## How is this different from dbplyr?

The duckplyr package is a dplyr backend that uses DuckDB, a high-performance, embeddable OLAP database. It is designed to be a fully compatible drop-in replacement for dplyr, with *exactly* the same syntax and semantics:

- Input and output are data frames or tibbles
- All dplyr verbs are supported, with fallback
- All R data types and functions are supported, with fallback
- No SQL is generated

The dbplyr package is a dplyr backend that connects to SQL databases, and is designed to work with various databases that support SQL, including DuckDB. Data must be copied into and collected from the database, and the syntax and semantics are similar but not identical to plain dplyr.

## Extensibility

This package also provides generics, for which other packages may then implement methods.

<pre class='chroma'>
<span><span class='kr'><a href='https://rdrr.io/r/base/library.html'>library</a></span><span class='o'>(</span><span class='nv'><a href='https://duckplyr.tidyverse.org'>duckplyr</a></span><span class='o'>)</span></span></pre>
<pre class='chroma'>
<span><span class='c'>#&gt; <span style='color: #00BB00;'>✔</span> Overwriting <span style='color: #0000BB;'>dplyr</span> methods with <span style='color: #0000BB;'>duckplyr</span> methods.</span></span>
<span><span class='c'>#&gt; <span style='color: #00BBBB;'>ℹ</span> Turn off with `duckplyr::methods_restore()`.</span></span></pre>
<pre class='chroma'>
<span><span class='c'># Create a relational to be used by examples below</span></span>
<span><span class='nv'>new_dfrel</span> <span class='o'>&lt;-</span> <span class='kr'>function</span><span class='o'>(</span><span class='nv'>x</span><span class='o'>)</span> <span class='o'>{</span></span>
<span>  <span class='nf'><a href='https://rdrr.io/r/base/stopifnot.html'>stopifnot</a></span><span class='o'>(</span><span class='nf'><a href='https://rdrr.io/r/base/as.data.frame.html'>is.data.frame</a></span><span class='o'>(</span><span class='nv'>x</span><span class='o'>)</span><span class='o'>)</span></span>
<span>  <span class='nf'><a href='https://tidyverse.github.io/duckplyr/reference/new_relational.html'>new_relational</a></span><span class='o'>(</span><span class='nf'><a href='https://rdrr.io/r/base/list.html'>list</a></span><span class='o'>(</span><span class='nv'>x</span><span class='o'>)</span>, class <span class='o'>=</span> <span class='s'>"dfrel"</span><span class='o'>)</span></span>
<span><span class='o'>}</span></span>
<span><span class='nv'>mtcars_rel</span> <span class='o'>&lt;-</span> <span class='nf'>new_dfrel</span><span class='o'>(</span><span class='nv'>mtcars</span><span class='o'>[</span><span class='m'>1</span><span class='o'>:</span><span class='m'>5</span>, <span class='m'>1</span><span class='o'>:</span><span class='m'>4</span><span class='o'>]</span><span class='o'>)</span></span>
<span></span>
<span><span class='c'># Example 1: return a data.frame</span></span>
<span><span class='nv'>rel_to_df.dfrel</span> <span class='o'>&lt;-</span> <span class='kr'>function</span><span class='o'>(</span><span class='nv'>rel</span>, <span class='nv'>...</span><span class='o'>)</span> <span class='o'>{</span></span>
<span>  <span class='nf'><a href='https://rdrr.io/r/base/class.html'>unclass</a></span><span class='o'>(</span><span class='nv'>rel</span><span class='o'>)</span><span class='o'>[[</span><span class='m'>1</span><span class='o'>]</span><span class='o'>]</span></span>
<span><span class='o'>}</span></span>
<span><span class='nf'><a href='https://tidyverse.github.io/duckplyr/reference/new_relational.html'>rel_to_df</a></span><span class='o'>(</span><span class='nv'>mtcars_rel</span><span class='o'>)</span></span>
<span><span class='c'>#&gt;                    mpg cyl disp  hp</span></span>
<span><span class='c'>#&gt; Mazda RX4         21.0   6  160 110</span></span>
<span><span class='c'>#&gt; Mazda RX4 Wag     21.0   6  160 110</span></span>
<span><span class='c'>#&gt; Datsun 710        22.8   4  108  93</span></span>
<span><span class='c'>#&gt; Hornet 4 Drive    21.4   6  258 110</span></span>
<span><span class='c'>#&gt; Hornet Sportabout 18.7   8  360 175</span></span>
<span></span>
<span><span class='c'># Example 2: A (random) filter</span></span>
<span><span class='nv'>rel_filter.dfrel</span> <span class='o'>&lt;-</span> <span class='kr'>function</span><span class='o'>(</span><span class='nv'>rel</span>, <span class='nv'>exprs</span>, <span class='nv'>...</span><span class='o'>)</span> <span class='o'>{</span></span>
<span>  <span class='nv'>df</span> <span class='o'>&lt;-</span> <span class='nf'><a href='https://rdrr.io/r/base/class.html'>unclass</a></span><span class='o'>(</span><span class='nv'>rel</span><span class='o'>)</span><span class='o'>[[</span><span class='m'>1</span><span class='o'>]</span><span class='o'>]</span></span>
<span></span>
<span>  <span class='c'># A real implementation would evaluate the predicates defined</span></span>
<span>  <span class='c'># by the exprs argument</span></span>
<span>  <span class='nf'>new_dfrel</span><span class='o'>(</span><span class='nv'>df</span><span class='o'>[</span><span class='nf'><a href='https://rdrr.io/r/base/sample.html'>sample.int</a></span><span class='o'>(</span><span class='nf'><a href='https://rdrr.io/r/base/nrow.html'>nrow</a></span><span class='o'>(</span><span class='nv'>df</span><span class='o'>)</span>, <span class='m'>3</span>, replace <span class='o'>=</span> <span class='kc'>TRUE</span><span class='o'>)</span>, <span class='o'>]</span><span class='o'>)</span></span>
<span><span class='o'>}</span></span>
<span></span>
<span><span class='nf'><a href='https://tidyverse.github.io/duckplyr/reference/new_relational.html'>rel_filter</a></span><span class='o'>(</span></span>
<span>  <span class='nv'>mtcars_rel</span>,</span>
<span>  <span class='nf'><a href='https://rdrr.io/r/base/list.html'>list</a></span><span class='o'>(</span></span>
<span>    <span class='nf'><a href='https://tidyverse.github.io/duckplyr/reference/new_relexpr.html'>relexpr_function</a></span><span class='o'>(</span></span>
<span>      <span class='s'>"gt"</span>,</span>
<span>      <span class='nf'><a href='https://rdrr.io/r/base/list.html'>list</a></span><span class='o'>(</span><span class='nf'><a href='https://tidyverse.github.io/duckplyr/reference/new_relexpr.html'>relexpr_reference</a></span><span class='o'>(</span><span class='s'>"cyl"</span><span class='o'>)</span>, <span class='nf'><a href='https://tidyverse.github.io/duckplyr/reference/new_relexpr.html'>relexpr_constant</a></span><span class='o'>(</span><span class='s'>"6"</span><span class='o'>)</span><span class='o'>)</span></span>
<span>    <span class='o'>)</span></span>
<span>  <span class='o'>)</span></span>
<span><span class='o'>)</span></span>
<span><span class='c'>#&gt; [[1]]</span></span>
<span><span class='c'>#&gt;                  mpg cyl disp  hp</span></span>
<span><span class='c'>#&gt; Mazda RX4 Wag   21.0   6  160 110</span></span>
<span><span class='c'>#&gt; Mazda RX4 Wag.1 21.0   6  160 110</span></span>
<span><span class='c'>#&gt; Datsun 710      22.8   4  108  93</span></span>
<span><span class='c'>#&gt; </span></span>
<span><span class='c'>#&gt; attr(,"class")</span></span>
<span><span class='c'>#&gt; [1] "dfrel"      "relational"</span></span>
<span></span>
<span><span class='c'># Example 3: A custom projection</span></span>
<span><span class='nv'>rel_project.dfrel</span> <span class='o'>&lt;-</span> <span class='kr'>function</span><span class='o'>(</span><span class='nv'>rel</span>, <span class='nv'>exprs</span>, <span class='nv'>...</span><span class='o'>)</span> <span class='o'>{</span></span>
<span>  <span class='nv'>df</span> <span class='o'>&lt;-</span> <span class='nf'><a href='https://rdrr.io/r/base/class.html'>unclass</a></span><span class='o'>(</span><span class='nv'>rel</span><span class='o'>)</span><span class='o'>[[</span><span class='m'>1</span><span class='o'>]</span><span class='o'>]</span></span>
<span></span>
<span>  <span class='c'># A real implementation would evaluate the expressions defined</span></span>
<span>  <span class='c'># by the exprs argument</span></span>
<span>  <span class='nf'>new_dfrel</span><span class='o'>(</span><span class='nv'>df</span><span class='o'>[</span><span class='nf'><a href='https://rdrr.io/r/base/seq.html'>seq_len</a></span><span class='o'>(</span><span class='nf'><a href='https://rdrr.io/r/base/Extremes.html'>min</a></span><span class='o'>(</span><span class='m'>3</span>, <span class='nf'><a href='https://rdrr.io/r/base/nrow.html'>ncol</a></span><span class='o'>(</span><span class='nv'>df</span><span class='o'>)</span><span class='o'>)</span><span class='o'>)</span><span class='o'>]</span><span class='o'>)</span></span>
<span><span class='o'>}</span></span>
<span></span>
<span><span class='nf'><a href='https://tidyverse.github.io/duckplyr/reference/new_relational.html'>rel_project</a></span><span class='o'>(</span></span>
<span>  <span class='nv'>mtcars_rel</span>,</span>
<span>  <span class='nf'><a href='https://rdrr.io/r/base/list.html'>list</a></span><span class='o'>(</span><span class='nf'><a href='https://tidyverse.github.io/duckplyr/reference/new_relexpr.html'>relexpr_reference</a></span><span class='o'>(</span><span class='s'>"cyl"</span><span class='o'>)</span>, <span class='nf'><a href='https://tidyverse.github.io/duckplyr/reference/new_relexpr.html'>relexpr_reference</a></span><span class='o'>(</span><span class='s'>"disp"</span><span class='o'>)</span><span class='o'>)</span></span>
<span><span class='o'>)</span></span>
<span><span class='c'>#&gt; [[1]]</span></span>
<span><span class='c'>#&gt;                    mpg cyl disp</span></span>
<span><span class='c'>#&gt; Mazda RX4         21.0   6  160</span></span>
<span><span class='c'>#&gt; Mazda RX4 Wag     21.0   6  160</span></span>
<span><span class='c'>#&gt; Datsun 710        22.8   4  108</span></span>
<span><span class='c'>#&gt; Hornet 4 Drive    21.4   6  258</span></span>
<span><span class='c'>#&gt; Hornet Sportabout 18.7   8  360</span></span>
<span><span class='c'>#&gt; </span></span>
<span><span class='c'>#&gt; attr(,"class")</span></span>
<span><span class='c'>#&gt; [1] "dfrel"      "relational"</span></span>
<span></span>
<span><span class='c'># Example 4: A custom ordering (eg, ascending by mpg)</span></span>
<span><span class='nv'>rel_order.dfrel</span> <span class='o'>&lt;-</span> <span class='kr'>function</span><span class='o'>(</span><span class='nv'>rel</span>, <span class='nv'>exprs</span>, <span class='nv'>...</span><span class='o'>)</span> <span class='o'>{</span></span>
<span>  <span class='nv'>df</span> <span class='o'>&lt;-</span> <span class='nf'><a href='https://rdrr.io/r/base/class.html'>unclass</a></span><span class='o'>(</span><span class='nv'>rel</span><span class='o'>)</span><span class='o'>[[</span><span class='m'>1</span><span class='o'>]</span><span class='o'>]</span></span>
<span></span>
<span>  <span class='c'># A real implementation would evaluate the expressions defined</span></span>
<span>  <span class='c'># by the exprs argument</span></span>
<span>  <span class='nf'>new_dfrel</span><span class='o'>(</span><span class='nv'>df</span><span class='o'>[</span><span class='nf'><a href='https://rdrr.io/r/base/order.html'>order</a></span><span class='o'>(</span><span class='nv'>df</span><span class='o'>[[</span><span class='m'>1</span><span class='o'>]</span><span class='o'>]</span><span class='o'>)</span>, <span class='o'>]</span><span class='o'>)</span></span>
<span><span class='o'>}</span></span>
<span></span>
<span><span class='nf'><a href='https://tidyverse.github.io/duckplyr/reference/new_relational.html'>rel_order</a></span><span class='o'>(</span></span>
<span>  <span class='nv'>mtcars_rel</span>,</span>
<span>  <span class='nf'><a href='https://rdrr.io/r/base/list.html'>list</a></span><span class='o'>(</span><span class='nf'><a href='https://tidyverse.github.io/duckplyr/reference/new_relexpr.html'>relexpr_reference</a></span><span class='o'>(</span><span class='s'>"mpg"</span><span class='o'>)</span><span class='o'>)</span></span>
<span><span class='o'>)</span></span>
<span><span class='c'>#&gt; [[1]]</span></span>
<span><span class='c'>#&gt;                    mpg cyl disp  hp</span></span>
<span><span class='c'>#&gt; Hornet Sportabout 18.7   8  360 175</span></span>
<span><span class='c'>#&gt; Mazda RX4         21.0   6  160 110</span></span>
<span><span class='c'>#&gt; Mazda RX4 Wag     21.0   6  160 110</span></span>
<span><span class='c'>#&gt; Hornet 4 Drive    21.4   6  258 110</span></span>
<span><span class='c'>#&gt; Datsun 710        22.8   4  108  93</span></span>
<span><span class='c'>#&gt; </span></span>
<span><span class='c'>#&gt; attr(,"class")</span></span>
<span><span class='c'>#&gt; [1] "dfrel"      "relational"</span></span>
<span></span>
<span><span class='c'># Example 5: A custom join</span></span>
<span><span class='nv'>rel_join.dfrel</span> <span class='o'>&lt;-</span> <span class='kr'>function</span><span class='o'>(</span><span class='nv'>left</span>, <span class='nv'>right</span>, <span class='nv'>conds</span>, <span class='nv'>join</span>, <span class='nv'>...</span><span class='o'>)</span> <span class='o'>{</span></span>
<span>  <span class='nv'>left_df</span> <span class='o'>&lt;-</span> <span class='nf'><a href='https://rdrr.io/r/base/class.html'>unclass</a></span><span class='o'>(</span><span class='nv'>left</span><span class='o'>)</span><span class='o'>[[</span><span class='m'>1</span><span class='o'>]</span><span class='o'>]</span></span>
<span>  <span class='nv'>right_df</span> <span class='o'>&lt;-</span> <span class='nf'><a href='https://rdrr.io/r/base/class.html'>unclass</a></span><span class='o'>(</span><span class='nv'>right</span><span class='o'>)</span><span class='o'>[[</span><span class='m'>1</span><span class='o'>]</span><span class='o'>]</span></span>
<span></span>
<span>  <span class='c'># A real implementation would evaluate the expressions</span></span>
<span>  <span class='c'># defined by the conds argument,</span></span>
<span>  <span class='c'># use different join types based on the join argument,</span></span>
<span>  <span class='c'># and implement the join itself instead of relaying to left_join().</span></span>
<span>  <span class='nf'>new_dfrel</span><span class='o'>(</span><span class='nf'>dplyr</span><span class='nf'>::</span><span class='nf'><a href='https://dplyr.tidyverse.org/reference/mutate-joins.html'>left_join</a></span><span class='o'>(</span><span class='nv'>left_df</span>, <span class='nv'>right_df</span><span class='o'>)</span><span class='o'>)</span></span>
<span><span class='o'>}</span></span>
<span></span>
<span><span class='nf'><a href='https://tidyverse.github.io/duckplyr/reference/new_relational.html'>rel_join</a></span><span class='o'>(</span><span class='nf'>new_dfrel</span><span class='o'>(</span><span class='nf'><a href='https://rdrr.io/r/base/data.frame.html'>data.frame</a></span><span class='o'>(</span>mpg <span class='o'>=</span> <span class='m'>21</span><span class='o'>)</span><span class='o'>)</span>, <span class='nv'>mtcars_rel</span><span class='o'>)</span></span>
<span><span class='c'>#&gt; Joining with `by = join_by(mpg)`</span></span>
<span><span class='c'>#&gt; Joining with `by = join_by(mpg)`</span></span>
<span><span class='c'>#&gt; [[1]]</span></span>
<span><span class='c'>#&gt;   mpg cyl disp  hp</span></span>
<span><span class='c'>#&gt; 1  21   6  160 110</span></span>
<span><span class='c'>#&gt; 2  21   6  160 110</span></span>
<span><span class='c'>#&gt; </span></span>
<span><span class='c'>#&gt; attr(,"class")</span></span>
<span><span class='c'>#&gt; [1] "dfrel"      "relational"</span></span>
<span></span>
<span><span class='c'># Example 6: Limit the maximum rows returned</span></span>
<span><span class='nv'>rel_limit.dfrel</span> <span class='o'>&lt;-</span> <span class='kr'>function</span><span class='o'>(</span><span class='nv'>rel</span>, <span class='nv'>n</span>, <span class='nv'>...</span><span class='o'>)</span> <span class='o'>{</span></span>
<span>  <span class='nv'>df</span> <span class='o'>&lt;-</span> <span class='nf'><a href='https://rdrr.io/r/base/class.html'>unclass</a></span><span class='o'>(</span><span class='nv'>rel</span><span class='o'>)</span><span class='o'>[[</span><span class='m'>1</span><span class='o'>]</span><span class='o'>]</span></span>
<span></span>
<span>  <span class='nf'>new_dfrel</span><span class='o'>(</span><span class='nv'>df</span><span class='o'>[</span><span class='nf'><a href='https://rdrr.io/r/base/seq.html'>seq_len</a></span><span class='o'>(</span><span class='nv'>n</span><span class='o'>)</span>, <span class='o'>]</span><span class='o'>)</span></span>
<span><span class='o'>}</span></span>
<span></span>
<span><span class='nf'><a href='https://tidyverse.github.io/duckplyr/reference/new_relational.html'>rel_limit</a></span><span class='o'>(</span><span class='nv'>mtcars_rel</span>, <span class='m'>3</span><span class='o'>)</span></span>
<span><span class='c'>#&gt; [[1]]</span></span>
<span><span class='c'>#&gt;                mpg cyl disp  hp</span></span>
<span><span class='c'>#&gt; Mazda RX4     21.0   6  160 110</span></span>
<span><span class='c'>#&gt; Mazda RX4 Wag 21.0   6  160 110</span></span>
<span><span class='c'>#&gt; Datsun 710    22.8   4  108  93</span></span>
<span><span class='c'>#&gt; </span></span>
<span><span class='c'>#&gt; attr(,"class")</span></span>
<span><span class='c'>#&gt; [1] "dfrel"      "relational"</span></span>
<span></span>
<span><span class='c'># Example 7: Suppress duplicate rows</span></span>
<span><span class='c'>#  (ignoring row names)</span></span>
<span><span class='nv'>rel_distinct.dfrel</span> <span class='o'>&lt;-</span> <span class='kr'>function</span><span class='o'>(</span><span class='nv'>rel</span>, <span class='nv'>...</span><span class='o'>)</span> <span class='o'>{</span></span>
<span>  <span class='nv'>df</span> <span class='o'>&lt;-</span> <span class='nf'><a href='https://rdrr.io/r/base/class.html'>unclass</a></span><span class='o'>(</span><span class='nv'>rel</span><span class='o'>)</span><span class='o'>[[</span><span class='m'>1</span><span class='o'>]</span><span class='o'>]</span></span>
<span></span>
<span>  <span class='nf'>new_dfrel</span><span class='o'>(</span><span class='nv'>df</span><span class='o'>[</span><span class='o'>!</span><span class='nf'><a href='https://rdrr.io/r/base/duplicated.html'>duplicated</a></span><span class='o'>(</span><span class='nv'>df</span><span class='o'>)</span>, <span class='o'>]</span><span class='o'>)</span></span>
<span><span class='o'>}</span></span>
<span></span>
<span><span class='nf'><a href='https://tidyverse.github.io/duckplyr/reference/new_relational.html'>rel_distinct</a></span><span class='o'>(</span><span class='nf'>new_dfrel</span><span class='o'>(</span><span class='nv'>mtcars</span><span class='o'>[</span><span class='m'>1</span><span class='o'>:</span><span class='m'>3</span>, <span class='m'>1</span><span class='o'>:</span><span class='m'>4</span><span class='o'>]</span><span class='o'>)</span><span class='o'>)</span></span>
<span><span class='c'>#&gt; [[1]]</span></span>
<span><span class='c'>#&gt;             mpg cyl disp  hp</span></span>
<span><span class='c'>#&gt; Mazda RX4  21.0   6  160 110</span></span>
<span><span class='c'>#&gt; Datsun 710 22.8   4  108  93</span></span>
<span><span class='c'>#&gt; </span></span>
<span><span class='c'>#&gt; attr(,"class")</span></span>
<span><span class='c'>#&gt; [1] "dfrel"      "relational"</span></span>
<span></span>
<span><span class='c'># Example 8: Return column names</span></span>
<span><span class='nv'>rel_names.dfrel</span> <span class='o'>&lt;-</span> <span class='kr'>function</span><span class='o'>(</span><span class='nv'>rel</span>, <span class='nv'>...</span><span class='o'>)</span> <span class='o'>{</span></span>
<span>  <span class='nv'>df</span> <span class='o'>&lt;-</span> <span class='nf'><a href='https://rdrr.io/r/base/class.html'>unclass</a></span><span class='o'>(</span><span class='nv'>rel</span><span class='o'>)</span><span class='o'>[[</span><span class='m'>1</span><span class='o'>]</span><span class='o'>]</span></span>
<span></span>
<span>  <span class='nf'><a href='https://rdrr.io/r/base/names.html'>names</a></span><span class='o'>(</span><span class='nv'>df</span><span class='o'>)</span></span>
<span><span class='o'>}</span></span>
<span></span>
<span><span class='nf'><a href='https://tidyverse.github.io/duckplyr/reference/new_relational.html'>rel_names</a></span><span class='o'>(</span><span class='nv'>mtcars_rel</span><span class='o'>)</span></span>
<span><span class='c'>#&gt; [1] "mpg"  "cyl"  "disp" "hp"</span></span></pre>
