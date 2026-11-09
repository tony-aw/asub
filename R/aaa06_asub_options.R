#' asub Options
#'
#' 
#' @description
#' This help page explains the various global options that can be set for the 'asub' package,
#' and how it affects the functionality. \cr \cr
#' 
#' 
#' @section Check Duplicates:
#' `r .mybadge_option("argument", "chkdup")` \cr
#' `r .mybadge_option("option", "chkdup")` \cr
#' The `_x` methods are the only methods
#' where providing duplicate indices actually make sense. \cr
#' For the other methods, it doesn't make sense. \cr
#' Giving duplicate indices usually won't break anything. \cr
#' However, when replacing/transforming subsets,
#' it is almost certainly not the intention to provide duplicate indices. \cr
#' Providing duplicate indices anyway might lead to unexpected results. \cr
#' Therefore, for the methods where giving duplicate indices does not make sense,
#' the `chkdup` argument is present. \cr
#' This argument controls whether the method in question checks for duplicates (`TRUE`) or not (`FALSE`). \cr
#' \cr
#' Setting `chkdup = TRUE` means the method in question will check for duplicate indices,
#' and give an error when it finds them. \cr
#' Inverted indices will not be checked, as inverting indices is not sensitive to duplicates. \cr
#' \cr
#' Setting `chkdup = FALSE` will disable these checks,
#' which saves time and computation power, and is thus more efficient. \cr
#' \cr
#' Since checking for duplicates can be expensive, it is set to `FALSE` by default. \cr
#' The default can be changed in the `asub.chkdup` option. \cr
#' \cr
#' \cr
#' 
#' 
#' @rdname aaa06_asub_options
#' @name aaa06_asub_options
#' @concept options
#' @aliases asub_options
NULL
