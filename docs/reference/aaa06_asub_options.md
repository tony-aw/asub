# asub Options

This help page explains the various global options that can be set for
the 'asub' package, and how it affects the functionality.  
  

## Check Duplicates

![\[argument: chkdup\]](figures/argument-chkdup-blue.svg)  
![\[option: asub.chkdup\]](figures/option-asub_dot_chkdup-blue.svg)  
The `_x` methods are the only methods where providing duplicate indices
actually make sense.  
For the other methods, it doesn't make sense.  
Giving duplicate indices usually won't break anything.  
However, when replacing/transforming subsets, it is almost certainly not
the intention to provide duplicate indices.  
Providing duplicate indices anyway might lead to unexpected results.  
Therefore, for the methods where giving duplicate indices does not make
sense, the `chkdup` argument is present.  
This argument controls whether the method in question checks for
duplicates (`TRUE`) or not (`FALSE`).  
  
Setting `chkdup = TRUE` means the method in question will check for
duplicate indices, and give an error when it finds them.  
Inverted indices will not be checked, as inverting indices is not
sensitive to duplicates.  
  
Setting `chkdup = FALSE` will disable these checks, which saves time and
computation power, and is thus more efficient.  
  
Since checking for duplicates can be expensive, it is set to `FALSE` by
default.  
The default can be changed in the `asub.chkdup` option.  
  
  
