#' asub: Programmatically Friendly Subset Functions for Array-like and Data.frame-like S3 Objects
#' 
#' @description
#' asub: \cr
#' Programmatically Friendly Sub-set Functions for Array-like and Data.frame-like S3 Objects. \cr
#' \cr
#' 
#' ```{r echo = FALSE, eval = TRUE, results = 'asis'}
#' 
#' txt <- packageDescription("asub", fields = "Description")
#' p <- c("\t", ",\n", ".\n", ";\n",  "\n(", "following.", "    ")
#' rp <- c("", ", ", ".\n\n", "; \\cr ", " (", "following:", " ")
#' for(i in 1:length(rp)) {
#'  txt <- gsub(p[i], rp[i], txt, fixed = TRUE)
#' }
#' txt <- paste0(txt, "\\cr \\cr")
#' cat(txt)
#' ```
#' 
#' @section Goal:
#' 
#' Among programming languages,
#' 'R' has perhaps one of the most
#' flexible and comprehensive sub-setting functionality,
#' provided by the square brackets operators (`[`, `[<-`). \cr
#' But in some situations the square brackets operators
#' are occasionally less than optimally convenient for arrays. \cr
#' \cr
#' The Goal of the 'asub' package
#' is not to replace the square-brackets operators,
#' but to provide \bold{alternative} sub-setting functions for array-like and data.frame-like objects,
#' to be used in situations where the square bracket operators are inconvenient. \cr
#' \cr
#' 
#' 
#' @section Quick Start Guide:
#' For the Quick Start Guide, see: \cr
#' \url{https://tony-aw.github.io/asub/articles/asub.html}. \cr
#' \cr
#' 
#' 
#' @section Overview Help Pages:
#' 
#' \bold{Essentials} \cr
#' The essential documentation is split into the following help pages:
#'  
#'  - \link{asub_methods}: \cr
#'  Lists the main methods provided by 'asub'. \cr
#'  Also explains the method dispatch system in 'asub'.
#'  - \link{asub_index_fundamentals}: \cr
#'  Explains the essential fundamentals of the indexing forms in 'asub'.
#'  - \link{asub_keywords}: \cr
#'  Explains the usage of keywords in the main methods of 'asub'. \cr \cr
#' 
#' 
#' \bold{Arguments} \cr
#' The methods in 'asub' share a lot of common arguments. \cr
#' The explanations for these common arguments are given in the following help pages:
#' 
#'  - \link{asub_supported_structures}: \cr
#'  Lists the structures that are supported by 'asub',
#'  and explains some related terminology.
#'  - \link{asub_index_args}: \cr
#'  Explains the common indexing arguments used in the main S3 methods.
#'  - \link{asub_modify}: \cr
#'  Explains the modification-related arguments,
#'  and other essential information regarding modification.
#'  - \link{asub_options}: \cr
#'  Lists and explains the options the user can specify in 'asub'. \cr \cr
#'  
#' 
#' \bold{Pass-By-Reference} \cr
#' The following help pages explain the pass-by-reference semantics provided by 'asub',
#' and only need to be read when planning to use those semantics:
#' 
#'  - \link{asub_PassByReference}: \cr
#'  Explains Pass-by-Reference semantics, and its important consequences.
#'  - \link{asub_coercion}: \cr
#'  Explains the difference in coercion rules between
#'  modification through Pass-by-Reference semantics and
#'  modification through copy (i.e. pass-by-value). \cr \cr
#'  
#' 
#' 
#' @section Helper Functions: 
#' 
#' A couple of convenience functions, and helper functions for creating ranges, sequences, and indices
#' (often needed in sub-setting)
#' are provided:
#' 
#'  * \link{n}: Nested version of \link[base]{c},
#'  and short-hand for \link[base]{list}.
#'  * \link{ndim}: Get the number of dimensions of an object.
#'  * \link{ss2coord}, \link{coord2ii}: Convert subscripts
#'  (dimensional array indices) to coordinates,
#'  coordinates to flat indices,
#'  and vice-versa.
#'  * \link{match_all}: Find all matches, of one vector in another,
#'  taking into account the order and any duplicate values of both vectors.
#'  * Computing indices: \cr
#'  \link{idx_by} to compute grouped indices. \cr \cr
#' 
#' 
#' @section Properties Details:
#' The alternative sub-setting methods and functions provided by 'asub'
#' have the following properties:
#' 
#'  * \bold{Programmatically friendly}:
#'    * Unlike base `[`,
#'    it's not required to know the number of dimensions of an array a-priori,
#'    to perform subset-operations on an array.
#'    * Missing arguments can be filled with `NULL`,
#'    instead of using dark magic like `base::quote(expr =    )`.
#'    * No Non-standard evaluation.
#'    * Functions are pipe-friendly.
#'    * No (silent) vector recycling.
#'    * Extracting and removing subsets uses the same syntax.
#'  * \bold{Class consistent}: 
#'    * sub-setting of multi-dimensional objects by specifying dimensions
#'    (i.e. rows, columns, ...)
#'    use `drop = FALSE`. \cr
#'    So matrix in, matrix out.
#'    * The methods deliver the same results for
#'    data.frames, data.tables, tibbles, and tidytables. \cr
#'    No longer does one have to re-learn the different brackets-based sub-setting rules
#'    for different types of data.frame-like objects. \cr
#'    Powered by the subclass agnostic 'C'-code from 'collapse' and 'data.table'.
#'  * \bold{Careful handling of names}:
#'    * Sub-setting an object by index names returns ALL matches with the given names,
#'    not just the first.
#'    * Data.frame-like objects are forced to have unique column names.
#'  * \bold{Concise function and argument names}.
#'  * \bold{Performance & Energy aware}: \cr
#'  Despite the many checks performed, the functions are kept reasonably speedy,
#'  through the use of the 'Rcpp', 'collapse', and 'data.table' R-packages. \cr
#'  The functions were also made to be as memory efficient as reasonably possible,
#'  to lower the carbon footprint of this package. \cr \cr
#'
#' 
#' 
#' @author \strong{Author, Maintainer}: Tony Wilkes \email{tony_a_wilkes@outlook.com} (\href{https://orcid.org/0000-0001-9498-8379}{ORCID})
#' 
#' @concept intro
#' @references The badges shown in the documentation of this R-package were made using the services of: \url{https://shields.io/}
#' 
#' @name aaa00_asub_help
#' @rdname aaa00_asub_help
#' @aliases asub-package
#' @aliases asub
#' @aliases asub_help
#' @useDynLib asub, .registration=TRUE
#' @importFrom Rcpp evalCpp
#' 
#' @exportPattern "^sb_setFlatnames"
#' @exportPattern "^sb_setDimnames"
#' @exportPattern "^sb_setVarnames"
#' @exportPattern "^idx"
#' 
#' @exportPattern "^ii_x"
#' @exportPattern "^ii_set"
#' @exportPattern "^ii_mod"
#' @exportPattern "^lst_rec"
#' 
#' @exportPattern "^ss_x"
#' @exportPattern "^ss_wo"
#' @exportPattern "^ss_set"
#' @exportPattern "^ss_mod"
#' 
#' @exportPattern "^tt_x"
#' @exportPattern "^tt_set"
#' @exportPattern "^tt_mod"
#' 
NULL
#> NULL
