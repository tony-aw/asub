# asub

asub: Programmatically Friendly Subset Methods for Array-like and
Data.frame-like S3 Objects

## What is the ‘asub’ R package?

Provides programmatically friendly subset methods for arrays and
array-like S3 objects.  
  
It supports array-like objects (including matrices and 1d vectors), and
most types of data.frames, and may be more convenient alternatives to
the `[` and `[<-` operators, whilst maintaining similar performance.  
  
Some nice properties of these methods include, but are not limited to,
the following:  
  
1) Performing dimensional subset operations on an array using `[` and
`[<-`, requires a-priori knowledge on the number of dimensions the array
has;  
The ‘asub’ methods work on any arbitrary dimensions without requiring
such prior knowledge.  
  
2) The `[` and `[<-` operators use different rule-sets for different
data.frame-like types (data.frames, data.tables, tibbles, tidytables,
etc.);  
The ‘asub’ methods use the same rule-sets for the different
data.frame-like types.  
  
3) Unlike the `[` and `[<-` operators, the ‘asub’ methods will operate
on duplicate names (not just the first match), use consistent syntax for
inverting indices, give an error for out-of-bounds indices, and support
the use of advanced indices through formulas.  
  
4) The `[<-` operator only supports copy-on-modify semantics for most
classes;  
The ‘asub’ methods provide explicit pass-by-reference semantics as well
as R’s native semantics, and do so safely and memory efficiently.  
  
5) All of the methods provided by ‘squarbrackets’ are programmatically
friendly (no Non-Standard Evaluation).

 

## Motivation

‘asub’ primarily attempts to solve the following annoyances in sub-set
operations on array-like and data.frame-like objects:

- Specifying indices can sometimes be inconsistent or inconvenient.
- performing sub-set operations on arrays with an unknown number of
  dimensions can be very convoluted.
- different data.frame classes have entirely different syntax and
  semantics rules, which can be rather confusing.
