# Introduction to asub

``` r
library(asub)
#> Run `?asub::asub_help` to open the introduction help page of 'asub'.
set.seed(1L)
```

 

## Introduction

Provides programmatically friendly sub-set functions for array-like and
data.frame-like S3 objects.  
  
These functions supports array-like objects (including matrices and 1d
vectors), and most types of data.frames, and may be more convenient
alternatives to the `[` and `[<-` operators, whilst maintaining similar
performance.  
  
Some nice properties of these functions include, but are not limited to,
the following:  
  
1) Performing dimensional subset operations on an array using `[` and
`[<-`, requires a-priori knowledge on the number of dimensions the array
has;  
The ‘asub’ functions work on any arbitrary dimensions without requiring
such prior knowledge.  
  
2) The `[` and `[<-` operators use different rule-sets for different
data.frame-like types (data.frames, data.tables, tibbles, tidytables,
etc.);  
The ‘asub’ functions use the same rule-sets for the different
data.frame-like types.  
  
3) Unlike the `[` and `[<-` operators, the ‘asub’ functions will operate
on duplicate names (not just the first match), use consistent syntax for
inverting indices, give an error for out-of-bounds indices, and support
the use of advanced indices through formulas.  
  
4) The `[<-` operator only supports native copy-on-modify semantics for
most classes;  
The ‘asub’ functions provide explicit pass-by-reference semantics as
well as R’s native semantics, and do so safely and memory efficiently.  
  
5) All of the functions provided by ‘asub’ are programmatically friendly
(no Non-Standard Evaluation).

 

 

## Vectors: Improved Index Specification

‘asub’ provides a set of methods that work on both atomic and recursive
vectors:

- `ii_x` to extract subsets
- `ii_mod` to modify an object using R’s native semantics
- `ii_set` to modify an object by reference.

base ‘R’ supports specifying indices for sub-set operations through
logical, integer, and character vectors.  
‘asub’ enhances these capabilities, and adds more possibilities.  
The following sub-sections show *some* of these capabilities; a more
exhaustive list of the possibilities can be found in the package
documentation.

 

### Specify Indices by Names

Base ‘R’ only selects the first matching names when selecting indices
through a character vector. ‘asub’ selects all matching names.

For example:

``` r
x <- 1:10
names(x) <- c(letters[1:5], letters[1:5])
print(x) # `x` has multiple elements with the name "a"
#>  a  b  c  d  e  a  b  c  d  e 
#>  1  2  3  4  5  6  7  8  9 10

x["a"] # only selects only the first index with name "a"
#> a 
#> 1
ii_x(x, "a") # selects all indices with the name "a"
#> a a 
#> 1 6

x[c("a", "a")] # repeats only the first index with name "a"
#> a a 
#> 1 1
ii_x(x, c("a", "a")) # repeats all indices with the name "a"
#> a a a a 
#> 1 6 1 6
```

To select the indices `c("a", "a", "b")`, whilst ensuring **all**
indices with those names get selected, one needs to do the following in
base ‘R’:

``` r
x[lapply(c("a", "a", "b"), \(i)which(names(x) == i)) |> unlist()]
#> a a a a b b 
#> 1 6 1 6 2 7
```

See how much easier it is with ‘asub’:

``` r
ii_x(x, c("a", "a", "b"))
#> a a a a b b 
#> 1 6 1 6 2 7
```

