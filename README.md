<!-- README.md is generated from README.Rmd. Please edit that file -->

# duckplyr

<!-- badges: start -->

[![Lifecycle: experimental](https://img.shields.io/badge/lifecycle-experimental-orange.svg)](https://lifecycle.r-lib.org/articles/stages.html#experimental)

<!-- badges: end -->

The goal of duckplyr is to provide a drop-in replacement for dplyr that uses DuckDB as a backend for fast operation. It also defines a set of generics that provide a low-level implementer’s interface for dplyr’s high-level user interface.

## Installation

Once on CRAN, you can install duckplyr with:

<pre class='chroma'>
<span><span class='nf'><a href='https://rdrr.io/r/utils/install.packages.html'>install.packages</a></span><span class='o'>(</span><span class='s'>"duckplyr"</span><span class='o'>)</span></span></pre>

You can also install the development version of duckplyr from [GitHub](https://github.com/) with:

<pre class='chroma'>
<span><span class='c'># install.packages("pak", repos = sprintf("https://r-lib.github.io/p/pak/stable/%s/%s/%s", .Platform$pkgType, R.Version()$os, R.Version()$arch))</span></span>
<span><span class='nf'>pak</span><span class='nf'>::</span><span class='nf'><a href='https://pak.r-lib.org/reference/pak.html'>pak</a></span><span class='o'>(</span><span class='s'>"duckdblabs/duckplyr"</span><span class='o'>)</span></span></pre>

## Example

This is a basic example which shows you how to solve a common problem:

<pre class='chroma'>
<span><span class='kr'><a href='https://rdrr.io/r/base/library.html'>library</a></span><span class='o'>(</span><span class='nv'><a href='https://conflicted.r-lib.org/'>conflicted</a></span><span class='o'>)</span></span>
<span><span class='kr'><a href='https://rdrr.io/r/base/library.html'>library</a></span><span class='o'>(</span><span class='nv'><a href='https://github.com/duckdblabs/duckplyr'>duckplyr</a></span><span class='o'>)</span></span>
<span><span class='nf'><a href='https://conflicted.r-lib.org/reference/conflict_prefer.html'>conflict_prefer</a></span><span class='o'>(</span><span class='s'>"filter"</span>, <span class='s'>"duckplyr"</span><span class='o'>)</span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'>[conflicted]</span> Will prefer <span style='color: #0000BB; font-weight: bold;'>duckplyr</span>::filter over</span></span>
<span><span class='c'>#&gt; any other package.</span></span>
<span></span>
<span><span class='c'># Use `as_duckplyr_df()` to enable processing with duckdb:</span></span>
<span><span class='nv'>out</span> <span class='o'>&lt;-</span></span>
<span>  <span class='nf'>palmerpenguins</span><span class='nf'>::</span><span class='nv'><a href='https://allisonhorst.github.io/palmerpenguins/reference/penguins.html'>penguins</a></span> <span class='o'>%&gt;%</span></span>
<span>  <span class='nf'><a href='https://rdrr.io/pkg/duckplyr/man/as_duckplyr_df.html'>as_duckplyr_df</a></span><span class='o'>(</span><span class='o'>)</span> <span class='o'>%&gt;%</span></span>
<span>  <span class='nf'><a href='https://dplyr.tidyverse.org/reference/transmute.html'>transmute</a></span><span class='o'>(</span>bill_area <span class='o'>=</span> <span class='nv'>bill_length_mm</span> <span class='o'>*</span> <span class='nv'>bill_depth_mm</span>, <span class='nv'>bill_length_mm</span>, <span class='nv'>species</span>, <span class='nv'>sex</span><span class='o'>)</span> <span class='o'>%&gt;%</span></span>
<span>  <span class='nf'><a href='https://dplyr.tidyverse.org/reference/filter.html'>filter</a></span><span class='o'>(</span><span class='nv'>bill_length_mm</span> <span class='o'>&lt;</span> <span class='m'>40</span><span class='o'>)</span> <span class='o'>%&gt;%</span></span>
<span>  <span class='nf'><a href='https://dplyr.tidyverse.org/reference/select.html'>select</a></span><span class='o'>(</span><span class='o'>-</span><span class='nv'>bill_length_mm</span><span class='o'>)</span></span>
<span></span>
<span><span class='c'># The result is a data frame or tibble, with its own class.</span></span>
<span><span class='nf'><a href='https://rdrr.io/r/base/class.html'>class</a></span><span class='o'>(</span><span class='nv'>out</span><span class='o'>)</span></span>
<span><span class='c'>#&gt; [1] "duckplyr_df" "tbl_df"      "tbl"         "data.frame"</span></span>
<span><span class='nf'><a href='https://rdrr.io/r/base/names.html'>names</a></span><span class='o'>(</span><span class='nv'>out</span><span class='o'>)</span></span>
<span><span class='c'>#&gt; [1] "bill_area" "species"   "sex"</span></span>
<span></span>
<span><span class='c'># duckdb is responsible for eventually carrying out the operations:</span></span>
<span><span class='nv'>out</span> <span class='o'>%&gt;%</span></span>
<span>  <span class='nf'><a href='https://dplyr.tidyverse.org/reference/explain.html'>explain</a></span><span class='o'>(</span><span class='o'>)</span></span>
<span><span class='c'>#&gt; Can't convert to relational, fallback implementation will be used.</span></span>
<span></span>
<span><span class='c'># The contents of this data frame are computed only upon request:</span></span>
<span><span class='nv'>out</span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'># A tibble: 100 × 3</span></span></span>
<span><span class='c'>#&gt;    <span style='font-weight: bold;'>bill_area</span> <span style='font-weight: bold;'>species</span> <span style='font-weight: bold;'>sex</span>   </span></span>
<span><span class='c'>#&gt;        <span style='color: #555555; font-style: italic;'>&lt;dbl&gt;</span> <span style='color: #555555; font-style: italic;'>&lt;fct&gt;</span>   <span style='color: #555555; font-style: italic;'>&lt;fct&gt;</span> </span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'> 1</span>      731. Adelie  male  </span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'> 2</span>      687. Adelie  female</span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'> 3</span>      708. Adelie  female</span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'> 4</span>      810. Adelie  male  </span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'> 5</span>      692. Adelie  female</span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'> 6</span>      768. Adelie  male  </span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'> 7</span>      617. Adelie  <span style='color: #BB0000;'>NA</span>    </span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'> 8</span>      646. Adelie  <span style='color: #BB0000;'>NA</span>    </span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'> 9</span>      654. Adelie  <span style='color: #BB0000;'>NA</span>    </span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'>10</span>      818. Adelie  male  </span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'># ℹ 90 more rows</span></span></span>
<span></span>
<span><span class='c'># Once computed, the results remain available as a data frame:</span></span>
<span><span class='nv'>out</span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'># A tibble: 100 × 3</span></span></span>
<span><span class='c'>#&gt;    <span style='font-weight: bold;'>bill_area</span> <span style='font-weight: bold;'>species</span> <span style='font-weight: bold;'>sex</span>   </span></span>
<span><span class='c'>#&gt;        <span style='color: #555555; font-style: italic;'>&lt;dbl&gt;</span> <span style='color: #555555; font-style: italic;'>&lt;fct&gt;</span>   <span style='color: #555555; font-style: italic;'>&lt;fct&gt;</span> </span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'> 1</span>      731. Adelie  male  </span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'> 2</span>      687. Adelie  female</span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'> 3</span>      708. Adelie  female</span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'> 4</span>      810. Adelie  male  </span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'> 5</span>      692. Adelie  female</span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'> 6</span>      768. Adelie  male  </span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'> 7</span>      617. Adelie  <span style='color: #BB0000;'>NA</span>    </span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'> 8</span>      646. Adelie  <span style='color: #BB0000;'>NA</span>    </span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'> 9</span>      654. Adelie  <span style='color: #BB0000;'>NA</span>    </span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'>10</span>      818. Adelie  male  </span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'># ℹ 90 more rows</span></span></span></pre>

## Extensibility

This package also provides generics, for which other packages may then implement methods.

<pre class='chroma'>
<span><span class='kr'><a href='https://rdrr.io/r/base/library.html'>library</a></span><span class='o'>(</span><span class='nv'><a href='https://github.com/duckdblabs/duckplyr'>duckplyr</a></span><span class='o'>)</span></span>
<span></span>
<span><span class='nv'>new_dfrel</span> <span class='o'>&lt;-</span> <span class='kr'>function</span><span class='o'>(</span><span class='nv'>x</span><span class='o'>)</span> <span class='o'>{</span></span>
<span>  <span class='nf'><a href='https://rdrr.io/r/base/stopifnot.html'>stopifnot</a></span><span class='o'>(</span><span class='nf'><a href='https://rdrr.io/r/base/as.data.frame.html'>is.data.frame</a></span><span class='o'>(</span><span class='nv'>x</span><span class='o'>)</span><span class='o'>)</span></span>
<span>  <span class='nf'><a href='https://rdrr.io/pkg/duckplyr/man/relational.html'>new_relational</a></span><span class='o'>(</span><span class='nf'><a href='https://rdrr.io/r/base/list.html'>list</a></span><span class='o'>(</span><span class='nv'>x</span><span class='o'>)</span>, class <span class='o'>=</span> <span class='s'>"dfrel"</span><span class='o'>)</span></span>
<span><span class='o'>}</span></span>
<span><span class='nv'>mtcars_rel</span> <span class='o'>&lt;-</span> <span class='nf'>new_dfrel</span><span class='o'>(</span><span class='nv'>mtcars</span><span class='o'>[</span><span class='m'>1</span><span class='o'>:</span><span class='m'>5</span>, <span class='m'>1</span><span class='o'>:</span><span class='m'>4</span><span class='o'>]</span><span class='o'>)</span></span>
<span></span>
<span><span class='nv'>rel_to_df.dfrel</span> <span class='o'>&lt;-</span> <span class='kr'>function</span><span class='o'>(</span><span class='nv'>rel</span>, <span class='nv'>...</span><span class='o'>)</span> <span class='o'>{</span></span>
<span>  <span class='nf'><a href='https://rdrr.io/r/base/class.html'>unclass</a></span><span class='o'>(</span><span class='nv'>rel</span><span class='o'>)</span><span class='o'>[[</span><span class='m'>1</span><span class='o'>]</span><span class='o'>]</span></span>
<span><span class='o'>}</span></span>
<span><span class='nf'><a href='https://rdrr.io/pkg/duckplyr/man/relational.html'>rel_to_df</a></span><span class='o'>(</span><span class='nv'>mtcars_rel</span><span class='o'>)</span></span>
<span><span class='c'>#&gt;                    mpg cyl disp  hp</span></span>
<span><span class='c'>#&gt; Mazda RX4         21.0   6  160 110</span></span>
<span><span class='c'>#&gt; Mazda RX4 Wag     21.0   6  160 110</span></span>
<span><span class='c'>#&gt; Datsun 710        22.8   4  108  93</span></span>
<span><span class='c'>#&gt; Hornet 4 Drive    21.4   6  258 110</span></span>
<span><span class='c'>#&gt; Hornet Sportabout 18.7   8  360 175</span></span>
<span></span>
<span><span class='nv'>rel_filter.dfrel</span> <span class='o'>&lt;-</span> <span class='kr'>function</span><span class='o'>(</span><span class='nv'>rel</span>, <span class='nv'>exprs</span>, <span class='nv'>...</span><span class='o'>)</span> <span class='o'>{</span></span>
<span>  <span class='nv'>df</span> <span class='o'>&lt;-</span> <span class='nf'><a href='https://rdrr.io/r/base/class.html'>unclass</a></span><span class='o'>(</span><span class='nv'>rel</span><span class='o'>)</span><span class='o'>[[</span><span class='m'>1</span><span class='o'>]</span><span class='o'>]</span></span>
<span></span>
<span>  <span class='c'># A real implementation would evaluate the predicates defined</span></span>
<span>  <span class='c'># by the exprs argument</span></span>
<span>  <span class='nf'>new_dfrel</span><span class='o'>(</span><span class='nv'>df</span><span class='o'>[</span><span class='nf'><a href='https://rdrr.io/r/base/sample.html'>sample.int</a></span><span class='o'>(</span><span class='nf'><a href='https://rdrr.io/r/base/nrow.html'>nrow</a></span><span class='o'>(</span><span class='nv'>df</span><span class='o'>)</span>, <span class='m'>3</span>, replace <span class='o'>=</span> <span class='kc'>TRUE</span><span class='o'>)</span>, <span class='o'>]</span><span class='o'>)</span></span>
<span><span class='o'>}</span></span>
<span></span>
<span><span class='nf'><a href='https://rdrr.io/pkg/duckplyr/man/relational.html'>rel_filter</a></span><span class='o'>(</span></span>
<span>  <span class='nv'>mtcars_rel</span>,</span>
<span>  <span class='nf'><a href='https://rdrr.io/r/base/list.html'>list</a></span><span class='o'>(</span></span>
<span>    <span class='nf'><a href='https://rdrr.io/pkg/duckplyr/man/expr.html'>relexpr_function</a></span><span class='o'>(</span></span>
<span>      <span class='s'>"gt"</span>,</span>
<span>      <span class='nf'><a href='https://rdrr.io/r/base/list.html'>list</a></span><span class='o'>(</span><span class='nf'><a href='https://rdrr.io/pkg/duckplyr/man/expr.html'>relexpr_reference</a></span><span class='o'>(</span><span class='s'>"cyl"</span><span class='o'>)</span>, <span class='nf'><a href='https://rdrr.io/pkg/duckplyr/man/expr.html'>relexpr_constant</a></span><span class='o'>(</span><span class='s'>"6"</span><span class='o'>)</span><span class='o'>)</span></span>
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
<span><span class='nv'>rel_project.dfrel</span> <span class='o'>&lt;-</span> <span class='kr'>function</span><span class='o'>(</span><span class='nv'>rel</span>, <span class='nv'>exprs</span>, <span class='nv'>...</span><span class='o'>)</span> <span class='o'>{</span></span>
<span>  <span class='nv'>df</span> <span class='o'>&lt;-</span> <span class='nf'><a href='https://rdrr.io/r/base/class.html'>unclass</a></span><span class='o'>(</span><span class='nv'>rel</span><span class='o'>)</span><span class='o'>[[</span><span class='m'>1</span><span class='o'>]</span><span class='o'>]</span></span>
<span></span>
<span>  <span class='c'># A real implementation would evaluate the expressions defined</span></span>
<span>  <span class='c'># by the exprs argument</span></span>
<span>  <span class='nf'>new_dfrel</span><span class='o'>(</span><span class='nv'>df</span><span class='o'>[</span><span class='nf'><a href='https://rdrr.io/r/base/seq.html'>seq_len</a></span><span class='o'>(</span><span class='nf'><a href='https://rdrr.io/r/base/Extremes.html'>min</a></span><span class='o'>(</span><span class='m'>3</span>, <span class='nf'><a href='https://rdrr.io/r/base/nrow.html'>ncol</a></span><span class='o'>(</span><span class='nv'>df</span><span class='o'>)</span><span class='o'>)</span><span class='o'>)</span><span class='o'>]</span><span class='o'>)</span></span>
<span><span class='o'>}</span></span>
<span></span>
<span><span class='nf'><a href='https://rdrr.io/pkg/duckplyr/man/relational.html'>rel_project</a></span><span class='o'>(</span></span>
<span>  <span class='nv'>mtcars_rel</span>,</span>
<span>  <span class='nf'><a href='https://rdrr.io/r/base/list.html'>list</a></span><span class='o'>(</span><span class='nf'><a href='https://rdrr.io/pkg/duckplyr/man/expr.html'>relexpr_reference</a></span><span class='o'>(</span><span class='s'>"cyl"</span><span class='o'>)</span>, <span class='nf'><a href='https://rdrr.io/pkg/duckplyr/man/expr.html'>relexpr_reference</a></span><span class='o'>(</span><span class='s'>"disp"</span><span class='o'>)</span><span class='o'>)</span></span>
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
<span><span class='nv'>rel_order.dfrel</span> <span class='o'>&lt;-</span> <span class='kr'>function</span><span class='o'>(</span><span class='nv'>rel</span>, <span class='nv'>exprs</span>, <span class='nv'>...</span><span class='o'>)</span> <span class='o'>{</span></span>
<span>  <span class='nv'>df</span> <span class='o'>&lt;-</span> <span class='nf'><a href='https://rdrr.io/r/base/class.html'>unclass</a></span><span class='o'>(</span><span class='nv'>rel</span><span class='o'>)</span><span class='o'>[[</span><span class='m'>1</span><span class='o'>]</span><span class='o'>]</span></span>
<span></span>
<span>  <span class='c'># A real implementation would evaluate the expressions defined</span></span>
<span>  <span class='c'># by the exprs argument</span></span>
<span>  <span class='nf'>new_dfrel</span><span class='o'>(</span><span class='nv'>df</span><span class='o'>[</span><span class='nf'><a href='https://rdrr.io/r/base/order.html'>order</a></span><span class='o'>(</span><span class='nv'>df</span><span class='o'>[[</span><span class='m'>1</span><span class='o'>]</span><span class='o'>]</span><span class='o'>)</span>, <span class='o'>]</span><span class='o'>)</span></span>
<span><span class='o'>}</span></span>
<span></span>
<span><span class='nf'><a href='https://rdrr.io/pkg/duckplyr/man/relational.html'>rel_order</a></span><span class='o'>(</span></span>
<span>  <span class='nv'>mtcars_rel</span>,</span>
<span>  <span class='nf'><a href='https://rdrr.io/r/base/list.html'>list</a></span><span class='o'>(</span><span class='nf'><a href='https://rdrr.io/pkg/duckplyr/man/expr.html'>relexpr_reference</a></span><span class='o'>(</span><span class='s'>"mpg"</span><span class='o'>)</span><span class='o'>)</span></span>
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
<span><span class='nf'><a href='https://rdrr.io/pkg/duckplyr/man/relational.html'>rel_join</a></span><span class='o'>(</span><span class='nf'>new_dfrel</span><span class='o'>(</span><span class='nf'><a href='https://rdrr.io/r/base/data.frame.html'>data.frame</a></span><span class='o'>(</span>mpg <span class='o'>=</span> <span class='m'>21</span><span class='o'>)</span><span class='o'>)</span>, <span class='nv'>mtcars_rel</span><span class='o'>)</span></span>
<span><span class='c'>#&gt; Joining with `by = join_by(mpg)`</span></span>
<span><span class='c'>#&gt; [[1]]</span></span>
<span><span class='c'>#&gt;   mpg cyl disp  hp</span></span>
<span><span class='c'>#&gt; 1  21   6  160 110</span></span>
<span><span class='c'>#&gt; 2  21   6  160 110</span></span>
<span><span class='c'>#&gt; </span></span>
<span><span class='c'>#&gt; attr(,"class")</span></span>
<span><span class='c'>#&gt; [1] "dfrel"      "relational"</span></span>
<span></span>
<span><span class='nv'>rel_limit.dfrel</span> <span class='o'>&lt;-</span> <span class='kr'>function</span><span class='o'>(</span><span class='nv'>rel</span>, <span class='nv'>n</span>, <span class='nv'>...</span><span class='o'>)</span> <span class='o'>{</span></span>
<span>  <span class='nv'>df</span> <span class='o'>&lt;-</span> <span class='nf'><a href='https://rdrr.io/r/base/class.html'>unclass</a></span><span class='o'>(</span><span class='nv'>rel</span><span class='o'>)</span><span class='o'>[[</span><span class='m'>1</span><span class='o'>]</span><span class='o'>]</span></span>
<span></span>
<span>  <span class='nf'>new_dfrel</span><span class='o'>(</span><span class='nv'>df</span><span class='o'>[</span><span class='nf'><a href='https://rdrr.io/r/base/seq.html'>seq_len</a></span><span class='o'>(</span><span class='nv'>n</span><span class='o'>)</span>, <span class='o'>]</span><span class='o'>)</span></span>
<span><span class='o'>}</span></span>
<span></span>
<span><span class='nf'><a href='https://rdrr.io/pkg/duckplyr/man/relational.html'>rel_limit</a></span><span class='o'>(</span><span class='nv'>mtcars_rel</span>, <span class='m'>3</span><span class='o'>)</span></span>
<span><span class='c'>#&gt; [[1]]</span></span>
<span><span class='c'>#&gt;                mpg cyl disp  hp</span></span>
<span><span class='c'>#&gt; Mazda RX4     21.0   6  160 110</span></span>
<span><span class='c'>#&gt; Mazda RX4 Wag 21.0   6  160 110</span></span>
<span><span class='c'>#&gt; Datsun 710    22.8   4  108  93</span></span>
<span><span class='c'>#&gt; </span></span>
<span><span class='c'>#&gt; attr(,"class")</span></span>
<span><span class='c'>#&gt; [1] "dfrel"      "relational"</span></span>
<span></span>
<span><span class='nv'>rel_distinct.dfrel</span> <span class='o'>&lt;-</span> <span class='kr'>function</span><span class='o'>(</span><span class='nv'>rel</span>, <span class='nv'>...</span><span class='o'>)</span> <span class='o'>{</span></span>
<span>  <span class='nv'>df</span> <span class='o'>&lt;-</span> <span class='nf'><a href='https://rdrr.io/r/base/class.html'>unclass</a></span><span class='o'>(</span><span class='nv'>rel</span><span class='o'>)</span><span class='o'>[[</span><span class='m'>1</span><span class='o'>]</span><span class='o'>]</span></span>
<span></span>
<span>  <span class='nf'>new_dfrel</span><span class='o'>(</span><span class='nv'>df</span><span class='o'>[</span><span class='o'>!</span><span class='nf'><a href='https://rdrr.io/r/base/duplicated.html'>duplicated</a></span><span class='o'>(</span><span class='nv'>df</span><span class='o'>)</span>, <span class='o'>]</span><span class='o'>)</span></span>
<span><span class='o'>}</span></span>
<span></span>
<span><span class='nf'><a href='https://rdrr.io/pkg/duckplyr/man/relational.html'>rel_distinct</a></span><span class='o'>(</span><span class='nf'>new_dfrel</span><span class='o'>(</span><span class='nv'>mtcars</span><span class='o'>[</span><span class='m'>1</span><span class='o'>:</span><span class='m'>3</span>, <span class='m'>1</span><span class='o'>:</span><span class='m'>4</span><span class='o'>]</span><span class='o'>)</span><span class='o'>)</span></span>
<span><span class='c'>#&gt; [[1]]</span></span>
<span><span class='c'>#&gt;             mpg cyl disp  hp</span></span>
<span><span class='c'>#&gt; Mazda RX4  21.0   6  160 110</span></span>
<span><span class='c'>#&gt; Datsun 710 22.8   4  108  93</span></span>
<span><span class='c'>#&gt; </span></span>
<span><span class='c'>#&gt; attr(,"class")</span></span>
<span><span class='c'>#&gt; [1] "dfrel"      "relational"</span></span>
<span></span>
<span><span class='nv'>rel_names.dfrel</span> <span class='o'>&lt;-</span> <span class='kr'>function</span><span class='o'>(</span><span class='nv'>rel</span>, <span class='nv'>...</span><span class='o'>)</span> <span class='o'>{</span></span>
<span>  <span class='nv'>df</span> <span class='o'>&lt;-</span> <span class='nf'><a href='https://rdrr.io/r/base/class.html'>unclass</a></span><span class='o'>(</span><span class='nv'>rel</span><span class='o'>)</span><span class='o'>[[</span><span class='m'>1</span><span class='o'>]</span><span class='o'>]</span></span>
<span></span>
<span>  <span class='nf'><a href='https://rdrr.io/r/base/names.html'>names</a></span><span class='o'>(</span><span class='nv'>df</span><span class='o'>)</span></span>
<span><span class='o'>}</span></span>
<span></span>
<span><span class='nf'><a href='https://rdrr.io/pkg/duckplyr/man/relational.html'>rel_names</a></span><span class='o'>(</span><span class='nv'>mtcars_rel</span><span class='o'>)</span></span>
<span><span class='c'>#&gt; [1] "mpg"  "cyl"  "disp" "hp"</span></span></pre>
