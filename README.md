<!-- README.md is generated from README.Rmd. Please edit that file -->

# duckplyr

<!-- badges: start -->

<!-- badges: end -->

The goal of duckplyr is to define a set of generics that provide a low-level implementer’s interface for dplyr’s high-level user interface.

## Installation

Once on CRAN, you can install duckplyr with:

<pre class='chroma'>
<span><span class='nf'><a href='https://rdrr.io/r/utils/install.packages.html'>install.packages</a></span><span class='o'>(</span><span class='s'>"duckplyr"</span><span class='o'>)</span></span></pre>

You can also install the development version of duckplyr from [GitHub](https://github.com/) with:

<pre class='chroma'>
<span><span class='c'># install.packages("pak", repos = sprintf("https://r-lib.github.io/p/pak/stable/%s/%s/%s", .Platform$pkgType, R.Version()$os, R.Version()$arch))</span></span>
<span><span class='nf'>pak</span><span class='nf'>::</span><span class='nf'><a href='https://pak.r-lib.org/reference/pak.html'>pak</a></span><span class='o'>(</span><span class='s'>"krlmlr/duckplyr"</span><span class='o'>)</span></span></pre>

## Example

This package only provides generics, for which other packages may then implement methods.

<pre class='chroma'>
<span><span class='kr'><a href='https://rdrr.io/r/base/library.html'>library</a></span><span class='o'>(</span><span class='nv'><a href='https://github.com/krlmlr/duckplyr'>duckplyr</a></span><span class='o'>)</span></span>
<span></span>
<span><span class='nv'>new_dfrel</span> <span class='o'>&lt;-</span> <span class='kr'>function</span><span class='o'>(</span><span class='nv'>x</span><span class='o'>)</span> <span class='o'>{</span></span>
<span>  <span class='nf'><a href='https://rdrr.io/r/base/stopifnot.html'>stopifnot</a></span><span class='o'>(</span><span class='nf'><a href='https://rdrr.io/r/base/as.data.frame.html'>is.data.frame</a></span><span class='o'>(</span><span class='nv'>x</span><span class='o'>)</span><span class='o'>)</span></span>
<span>  <span class='nf'><a href='https://krlmlr.github.io/duckplyr/reference/relational.html'>new_relational</a></span><span class='o'>(</span><span class='nf'><a href='https://rdrr.io/r/base/list.html'>list</a></span><span class='o'>(</span><span class='nv'>x</span><span class='o'>)</span>, class <span class='o'>=</span> <span class='s'>"dfrel"</span><span class='o'>)</span></span>
<span><span class='o'>}</span></span>
<span><span class='nv'>mtcars_rel</span> <span class='o'>&lt;-</span> <span class='nf'>new_dfrel</span><span class='o'>(</span><span class='nv'>mtcars</span><span class='o'>[</span><span class='m'>1</span><span class='o'>:</span><span class='m'>5</span>, <span class='m'>1</span><span class='o'>:</span><span class='m'>4</span><span class='o'>]</span><span class='o'>)</span></span>
<span></span>
<span><span class='nv'>rel_to_df.dfrel</span> <span class='o'>&lt;-</span> <span class='kr'>function</span><span class='o'>(</span><span class='nv'>rel</span>, <span class='nv'>...</span><span class='o'>)</span> <span class='o'>{</span></span>
<span>  <span class='nf'><a href='https://rdrr.io/r/base/class.html'>unclass</a></span><span class='o'>(</span><span class='nv'>rel</span><span class='o'>)</span><span class='o'>[[</span><span class='m'>1</span><span class='o'>]</span><span class='o'>]</span></span>
<span><span class='o'>}</span></span>
<span><span class='nf'><a href='https://krlmlr.github.io/duckplyr/reference/relational.html'>rel_to_df</a></span><span class='o'>(</span><span class='nv'>mtcars_rel</span><span class='o'>)</span></span>
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
<span><span class='nf'><a href='https://krlmlr.github.io/duckplyr/reference/relational.html'>rel_filter</a></span><span class='o'>(</span></span>
<span>  <span class='nv'>mtcars_rel</span>,</span>
<span>  <span class='nf'><a href='https://rdrr.io/r/base/list.html'>list</a></span><span class='o'>(</span></span>
<span>    <span class='nf'><a href='https://krlmlr.github.io/duckplyr/reference/expr.html'>relexpr_function</a></span><span class='o'>(</span></span>
<span>      <span class='s'>"gt"</span>,</span>
<span>      <span class='nf'><a href='https://rdrr.io/r/base/list.html'>list</a></span><span class='o'>(</span><span class='nf'><a href='https://krlmlr.github.io/duckplyr/reference/expr.html'>relexpr_reference</a></span><span class='o'>(</span><span class='s'>"cyl"</span><span class='o'>)</span>, <span class='nf'><a href='https://krlmlr.github.io/duckplyr/reference/expr.html'>relexpr_constant</a></span><span class='o'>(</span><span class='s'>"6"</span><span class='o'>)</span><span class='o'>)</span></span>
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
<span><span class='nf'><a href='https://krlmlr.github.io/duckplyr/reference/relational.html'>rel_project</a></span><span class='o'>(</span></span>
<span>  <span class='nv'>mtcars_rel</span>,</span>
<span>  <span class='nf'><a href='https://rdrr.io/r/base/list.html'>list</a></span><span class='o'>(</span><span class='nf'><a href='https://krlmlr.github.io/duckplyr/reference/expr.html'>relexpr_reference</a></span><span class='o'>(</span><span class='s'>"cyl"</span><span class='o'>)</span>, <span class='nf'><a href='https://krlmlr.github.io/duckplyr/reference/expr.html'>relexpr_reference</a></span><span class='o'>(</span><span class='s'>"disp"</span><span class='o'>)</span><span class='o'>)</span></span>
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
<span><span class='nf'><a href='https://krlmlr.github.io/duckplyr/reference/relational.html'>rel_order</a></span><span class='o'>(</span></span>
<span>  <span class='nv'>mtcars_rel</span>,</span>
<span>  <span class='nf'><a href='https://rdrr.io/r/base/list.html'>list</a></span><span class='o'>(</span><span class='nf'><a href='https://krlmlr.github.io/duckplyr/reference/expr.html'>relexpr_reference</a></span><span class='o'>(</span><span class='s'>"mpg"</span><span class='o'>)</span><span class='o'>)</span></span>
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
<span><span class='nf'><a href='https://krlmlr.github.io/duckplyr/reference/relational.html'>rel_join</a></span><span class='o'>(</span><span class='nf'>new_dfrel</span><span class='o'>(</span><span class='nf'><a href='https://rdrr.io/r/base/data.frame.html'>data.frame</a></span><span class='o'>(</span>mpg <span class='o'>=</span> <span class='m'>21</span><span class='o'>)</span><span class='o'>)</span>, <span class='nv'>mtcars_rel</span><span class='o'>)</span></span>
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
<span><span class='nf'><a href='https://krlmlr.github.io/duckplyr/reference/relational.html'>rel_limit</a></span><span class='o'>(</span><span class='nv'>mtcars_rel</span>, <span class='m'>3</span><span class='o'>)</span></span>
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
<span><span class='nf'><a href='https://krlmlr.github.io/duckplyr/reference/relational.html'>rel_distinct</a></span><span class='o'>(</span><span class='nf'>new_dfrel</span><span class='o'>(</span><span class='nv'>mtcars</span><span class='o'>[</span><span class='m'>1</span><span class='o'>:</span><span class='m'>3</span>, <span class='m'>1</span><span class='o'>:</span><span class='m'>4</span><span class='o'>]</span><span class='o'>)</span><span class='o'>)</span></span>
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
<span><span class='nf'><a href='https://krlmlr.github.io/duckplyr/reference/relational.html'>rel_names</a></span><span class='o'>(</span><span class='nv'>mtcars_rel</span><span class='o'>)</span></span>
<span><span class='c'>#&gt; [1] "mpg"  "cyl"  "disp" "hp"</span></span></pre>
