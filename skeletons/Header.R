# set-up ====

library(stringi)



header <- "


#include <Rcpp.h>

using namespace Rcpp;


"



macros_arrays <- readr::read_file("macros_arrays.txt")

macro_set_atomic <- "

#define MACRO_SET_ATOMIC(POINTER, INDEX, REPLACEMENT) do {  \\
  POINTER[INDEX] = REPLACEMENT; \\
} while(0)

"

macros <- stri_c(
  macro_set_atomic,
  macros_arrays,
  collapse = "\n\n"
)
cat(macros)


testfun <- "
//' @keywords internal
//' @noRd
// [[Rcpp::export(.test)]]
int test(int x, int y) {
  return(x + y);
}

"

Rcpp::sourceCpp(code = stri_c(header, macros, testfun, collapse = "\n"))


header_macro <- stri_c("

#ifndef asub_H
#define asub_H

",
                 
macros,

"

#endif
"
)



cat(header_macro)
Rcpp::sourceCpp(code = stri_c(header, header_macro))

setwd("..")
readr::write_file(header_macro, "src/asub.h")

