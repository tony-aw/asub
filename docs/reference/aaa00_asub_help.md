# asub: Programmatically Friendly Subset Methods for Arrays and Array-like S3 Objects

asub:  
Programmatically Friendly Subset Methods for Arrays and Array-like S3
Objects.  
  
Provides programmatically friendly subset methods for arrays and
array-like S3 objects.

It supports array-like objects (including matrices and 1d vectors), and
most types of data.frames, and may be more convenient alternatives to
the `[` and `[<-` operators, whilst maintaining similar performance.

Some nice properties of these methods include, but are not limited to,
the following:

1.  Performing dimensional subset operations on an array using `[` and
    `[<-`, requires a-priori knowledge on the number of dimensions the
    array has;  
    The 'asub' methods work on any arbitrary dimensions without
    requiring such prior knowledge.

2.  The `[` and `[<-` operators use different rule-sets for different
    data.frame-like types (data.frames, data.tables, tibbles,
    tidytables, etc.);  
    The 'asub' methods use the same rule-sets for the different
    data.frame-like types.

3.  Unlike the `[` and `[<-` operators, the 'asub' methods will operate
    on duplicate names (not just the first match), use consistent syntax
    for inverting indices, give an error for out-of-bounds indices, and
    support the use of advanced indices through formulas.

4.  The `[<-` operator only supports copy-on-modify semantics for most
    classes;  
    The 'asub' methods provide explicit pass-by-reference semantics as
    well as R's native semantics, and do so safely and memory
    efficiently.

5.  All of the methods provided by 'squarbrackets' are programmatically
    friendly (no Non-Standard Evaluation).  
      

## Goal

Among programming languages, 'R' has perhaps one of the most flexible
and comprehensive sub-setting functionality, provided by the square
brackets operators (`[`, `[<-`).  
But in some situations the square brackets operators are occasionally
less than optimally convenient for arrays.  
  
The Goal of the 'asub' package is not to replace the square-brackets
operators, but to provide **alternative** sub-setting methods and
functions for arrays and array-like objects, to be used in situations
where the square bracket operators are inconvenient.  
  

## Quick Start Guide

For the Quick Start Guide, see:  
<https://tony-aw.github.io/asub/articles/asub.html>.  
  

## Overview Help Pages

**Essentials**  
The essential documentation is split into the following help pages:

- [asub_methods](https://tony-aw.github.io/asub/reference/aaa01_asub_methods.md):  
  Lists the main methods provided by 'asub'.  
  Also explains the method dispatch system in 'asub'.

- [asub_index_fundamentals](https://tony-aw.github.io/asub/reference/aaa02_asub_index_fundamentals.md):  
  Explains the essential fundamentals of the indexing forms in 'asub'.

- [asub_keywords](https://tony-aw.github.io/asub/reference/aaa11_asub_keywords.md):  
  Explains the usage of keywords in the main methods of 'asub'.  
    

**Arguments**  
The methods in 'asub' share a lot of common arguments.  
The explanations for these common arguments are given in the following
help pages:

- [asub_supported_structures](https://tony-aw.github.io/asub/reference/aaa03_asub_supported_structures.md):  
  Lists the structures that are supported by 'asub', and explains some
  related terminology.

- [asub_index_args](https://tony-aw.github.io/asub/reference/aaa04_asub_index_args.md):  
  Explains the common indexing arguments used in the main S3 methods.

- [asub_modify](https://tony-aw.github.io/asub/reference/aaa05_asub_modify.md):  
  Explains the modification-related arguments, and other essential
  information regarding modification.

- [asub_options](https://tony-aw.github.io/asub/reference/aaa06_asub_options.md):  
  Lists and explains the options the user can specify in 'asub'.  
    

**Pass-By-Reference**  
The following help pages explain the pass-by-reference semantics
provided by 'asub', and only need to be read when planning to use those
semantics:

- [asub_PassByReference](https://tony-aw.github.io/asub/reference/aaa09_asub_PassByReference.md):  
  Explains Pass-by-Reference semantics, and its important consequences.

- [asub_coercion](https://tony-aw.github.io/asub/reference/aaa10_asub_coercion.md):  
  Explains the difference in coercion rules between modification through
  Pass-by-Reference semantics and modification through copy (i.e.
  pass-by-value).  
    

## Helper Functions

A couple of convenience functions, and helper functions for creating
ranges, sequences, and indices (often needed in sub-setting) are
provided:

- [n](https://tony-aw.github.io/asub/reference/nest.md): Nested version
  of [c](https://rdrr.io/r/base/c.html), and short-hand for
  [list](https://rdrr.io/r/base/list.html).

- [ndim](https://tony-aw.github.io/asub/reference/size.md): Get the
  number of dimensions of an object.

- [ss2coord](https://tony-aw.github.io/asub/reference/ss2ii.md),
  [coord2ii](https://tony-aw.github.io/asub/reference/ss2ii.md): Convert
  subscripts (dimensional array indices) to coordinates, coordinates to
  flat indices, and vice-versa.

- [match_all](https://tony-aw.github.io/asub/reference/match_all.md):
  Find all matches, of one vector in another, taking into account the
  order and any duplicate values of both vectors.

- Computing indices:  
  [idx_by](https://tony-aw.github.io/asub/reference/idx_by.md) to
  compute grouped indices.  
    

## Properties Details

The alternative sub-setting methods and functions provided by 'asub'
have the following properties:

- **Programmatically friendly**:

  - Unlike base `[`, it's not required to know the number of dimensions
    of an array a-priori, to perform subset-operations on an array.

  - Missing arguments can be filled with `NULL`, instead of using dark
    magic like `base::quote(expr = )`.

  - No Non-standard evaluation.

  - Functions are pipe-friendly.

  - No (silent) vector recycling.

  - Extracting and removing subsets uses the same syntax.

- **Class consistent**:

  - sub-setting of multi-dimensional objects by specifying dimensions
    (i.e. rows, columns, ...) use `drop = FALSE`.  
    So matrix in, matrix out.

  - The methods deliver the same results for data.frames, data.tables,
    tibbles, and tidytables.  
    No longer does one have to re-learn the different brackets-based
    sub-setting rules for different types of data.frame-like objects.  
    Powered by the subclass agnostic 'C'-code from 'collapse' and
    'data.table'.

- **Explicit copy semantics**:

  - Sub-set operations that change its memory allocations, always return
    a modified (partial) copy of the object.  

  - For sub-set operations that just change values in-place (similar to
    the `[<-` and `[[<-` methods) the user can choose a method that
    modifies the object by **reference**, or choose a method that
    returns a **(partial) copy**.

- **Careful handling of names**:

  - Sub-setting an object by index names returns ALL matches with the
    given names, not just the first.

  - Data.frame-like objects (see supported classes below) are forced to
    have unique column names.

- **Concise function and argument names**.

- **Performance & Energy aware**:  
  Despite the many checks performed, the functions are kept reasonably
  speedy, through the use of the 'Rcpp', 'collapse', and 'data.table'
  R-packages.  
  The functions were also made to be as memory efficient as reasonably
  possible, to lower the carbon footprint of this package.  
    

## References

The badges shown in the documentation of this R-package were made using
the services of: <https://shields.io/>

## Author

**Author, Maintainer**: Tony Wilkes <tony_a_wilkes@outlook.com>
([ORCID](https://orcid.org/0000-0001-9498-8379))
