<!-- README.md is generated from README.Rmd. Please edit that file -->

# duckplyr

<!-- badges: start -->

<!-- badges: end -->

The goal of duckplyr is to define a set of generics that provide a low-level implementer’s interface for dplyr’s high-level user interface.

## Installation

You can install the development version of duckplyr from [GitHub](https://github.com/) with:

<pre class='chroma'>
<span><span class='c'># install.packages("pak", repos = sprintf("https://r-lib.github.io/p/pak/stable/%s/%s/%s", .Platform$pkgType, R.Version()$os, R.Version()$arch))</span></span>
<span><span class='nf'>pak</span><span class='nf'>::</span><span class='nf'><a href='http://pak.r-lib.org/reference/pak.html'>pak</a></span><span class='o'>(</span><span class='s'>"krlmlr/duckplyr"</span><span class='o'>)</span></span></pre>

## Example

This package only provides generics, for which other packages may then implement methods.

<pre class='chroma'>
<span><span class='kr'><a href='https://rdrr.io/r/base/library.html'>library</a></span><span class='o'>(</span><span class='nv'><a href='https://github.com/krlmlr/duckplyr'>duckplyr</a></span><span class='o'>)</span></span>
<span></span>
<span><span class='nv'>rel_to_df.dfrel</span> <span class='o'>&lt;-</span> <span class='kr'>function</span><span class='o'>(</span><span class='nv'>rel</span>, <span class='nv'>...</span><span class='o'>)</span> <span class='o'>{</span></span>
<span> <span class='nf'><a href='https://rdrr.io/r/base/class.html'>unclass</a></span><span class='o'>(</span><span class='nv'>rel</span><span class='o'>)</span><span class='o'>[[</span><span class='m'>1</span><span class='o'>]</span><span class='o'>]</span></span>
<span><span class='o'>}</span></span>
<span></span>
<span><span class='nv'>rel_limit.dfrel</span> <span class='o'>&lt;-</span> <span class='kr'>function</span><span class='o'>(</span><span class='nv'>rel</span>, <span class='nv'>n</span>, <span class='nv'>...</span><span class='o'>)</span> <span class='o'>{</span></span>
<span>  <span class='nf'><a href='https://krlmlr.github.io/duckplyr/reference/new_relational.html'>new_relational</a></span><span class='o'>(</span></span>
<span>    <span class='nf'><a href='https://rdrr.io/r/base/list.html'>list</a></span><span class='o'>(</span><span class='nf'><a href='https://rdrr.io/r/utils/head.html'>head</a></span><span class='o'>(</span><span class='nf'><a href='https://rdrr.io/r/base/class.html'>unclass</a></span><span class='o'>(</span><span class='nv'>rel</span><span class='o'>)</span><span class='o'>[[</span><span class='m'>1</span><span class='o'>]</span><span class='o'>]</span>, <span class='nv'>n</span><span class='o'>)</span><span class='o'>)</span>,</span>
<span>    class <span class='o'>=</span> <span class='s'>"dfrel"</span></span>
<span>  <span class='o'>)</span></span>
<span><span class='o'>}</span></span>
<span></span>
<span><span class='nv'>mtcars_rel</span> <span class='o'>&lt;-</span> <span class='nf'><a href='https://krlmlr.github.io/duckplyr/reference/new_relational.html'>new_relational</a></span><span class='o'>(</span><span class='nf'><a href='https://rdrr.io/r/base/list.html'>list</a></span><span class='o'>(</span><span class='nv'>mtcars</span><span class='o'>)</span>, class <span class='o'>=</span> <span class='s'>"dfrel"</span><span class='o'>)</span></span>
<span><span class='nv'>mtcars_rel</span> <span class='o'>|&gt;</span></span>
<span>  <span class='nf'><a href='https://krlmlr.github.io/duckplyr/reference/rel_limit.html'>rel_limit</a></span><span class='o'>(</span><span class='m'>5</span><span class='o'>)</span> <span class='o'>|&gt;</span></span>
<span>  <span class='nf'><a href='https://krlmlr.github.io/duckplyr/reference/rel_to_df.html'>rel_to_df</a></span><span class='o'>(</span><span class='o'>)</span></span>
<span><span class='c'>#&gt;                    mpg cyl disp  hp drat    wt  qsec vs am gear carb</span></span>
<span><span class='c'>#&gt; Mazda RX4         21.0   6  160 110 3.90 2.620 16.46  0  1    4    4</span></span>
<span><span class='c'>#&gt; Mazda RX4 Wag     21.0   6  160 110 3.90 2.875 17.02  0  1    4    4</span></span>
<span><span class='c'>#&gt; Datsun 710        22.8   4  108  93 3.85 2.320 18.61  1  1    4    1</span></span>
<span><span class='c'>#&gt; Hornet 4 Drive    21.4   6  258 110 3.08 3.215 19.44  1  0    3    1</span></span>
<span><span class='c'>#&gt; Hornet Sportabout 18.7   8  360 175 3.15 3.440 17.02  0  0    3    2</span></span></pre>