Not only is the syntax shorter, the computation is also **faster**, as
‘asub’ does not rely on [`lapply()`](https://rdrr.io/r/base/lapply.html)
(or friends) to find all matching names, but uses compiled ‘C’ code
(partly from the ‘collapse’ package).

Moreover, ‘asub’ is safe in that attempting to select an non-existing
name gives an explicit error:

``` r
ii_x(x, c("xxx", "a"))
Error in ii_x.default(x, c("xxx", "a")) : unknown names given

x[c("xxx", "a")] # no error, but a silent NA added magically:
<NA>    a 
  NA    1 
```

 

### Inverting Index Specification

Inverting indices in base ‘R’ is done in different ways. (negative
numbers for numeric indexing, negation for logical indexing, manually
un-matching for character vectors).

‘asub’ provides a (somewhat) consistent syntax to invert indices, namely
through the `use` argument. Setting `use` to a negative value will
invert the indices.

As a consequence, removing sub-sets has the same syntax as extracting
indices.

For example:

``` r
x <- sample(1:10)
names(x) <- letters[1:10]

x["a"] # extract element "a" in base R
#> a 
#> 9
x[!names(x) %in% "a"] # but removing has different syntax
#>  b  c  d  e  f  g  h  i  j 
#>  4  7  1  2  5  3 10  6  8

ii_x(x, "a") # extract element "a" with 'asub'
#> a 
#> 9
ii_x(x, "a", -1) # extract all elements except "a", with 'asub'
#>  b  c  d  e  f  g  h  i  j 
#>  4  7  1  2  5  3 10  6  8
```

 

### Not Just Vectors

The given enhanced indexing is not just available for regular vectors,
but for all types supported by ‘asub’.

 

## Arrays: sub-setting unknown number of dimensions

### Introduction

In order to perform subset operations on some array `x` with the square
brackets operator (`[`, `[<-`), one needs to know how many dimensions it
has. I.e. `x[i, j, k]` for a 3D array and `x[i, j, k, l]` for a 4D
array. Using `x[i, j, k]` on an array with 4 dimensions produces an
error, since the number of indices or empty arguments does not conform
to the number of dimensions. Thus if the number of dimensions of an
array is not known a-priori, using `[` and `[<-` becomes extremely
convoluted.

‘asub’ provides a set of methods for atomic and recursive arrays, which
require no prior knowledge on the number of dimensions:

- `ss_x` to extract subsets
- `ss_mod` to modify an object using R’s native semantics
- `ss_set` to modify an object by reference.

These methods use the `s, use` argument pair to specify indices for
subset operations.

 

### General usage

`s` and `use` must be specified as follows:

- The `s` argument must be a list, specifying the subscripts
  (i.e. dimensional indices).
- The `use` argument must be an integer vector, specifying the
  dimensions for which `s` holds. Negative integers will invert indices
  (i.e. select all indices for that dimension *except* the specified
  ones).

To minimize keystrokes, ‘asub’ provides the
[`n()`](https://tony-aw.github.io/asub/reference/nest.md) function,
which is short-hand for [`list()`](https://rdrr.io/r/base/list.html);
[`n()`](https://tony-aw.github.io/asub/reference/nest.md) *nests*
multiple objects together, just like
[`c()`](https://rdrr.io/r/base/c.html) concatenates multiple objects
together.

Here’s an examples where `s` is given as a list (using
[`n()`](https://tony-aw.github.io/asub/reference/nest.md)), where we
select rows `1:3` and *remove* columns `c("a", "b")`:

``` r

# create array:
x <- array(
  1:27, # data
  dim = c(5,4,3),
  dimnames = list(NULL, c("a", "b", "b"), NULL)
)

# subset with base 'R':
x[1:3, setdiff(dimnames(x)[[2]], c("a", "b")), , drop = FALSE]

# subset with 'asub':
# Note: s = n(1:3, c("a", "b")), use = c(1, -2)
ss_x(x, n(1:3, c("a", "b")), c(1, -2))
```

In all `ss_` methods, the input variable (in this case “x”) is the first
argument, `s` is the second argument, and `use` is the third argument.

 

### Simplified usage

By default, `use = Inf`, which is equivalent to
`use = 1:length(dim(x))`. Similarly, `use = -Inf` is equivalent to
`use = -1:-length(dim(x))`, used for removing specified subscripts from
all indices.

If the subscripts are the same for all dimensions specified in `use`,
`s` can also be given as an atomic vector.

Examples where `s` can be given as a simple atomic vector, with the same
array as before.

``` r

# specify rows 1:3:
x[1:3, , , drop = FALSE] # base 'R'
ss_x(x, 1:3, 1L) # asub

# specify ALL columns "a" and "b":
x[, lapply(c("a", "b"), \(i)which(dimnames(x)[[2L]] == i)) |> unlist(), , drop = FALSE] # base 'R'
ss_x(x, c("a", "b"), 2L) # asub

# specify subscripts 1:2 of all dimensions:
x[1:2, 1:2, 1:2, drop = FALSE] # base 'R'
ss_x(x, 1:2) # asub

# remove columns 1:2:
x[, -1:-2, , drop = FALSE] # base 'R'
ss_x(x, 1:2, -2L) # asub

# remove subscripts 1:2 of all dimensions:
x[-1:-2, -1:-2, -1:-2, drop = FALSE] # base 'R'
ss_x(x, 1:2, -Inf) # asub
```

Notice that the methods from ‘asub’ are actually *shorter* to type than
their base ‘R’ equivalents.

 

### Advanced Indexing

Consider the following array:

``` r
x <- array(1:(prod(5:3)), 5:3, list(letters[1:5], LETTERS[1:4], month.abb[1:3]))
```

Extracting the first 2 elements of each dimension of this array is
relatively easy in base ‘R’:

``` r
x[1:2, 1:2, 1:2]
```

But suppose you wish to extract the **last** 2 elements of each
dimension. In base ‘R’, you would have to do something like this:

``` r
x[c(dim(x)[1] - 1, dim(x)[1]),
  c(dim(x)[2] - 1, dim(x)[2]),
  c(dim(x)[3] - 1, dim(x)[3]),
  drop = FALSE]
```

‘asub’ allows indexing by **keywords** via a formula, which allows one
to do more advanced sub-setting operations. We can do the above
operations using keywords in a few ways:

``` r
ss_x(x, ~ (.N-1):.N)

ss_x(x, ~ .bi(-2:-1))
```

‘asub’ allows users to specify indices by using keywords in a formula,
like just shown; the following keywords are available:

- `.M`: the given margin/dimension; 0 if not relevant.
- `.Nms`: the (dim)names at the given margin.
- `.N`: the size of a given dimension (if `.M` is not 0) or else the
  length of `x`.
- `.I`: equal to `seq_len(.N)`.
- `.bi(...)`: a function to specify bilateral indices.
- `.ptrn()`: a function to specify a recurring pattern.

 

Let’s use keywords to select all sub-sets whose dimnames contains a “a”,
“A”, “e” or “E”, and compare it to how to do it in base ‘R’:

``` r
library(stringi)

p <- "a|A|e|E"
# in base R:
x[stri_detect(dimnames(x)[[1]], regex = p),
  stri_detect(dimnames(x)[[2]], regex = p),
  stri_detect(dimnames(x)[[3]], regex = p),
  drop = FALSE]

# using 'asub':
ss_x(x, ~ stri_detect(.Nms, regex = p))
```

Keywords are available for vectors, arrays, and also data.frame-like
objects.

 

### No unnecessary copies

The
[`ss_mod()`](https://tony-aw.github.io/asub/reference/generic_mod.md)
function modifies an array using R’s native semantics. It needs to be
stressed that
[`ss_mod()`](https://tony-aw.github.io/asub/reference/generic_mod.md) is
set-up significantly smarter than a naïve programmatic use of “\[\<-”:
any programmatic function-like call of `[<-` - whether it be
`do.call("[<-", ...)`, `eval(quote(...)`, or even
`[<-(x, ...indices.., value)`, and so on - will always make a copy of
the input.
[`ss_mod()`](https://tony-aw.github.io/asub/reference/generic_mod.md),
however, **only** makes a copy when the regular use of `[<-` would also
make a copy. Thus
[`ss_mod()`](https://tony-aw.github.io/asub/reference/generic_mod.md) is
more memory safe and more memory efficient than any of the naïve
approaches.

 

## Data.frame: different types, different rules

There are several types of data.frame-like objects available in ‘R’:
data.frames, data.tables, tibbles, tidytables; and they all have their
own rules regarding sub-set operations.

Consider the following example, where values of the column “a” are being
replaced with “XXX”, but only in the rows for which holds that column
“b” is larger than 10:

``` r
tinycodet::import_as(.dpr ~ dplyr, deps = "tibble")

x <- data.frame(a = month.abb, b = 1:12)
y <- .dpr$tibble(a = month.abb, b = 1:12)
z <- data.table::data.table(a = month.abb, b = 1:12)

x[with(x, b > 10), "a"] <- "XXX" # with base R
y <- .dpr$mutate(y, a = ifelse(b > 10, "XXX", b)) # with tidyverse
z[b > 10, a := "XXX"] # with data.table (fastverse/tinyverse)
```

Note that the syntax is different for each type of data.frame.  
‘asub’ provides a set of methods that work consistently on all manner of
tabular (data.frames and matrix) types, with the exact same syntax:

- `tt_x` to extract subsets
- `tt_mod` to modify an object using R’s native semantics
- `tt_set` to modify an object by reference.

So let’s do the same operation as above, but now using ‘asub’:

``` r

x <- data.frame(a = month.abb, b = 1:12)
y <- tibble::tibble(a = month.abb, b = 1:12)
z <- data.table::data.table(a = month.abb, b = 1:12)

tt_mod(x, ~ b > 10, "a", rp = "XXX")
tt_mod(y, ~ b > 10, "a", rp = "XXX")
tt_mod(z, ~ b > 10, "a", rp = "XXX")

print(z)
#>          a     b
#>     <char> <int>
#>  1:    Jan     1
#>  2:    Feb     2
#>  3:    Mar     3
#>  4:    Apr     4
#>  5:    May     5
#>  6:    Jun     6
#>  7:    Jul     7
#>  8:    Aug     8
#>  9:    Sep     9
#> 10:    Oct    10
#> 11:    XXX    11
#> 12:    XXX    12
```

Notice that the syntax is exactly the same for all classes.

The original attributes are also preserved when using
[`tt_mod()`](https://tony-aw.github.io/asub/reference/generic_mod.md);
i.e. nothing is forced to become a tibble, data.table, or something
else. Input class = output class.

For data.tables specifically, the user can also use
[`tt_set()`](https://tony-aw.github.io/asub/reference/generic_set.md),
to perform pass-by-reference semantics, which is considerably faster and
more memory efficient:

``` r

z <- data.table::data.table(a = month.abb, b = 1:12)
tt_set(z, ~ b > 10, "a", rp = "XXX")
print(z)
#>          a     b
#>     <char> <int>
#>  1:    Jan     1
#>  2:    Feb     2
#>  3:    Mar     3
#>  4:    Apr     4
#>  5:    May     5
#>  6:    Jun     6
#>  7:    Jul     7
#>  8:    Aug     8
#>  9:    Sep     9
#> 10:    Oct    10
#> 11:    XXX    11
#> 12:    XXX    12
```

This is all powered by the class-agnostic ‘C’ code from the fantastic
‘collapse’ and ‘data.table’ packages.

 

## Programmatically aggregate data.table

‘asub’ provides functions like
[`dt_aggr()`](https://tony-aw.github.io/asub/reference/dt.md) to
aggregate a `data.table` programmatically:

``` r
d <- data.table::as.data.table(iris)

fun <- rep(list(mean = mean, var = var), 2L)
col <- rep(c("Sepal.Length", "Sepal.Width"), each = 2L)

# explictly naming every argument for the reader's convenience:
dt_aggr(d, row = 1:5, col = col, use = c(-1, 2), fun = fun, by = "Species")
#>       Species mean(Sepal.Length) var(Sepal.Length) mean(Sepal.Width)
#>        <fctr>              <num>             <num>             <num>
#> 1:     setosa           5.022222         0.1317677          3.444444
#> 2: versicolor           5.936000         0.2664327          2.770000
#> 3:  virginica           6.588000         0.4043429          2.974000
#>    var(Sepal.Width)
#>               <num>
#> 1:       0.15116162
#> 2:       0.09846939
#> 3:       0.10400408

# realistically shorter call:
dt_aggr(d, 1:5, col, c(-1, 2), fun, "Species")
#>       Species mean(Sepal.Length) var(Sepal.Length) mean(Sepal.Width)
#>        <fctr>              <num>             <num>             <num>
#> 1:     setosa           5.022222         0.1317677          3.444444
#> 2: versicolor           5.936000         0.2664327          2.770000
#> 3:  virginica           6.588000         0.4043429          2.974000
#>    var(Sepal.Width)
#>               <num>
#> 1:       0.15116162
#> 2:       0.09846939
#> 3:       0.10400408
```

The above is the same as the following pure data.table operation:

``` r
d[-1:-5,
  .(`mean(Sepal.Length)` = mean(Sepal.Length),
    `var(Sepal.Length)` = var(Sepal.Length),
    `mean(Sepal.Width)` = mean(Sepal.Width),
    `var(Sepal.Width)` = var(Sepal.Width)
  ),
  by = c("Species"), keyby = FALSE]
#>       Species mean(Sepal.Length) var(Sepal.Length) mean(Sepal.Width)
#>        <fctr>              <num>             <num>             <num>
#> 1:     setosa           5.022222         0.1317677          3.444444
#> 2: versicolor           5.936000         0.2664327          2.770000
#> 3:  virginica           6.588000         0.4043429          2.974000
#>    var(Sepal.Width)
#>               <num>
#> 1:       0.15116162
#> 2:       0.09846939
#> 3:       0.10400408
```

though [`dt_aggr()`](https://tony-aw.github.io/asub/reference/dt.md) is
much more programmatically friendly, and is actually short to write.

Here’s an example using an `sf-data.table`, computing the union of all
geometries, per region:

``` r

x <- sf::st_read(system.file("shape/nc.shp", package = "sf"))
#> Reading layer `nc' from data source `D:\Libs\R-4.6.1\sf\shape\nc.shp' using driver `ESRI Shapefile'
#> Simple feature collection with 100 features and 14 fields
#> Geometry type: MULTIPOLYGON
#> Dimension:     XY
#> Bounding box:  xmin: -84.32385 ymin: 33.88199 xmax: -75.45698 ymax: 36.58965
#> Geodetic CRS:  NAD27
x <- data.table::as.data.table(x)

x$region <- ifelse(x$CNTY_ID <= 2000, 'high', 'low')
d.aggr <- dt_aggr(
  x, 0L, "geometry", fun = list(union = sf::st_union), by = "region"
)

head(d.aggr)
#>    region                union(geometry)
#>    <char>             <sfc_MULTIPOLYGON>
#> 1:   high MULTIPOLYGON (((-75.78317 3...
#> 2:    low MULTIPOLYGON (((-76.46926 3...
```

 

## Pass by Reference or Pass By Value?

R’s `[<-` and `[[<-` sometimes make a copy of an object, and sometimes
they perhaps don’t. This brings 2 issues:

- Making unnecessary copies wastes memory (and speed);
- On a technical level, it may be difficult to predict if a copy is made
  or not.

Data.tables from the ‘data.table’ package natively uses
pass-by-reference semantics, meaning no copy is made. Tibbles from the
‘tidyverse’ often returns a (very wasteful) copy.

‘asub’ provides the user the ability to explicitly **choose** whether to
modify an object by reference (like data.table), or to use R’s native
semantics. The `*_mod` methods use R’s native semantics. The `*_set`
methods modify an object by reference. The `*_set` methods are only
available for the mutable classes `data.table` and `mutatomic`;
`mutatomic` is a class of mutable atomic object provided by ‘asub’ for
the explicit purpose of being able to modify atomic objects by
reference, and doing so **safely**.

 

A `mutatomic` object can be created with ease:

``` r
x <- mutatomic(seq(1L, 1e6L, 2L))
head(x)
#> [1]  1  3  5  7  9 11
#> mutatomic 
#> typeof:  integer
```

We can modify this vector by reference using the various methods that
end with `_set`.

For example like so:

``` r
ii_set(x, 1, rp = -1000L)
head(x)
#> [1] -1000     3     5     7     9    11
#> mutatomic 
#> typeof:  integer
```

The
[`ss_set()`](https://tony-aw.github.io/asub/reference/generic_set.md)
and
[`tt_set()`](https://tony-aw.github.io/asub/reference/generic_set.md)
methods similarly can modify `mutatomic` and `data.table` objects by
reference.

 

## Closing Remarks

If this introductory article has piqued your interest, I kindly invite
you to read the rest of the (admittedly rather extensive) documentation,
and perhaps try out the package for yourself.

 

 
