<!-- README.md is generated from README.Rmd. Please edit that file -->

# duckplyr

<!-- badges: start -->

<!-- badges: end -->

The goal of duckplyr is to …

## Installation

You can install the development version of duckplyr from [GitHub](https://github.com/) with:

<pre class='chroma'>
<span><span class='c'># install.packages("pak", repos = sprintf("https://r-lib.github.io/p/pak/stable/%s/%s/%s", .Platform$pkgType, R.Version()$os, R.Version()$arch))</span></span>
<span><span class='nf'>pak</span><span class='nf'>::</span><span class='nf'><a href='http://pak.r-lib.org/reference/pak.html'>pak</a></span><span class='o'>(</span><span class='s'>"duckdblabs/duckplyr"</span><span class='o'>)</span></span></pre>

## Example

This is a basic example which shows you how to solve a common problem:

<pre class='chroma'>
<span><span class='kr'><a href='https://rdrr.io/r/base/library.html'>library</a></span><span class='o'>(</span><span class='nv'><a href='https://duckdb.org/'>duckdb</a></span><span class='o'>)</span></span>
<span><span class='c'>#&gt; Loading required package: DBI</span></span>
<span><span class='kr'><a href='https://rdrr.io/r/base/library.html'>library</a></span><span class='o'>(</span><span class='nv'><a href='https://github.com/duckdblabs/duckplyr'>duckplyr</a></span><span class='o'>)</span></span>
<span></span>
<span><span class='c'># Use `as_duckplyr_df()` to enable processing with duckdb:</span></span>
<span><span class='nv'>out</span> <span class='o'>&lt;-</span> </span>
<span>  <span class='nf'>palmerpenguins</span><span class='nf'>::</span><span class='nv'><a href='https://allisonhorst.github.io/palmerpenguins/reference/penguins.html'>penguins</a></span> <span class='o'>%&gt;%</span> </span>
<span>  <span class='nf'>as_duckplyr_df</span><span class='o'>(</span><span class='o'>)</span> <span class='o'>%&gt;%</span> </span>
<span>  <span class='nf'>transmute</span><span class='o'>(</span>bill_area <span class='o'>=</span> <span class='nv'>bill_length_mm</span> <span class='o'>*</span> <span class='nv'>bill_depth_mm</span>, <span class='nv'>bill_length_mm</span>, <span class='nv'>species</span>, <span class='nv'>sex</span><span class='o'>)</span> <span class='o'>%&gt;%</span></span>
<span>  <span class='nf'><a href='https://rdrr.io/r/stats/filter.html'>filter</a></span><span class='o'>(</span><span class='nv'>bill_length_mm</span> <span class='o'>&lt;</span> <span class='m'>40</span><span class='o'>)</span> <span class='o'>%&gt;%</span></span>
<span>  <span class='nf'>select</span><span class='o'>(</span><span class='o'>-</span><span class='nv'>bill_length_mm</span><span class='o'>)</span></span>
<span></span>
<span><span class='c'># The result is a data frame or tibble, with its own class.</span></span>
<span><span class='nf'><a href='https://rdrr.io/r/base/class.html'>class</a></span><span class='o'>(</span><span class='nv'>out</span><span class='o'>)</span></span>
<span><span class='c'>#&gt; [1] "duckplyr_df" "tbl_df"      "tbl"         "data.frame"</span></span>
<span><span class='nf'><a href='https://rdrr.io/r/base/names.html'>names</a></span><span class='o'>(</span><span class='nv'>out</span><span class='o'>)</span></span>
<span><span class='c'>#&gt; [1] "bill_area" "species"   "sex"</span></span>
<span></span>
<span><span class='c'># duckdb is responsible for eventually carrying out the operations:</span></span>
<span><span class='nv'>out</span> <span class='o'>%&gt;%</span> </span>
<span>  <span class='nf'>explain</span><span class='o'>(</span><span class='o'>)</span></span>
<span><span class='c'>#&gt; ┌───────────────────────────┐</span></span>
<span><span class='c'>#&gt; │         PROJECTION        │</span></span>
<span><span class='c'>#&gt; │   ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─   │</span></span>
<span><span class='c'>#&gt; │         bill_area         │</span></span>
<span><span class='c'>#&gt; │          species          │</span></span>
<span><span class='c'>#&gt; │            sex            │</span></span>
<span><span class='c'>#&gt; └─────────────┬─────────────┘                             </span></span>
<span><span class='c'>#&gt; ┌─────────────┴─────────────┐</span></span>
<span><span class='c'>#&gt; │           FILTER          │</span></span>
<span><span class='c'>#&gt; │   ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─   │</span></span>
<span><span class='c'>#&gt; │  (bill_length_mm &lt; 40.0)  │</span></span>
<span><span class='c'>#&gt; └─────────────┬─────────────┘                             </span></span>
<span><span class='c'>#&gt; ┌─────────────┴─────────────┐</span></span>
<span><span class='c'>#&gt; │      R_DATAFRAME_SCAN     │</span></span>
<span><span class='c'>#&gt; │   ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─   │</span></span>
<span><span class='c'>#&gt; │         data.frame        │</span></span>
<span><span class='c'>#&gt; │   ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─   │</span></span>
<span><span class='c'>#&gt; │           EC=344          │</span></span>
<span><span class='c'>#&gt; └───────────────────────────┘</span></span>
<span></span>
<span><span class='c'># The contents of this data frame are computed only upon request:</span></span>
<span><span class='nv'>out</span></span>
<span><span class='c'>#&gt; materializing:</span></span>
<span><span class='c'>#&gt; ---------------------</span></span>
<span><span class='c'>#&gt; --- Relation Tree ---</span></span>
<span><span class='c'>#&gt; ---------------------</span></span>
<span><span class='c'>#&gt; Projection [bill_area as bill_area, species as species, sex as sex]</span></span>
<span><span class='c'>#&gt;   Filter [&lt;(bill_length_mm, 40.0)]</span></span>
<span><span class='c'>#&gt;     Projection [*(bill_length_mm, bill_depth_mm) as bill_area, bill_length_mm as bill_length_mm, species as species, sex as sex]</span></span>
<span><span class='c'>#&gt;       r_dataframe_scan(0x12c0a8a58)</span></span>
<span><span class='c'>#&gt; </span></span>
<span><span class='c'>#&gt; ---------------------</span></span>
<span><span class='c'>#&gt; -- Result Columns  --</span></span>
<span><span class='c'>#&gt; ---------------------</span></span>
<span><span class='c'>#&gt; - bill_area (DOUBLE)</span></span>
<span><span class='c'>#&gt; - species (species)</span></span>
<span><span class='c'>#&gt; - sex (sex)</span></span>
<span><span class='c'>#&gt; </span></span>
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
<span><span class='c'>#&gt; <span style='color: #555555;'># … with 90 more rows</span></span></span>
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
<span><span class='c'>#&gt; <span style='color: #555555;'># … with 90 more rows</span></span></span></pre>
