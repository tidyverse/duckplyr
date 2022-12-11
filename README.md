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
<span><span class='kr'><a href='https://rdrr.io/r/base/library.html'>library</a></span><span class='o'>(</span><span class='nv'><a href='https://github.com/duckdblabs/duckplyr'>duckplyr</a></span><span class='o'>)</span></span>
<span></span>
<span><span class='c'># Use `as_duckplyr_df()` to enable processing with duckdb:</span></span>
<span><span class='nv'>out</span> <span class='o'>&lt;-</span> </span>
<span>  <span class='nf'>palmerpenguins</span><span class='nf'>::</span><span class='nv'><a href='https://allisonhorst.github.io/palmerpenguins/reference/penguins.html'>penguins</a></span> <span class='o'>%&gt;%</span> </span>
<span>  <span class='nf'>as_duckplyr_df</span><span class='o'>(</span><span class='o'>)</span> <span class='o'>%&gt;%</span> </span>
<span>  <span class='nf'><a href='https://rdrr.io/r/stats/filter.html'>filter</a></span><span class='o'>(</span><span class='nv'>bill_length_mm</span> <span class='o'>&lt;</span> <span class='m'>40</span><span class='o'>)</span> <span class='o'>%&gt;%</span></span>
<span>  <span class='nf'>select</span><span class='o'>(</span><span class='o'>-</span><span class='nv'>bill_length_mm</span><span class='o'>)</span></span>
<span><span class='c'>#&gt; Error processing with relational.</span></span>
<span><span class='c'>#&gt; <span style='font-weight: bold;'>Caused by error in `FUN()`:</span></span></span>
<span><span class='c'>#&gt; <span style='color: #BBBB00;'>!</span> Unknown expr class: duckdb_expr</span></span>
<span></span>
<span><span class='c'># The result is a data frame or tibble, with its own class.</span></span>
<span><span class='nf'><a href='https://rdrr.io/r/base/class.html'>class</a></span><span class='o'>(</span><span class='nv'>out</span><span class='o'>)</span></span>
<span><span class='c'>#&gt; [1] "duckplyr_df" "tbl_df"      "tbl"         "data.frame"</span></span>
<span><span class='nf'><a href='https://rdrr.io/r/base/names.html'>names</a></span><span class='o'>(</span><span class='nv'>out</span><span class='o'>)</span></span>
<span><span class='c'>#&gt; [1] "species"           "island"            "bill_depth_mm"    </span></span>
<span><span class='c'>#&gt; [4] "flipper_length_mm" "body_mass_g"       "sex"              </span></span>
<span><span class='c'>#&gt; [7] "year"</span></span>
<span></span>
<span><span class='c'># The contents of this data frame are computed only upon request:</span></span>
<span><span class='nv'>out</span></span>
<span><span class='c'>#&gt; materializing:</span></span>
<span><span class='c'>#&gt; ---------------------</span></span>
<span><span class='c'>#&gt; --- Relation Tree ---</span></span>
<span><span class='c'>#&gt; ---------------------</span></span>
<span><span class='c'>#&gt; Projection [species as species, island as island, bill_depth_mm as bill_depth_mm, flipper_length_mm as flipper_length_mm, body_mass_g as body_mass_g, sex as sex, "year" as year]</span></span>
<span><span class='c'>#&gt;   r_dataframe_scan(0x10dc55cf8)</span></span>
<span><span class='c'>#&gt; </span></span>
<span><span class='c'>#&gt; ---------------------</span></span>
<span><span class='c'>#&gt; -- Result Columns  --</span></span>
<span><span class='c'>#&gt; ---------------------</span></span>
<span><span class='c'>#&gt; - species (species)</span></span>
<span><span class='c'>#&gt; - island (island)</span></span>
<span><span class='c'>#&gt; - bill_depth_mm (DOUBLE)</span></span>
<span><span class='c'>#&gt; - flipper_length_mm (INTEGER)</span></span>
<span><span class='c'>#&gt; - body_mass_g (INTEGER)</span></span>
<span><span class='c'>#&gt; - sex (sex)</span></span>
<span><span class='c'>#&gt; - year (INTEGER)</span></span>
<span><span class='c'>#&gt; </span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'># A tibble: 100 × 7</span></span></span>
<span><span class='c'>#&gt;    <span style='font-weight: bold;'>species</span> <span style='font-weight: bold;'>island</span>    <span style='font-weight: bold;'>bill_depth_mm</span> <span style='font-weight: bold;'>flipper_length_mm</span> <span style='font-weight: bold;'>body_mass_g</span> <span style='font-weight: bold;'>sex</span>     <span style='font-weight: bold;'>year</span></span></span>
<span><span class='c'>#&gt;    <span style='color: #555555; font-style: italic;'>&lt;fct&gt;</span>   <span style='color: #555555; font-style: italic;'>&lt;fct&gt;</span>             <span style='color: #555555; font-style: italic;'>&lt;dbl&gt;</span>             <span style='color: #555555; font-style: italic;'>&lt;int&gt;</span>       <span style='color: #555555; font-style: italic;'>&lt;int&gt;</span> <span style='color: #555555; font-style: italic;'>&lt;fct&gt;</span>  <span style='color: #555555; font-style: italic;'>&lt;int&gt;</span></span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'> 1</span> Adelie  Torgersen          18.7               181        <span style='text-decoration: underline;'>3</span>750 male    <span style='text-decoration: underline;'>2</span>007</span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'> 2</span> Adelie  Torgersen          17.4               186        <span style='text-decoration: underline;'>3</span>800 female  <span style='text-decoration: underline;'>2</span>007</span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'> 3</span> Adelie  Torgersen          19.3               193        <span style='text-decoration: underline;'>3</span>450 female  <span style='text-decoration: underline;'>2</span>007</span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'> 4</span> Adelie  Torgersen          20.6               190        <span style='text-decoration: underline;'>3</span>650 male    <span style='text-decoration: underline;'>2</span>007</span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'> 5</span> Adelie  Torgersen          17.8               181        <span style='text-decoration: underline;'>3</span>625 female  <span style='text-decoration: underline;'>2</span>007</span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'> 6</span> Adelie  Torgersen          19.6               195        <span style='text-decoration: underline;'>4</span>675 male    <span style='text-decoration: underline;'>2</span>007</span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'> 7</span> Adelie  Torgersen          18.1               193        <span style='text-decoration: underline;'>3</span>475 <span style='color: #BB0000;'>NA</span>      <span style='text-decoration: underline;'>2</span>007</span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'> 8</span> Adelie  Torgersen          17.1               186        <span style='text-decoration: underline;'>3</span>300 <span style='color: #BB0000;'>NA</span>      <span style='text-decoration: underline;'>2</span>007</span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'> 9</span> Adelie  Torgersen          17.3               180        <span style='text-decoration: underline;'>3</span>700 <span style='color: #BB0000;'>NA</span>      <span style='text-decoration: underline;'>2</span>007</span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'>10</span> Adelie  Torgersen          21.2               191        <span style='text-decoration: underline;'>3</span>800 male    <span style='text-decoration: underline;'>2</span>007</span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'># … with 90 more rows</span></span></span>
<span></span>
<span><span class='c'># Once computed, the results remain available as a data frame:</span></span>
<span><span class='nv'>out</span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'># A tibble: 100 × 7</span></span></span>
<span><span class='c'>#&gt;    <span style='font-weight: bold;'>species</span> <span style='font-weight: bold;'>island</span>    <span style='font-weight: bold;'>bill_depth_mm</span> <span style='font-weight: bold;'>flipper_length_mm</span> <span style='font-weight: bold;'>body_mass_g</span> <span style='font-weight: bold;'>sex</span>     <span style='font-weight: bold;'>year</span></span></span>
<span><span class='c'>#&gt;    <span style='color: #555555; font-style: italic;'>&lt;fct&gt;</span>   <span style='color: #555555; font-style: italic;'>&lt;fct&gt;</span>             <span style='color: #555555; font-style: italic;'>&lt;dbl&gt;</span>             <span style='color: #555555; font-style: italic;'>&lt;int&gt;</span>       <span style='color: #555555; font-style: italic;'>&lt;int&gt;</span> <span style='color: #555555; font-style: italic;'>&lt;fct&gt;</span>  <span style='color: #555555; font-style: italic;'>&lt;int&gt;</span></span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'> 1</span> Adelie  Torgersen          18.7               181        <span style='text-decoration: underline;'>3</span>750 male    <span style='text-decoration: underline;'>2</span>007</span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'> 2</span> Adelie  Torgersen          17.4               186        <span style='text-decoration: underline;'>3</span>800 female  <span style='text-decoration: underline;'>2</span>007</span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'> 3</span> Adelie  Torgersen          19.3               193        <span style='text-decoration: underline;'>3</span>450 female  <span style='text-decoration: underline;'>2</span>007</span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'> 4</span> Adelie  Torgersen          20.6               190        <span style='text-decoration: underline;'>3</span>650 male    <span style='text-decoration: underline;'>2</span>007</span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'> 5</span> Adelie  Torgersen          17.8               181        <span style='text-decoration: underline;'>3</span>625 female  <span style='text-decoration: underline;'>2</span>007</span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'> 6</span> Adelie  Torgersen          19.6               195        <span style='text-decoration: underline;'>4</span>675 male    <span style='text-decoration: underline;'>2</span>007</span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'> 7</span> Adelie  Torgersen          18.1               193        <span style='text-decoration: underline;'>3</span>475 <span style='color: #BB0000;'>NA</span>      <span style='text-decoration: underline;'>2</span>007</span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'> 8</span> Adelie  Torgersen          17.1               186        <span style='text-decoration: underline;'>3</span>300 <span style='color: #BB0000;'>NA</span>      <span style='text-decoration: underline;'>2</span>007</span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'> 9</span> Adelie  Torgersen          17.3               180        <span style='text-decoration: underline;'>3</span>700 <span style='color: #BB0000;'>NA</span>      <span style='text-decoration: underline;'>2</span>007</span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'>10</span> Adelie  Torgersen          21.2               191        <span style='text-decoration: underline;'>3</span>800 male    <span style='text-decoration: underline;'>2</span>007</span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'># … with 90 more rows</span></span></span></pre>