- the various ‘R’ packages related to sub-set operations make to much
  use of non-standard evaluation, which is not programmatically
  friendly. ‘asub’ is 100% programmatically friendly: all input can be
  stored in a variable and re-used later, and all input has a
  predictable effect. No need for
  [`quote()`](https://rdrr.io/r/base/substitute.html) `!!!`, `{{{}}}` or
  other tidy-eval nonsense.

And, as is the case with all my packages, NO AI has been used at all in
developing ‘asub’.

 

### Indexing

There are a few annoyances in specifying indices for sub-set operations
(using `[` and `[<-`) in base ‘R’, which the ‘asub’ package attempts to
fix:

- Base ‘R’ only selects the first matching names when selecting indices
  through a character vector. ‘asub’ selects all matching names.
- Inverting indices in base ‘R’ is done in different ways. (negative
  numbers for numeric indexing, negation for logical indexing, manually
  un-matching for character vectors). ‘asub’ provides a (somewhat)
  consistent syntax to invert indices, regardless of the indexing type.

Let’s demonstrate this:

``` r
library(asub)

# create vector `x`, which has multiple elements with the name "a":
x <- 1:10
names(x) <- c(letters[1:5], letters[1:5])

x["a"] # base R: only selects only the first index with name "a"
ii_x(x, "a") # asub: selects all indices with the name "a"

x[c("a", "a")] # base R: repeats only the first index with name "a"
ii_x(x, c("a", "a")) # asub: repeats all indices with the name "a"

x[!names(x) %in% "a"] # base R: removing all elements with name "a" is awkward
ii_x(x, "a", -1) # asub: removing all elements with name "a" is straight-forward
```

 

### Arrays

In order to perform subset operations on some array `x` with the square
brackets operator (`[`, `[<-`), one needs to know how many dimensions it
has. I.e. `x[i, j, k]` for a 3D array and `x[i, j, k, l]` for a 4D
array. Using `x[i, j, k]` on an array with 4 dimensions produces an
error, since the number of indices or empty arguments does not conform
to the number of dimensions. Thus if the number of dimensions of an
array is not known a-priori, using `[` and `[<-` becomes extremely
convoluted.

The [`abind::asub()`](https://rdrr.io/pkg/abind/man/asub.html) function
solved this issue for the `[` operator, by allowing the user to
programmatically extract a sub-set of an array regardless of the number
of dimensions the array has. The ‘asub’ package is, in fact, named after
[`abind::asub()`](https://rdrr.io/pkg/abind/man/asub.html).

But implementing an equivalent method for the `[<-` operator is far more
difficult, and ‘abind’. The primary issue is: **any function-like call**
of `[<-` - whether it be `[<-(x, ...indices.., value)`,
`do.call("[<-]", list(x, indices, value))`, or even `eval(quote(...)`,
and so on - will **always** make a copy of the input. Always. To my
knowledge, ‘asub’ is the first package to get around this problem in a
safe way, thus giving the user the exact same semantics as the regular
usage of the `[<-` operator for arrays, but without the unacceptable
inefficiency of calling `[<-(x, ...indices..., value)` as a function.

An additional issue with sub-set operations on arrays with an unknown
number of dimensions arises when you need to specify more complex
indices. Consider, for example, the following array:

``` r
x <- array(1:(prod(5:3)), 5:3, list(letters[1:5], LETTERS[1:4], month.abb[1:3]))
```

Let’s extract the *last* 2 elements of each dimension in the above
array, and compare the base ‘R’ syntax with that of ‘asub’:

``` r
# base 'R':
x[c(dim(x)[1] - 1, dim(x)[1]),
  c(dim(x)[2] - 1, dim(x)[2]),
  c(dim(x)[3] - 1, dim(x)[3]),
  drop = FALSE]

# 'asub':
ss_x(x, ~ (.N-1):.N)
```

Its shorter, its cleaner, and often about as fast as base ‘R’ (though
‘asub’ does have a bit more overhead than base ‘R’). To be clear: ‘asub’
fully supports specifying indices with numeric, character, and logical
indices also.

 

### Data.frames

There are many types of data.frames. Data.frames from base ‘R’, tibbles
(from the tidyverse), data.tables (from the tinyverse and fastverse),
tidytables, as well as ‘sf-’ variants of these. They have different
syntax AND different semantics rules regarding sub-set operations.
Constantly switching between these rules can be immensely annoying.

The ‘asub’ package provides sub-set methods that works consistently and
with the same syntax for all supported types of data.frame-like objects.

Consider the following example, where values of the column “a” are being
replaced with “XXX”, but only in the rows for which holds that column
“b” is larger than 10:

``` r
tinycodet::import_as(.dpr ~ dplyr, deps = "tibble")

x <- data.frame(a = month.abb, b = 1:12)
y <- .dpr$tibble(a = month.abb, b = 1:12)
z <- data.table::data.table(a = month.abb, b = 1:12)

# with base R, which uses native semantics:
x[with(x, b > 10), "a"] <- "XXX"

# with tidyverse, which uses pass-by-value semantics:
y <- .dpr$mutate(y, a = ifelse(b > 10, "XXX", b))

# with data.table (fastverse/tinyverse), which uses pass-by-reference semantics:
z[b > 10, a := "XXX"] 
```

Different syntax, and different semantics.

Now let’s try this with ‘asub’:

``` r
x <- data.frame(a = month.abb, b = 1:12)
y <- .dpr$tibble(a = month.abb, b = 1:12)
z <- data.table::data.table(a = month.abb, b = 1:12)

# with asubL same syntax, same semantics, and NO non-standard evaluation!:
tt_mod(x, ~ b > 10, "a", rp = "XXX")
tt_mod(y, ~ b > 10, "a", rp = "XXX")
tt_mod(z, ~ b > 10, "a", rp = "XXX")
```

In ‘asub’, the user can explicitly choose the semantics: use the
`_mod()` methods for base R’s native semantics (which `[<-` uses), or
use the `_set()` methods for pass-by-reference semantics (only for
classes that support it: namely ‘data.table’ and ‘mutatomic’).

 

## Get Started

To get started see the [Get
Started](https://tony-aw.github.io/asub/articles/asub.html) page.

 

## Installing & Loading

One can install ‘asub’ from GitHub like so:

``` r
remotes::install_github("https://github.com/tony-aw/asub")
```

Special care has been taken to make sure the function names are clear,
and that the function names are unlikely to conflict with core R, the
recommended R packages, the rstudioapi package, or major packages from
the fastverse. So one can attach the package - thus exposing its
functions to the namespace - using:

``` r
library(asub)
```
