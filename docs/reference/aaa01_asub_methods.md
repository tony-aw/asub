# Methods Available in 'asub'

This help page gives an overview of the methods available in 'asub'.  
  

## Main Methods

The main methods of 'asub' use the naming convention
`<indexform>_<operation>`:  
`<indexform>` tells you what form of indices the method uses;  
`<operation>` tells you **what operation** is performed.  
  
For the `<indexform>` part, the following is available:

- `ii_`: operates on subsets of atomic/recursive vectors/arrays by
  [interior
  indices](https://tony-aw.github.io/asub/reference/aaa02_asub_index_fundamentals.md).

- `ss_`: operates on subsets of atomic/recursive arrays of any
  dimensionality by
  [subscripts](https://tony-aw.github.io/asub/reference/aaa02_asub_index_fundamentals.md).

- `tt_`: operates on subsets of data.frames and atomic/recursive
  matrices by [tabular
  indices](https://tony-aw.github.io/asub/reference/aaa02_asub_index_fundamentals.md)
  (also known as tabulat tiles).

For the `<operation>` part, the following is available:

- `_x`: extract, exchange, exclude, or duplicate (if applicable)
  subsets.

- `_mod`: modify subsets using R's native modification semantics.

- `_set`: modify subsets using [pass-by-reference
  semantics](https://tony-aw.github.io/asub/reference/aaa09_asub_PassByReference.md).

To illustrate, let's take the methods used for extracting subsets
(`_x`):

- If `y` is a vector or array (of any dimension),  
  `ii_x(y, i)` corresponds to `y[i]`.

- If `y` is a 3d array,  
  `ss_x(y, n(i, k), c(1, 3))` corresponds to `y[i, , k, drop = FALSE]`.

- If `y` is a matrix or data.frame-like object,  
  `tt_x(y, i, j)` corresponds to `y[i, j, drop = FALSE]`.  
    

## Specialized Methods

The main methods of 'asub' are applicable for all supported types and
classes (provided the correct method for the correct dimensionality is
used).  
'asub' also provides specialized methods specific to certain structures:

- the [lst\_](https://tony-aw.github.io/asub/reference/lst_rec.md) set
  of methods, which deal with sub-set operations that are only relevant
  for (nested) lists, but not for the other types of supported objects.

- the [dt\_](https://tony-aw.github.io/asub/reference/dt.md) set of
  methods, which deal with sub-set operations that are only relevant for
  data.tables.  
    

## Other Methods

Besides the previously mentioned methods, 'asub' provides some
additional methods that do not neatly fit into the above methods.  
These are the set of `sb_` methods, which cover miscellaneous operations
for atomic/recursive objects.  
  

## Finding the Appropriate Help Pages

With knowledge of the naming convention of the main methods, one can
easily find out information about a particular method by usign the `?`
operator.  
So to find out about modifying objects by subscripts using
Pass-by-Reference semantics, type in:  
[`?ss_set`](https://tony-aw.github.io/asub/reference/generic_set.md)  
  

## 'asub' Methods that do not require explicit Dispatches

The `ii_ / ss_ / tt_ - _x` methods are essentially wrappers around the
`[` operator.  
Similarly, the `ii_ / ss_ / tt_ - _mod` methods are essentially wrappers
around the `[<-` operator.  
And the [lst_rec](https://tony-aw.github.io/asub/reference/lst_rec.md)
and [lst_recin](https://tony-aw.github.io/asub/reference/lst_rec.md)
methods are essentially wrappers around the `[[` and `[[<-` operators.  
Therefore, any custom class that has method dispatches defined for the
`[`, `[<-`, `[[`, and `[[<-` methods, have their dispatches
automatically handled by the above named methods.  
  

## Class support for the Pass-By-Reference Methods

The `_set` methods only support the mutable classes `data.table` and
`mutatomic`.  
Other mutable classes are not supported by the 'asub' package.  
However, other 'R' package authors are welcome to add additional method
dispatches for the `_set` methods.  
  
