#include <R.h>
#include <Rdefines.h>
#include <R_ext/Error.h>


SEXP C_convert_bi_64 ( SEXP x, SEXP size0 ) {
  
  R_xlen_t n = xlength(x);
  
  SEXP res = PROTECT(allocVector(REALSXP, n));
  double *restrict pres = REAL(res);
  
  const double size = REAL_ELT(size0, 0);
  
  if(TYPEOF(x) == INTSXP) {
    const int *restrict px = INTEGER_RO(x);
    for(int j = 0; j != n; ++j) {
      const int tempx = px[j];
      if(tempx < 0) {
        pres[j] = size + tempx + 1;
      }
      else {
        pres[j] = tempx;
      }
    }
  }
  else if(TYPEOF(x) == REALSXP) {
    const double *restrict px = REAL_RO(x);
    for(int j = 0; j != n; ++j) {
      const double tempx = px[j];
      if(tempx < 0) {
        pres[j] = size + tempx + 1;
      }
      else {
        pres[j] = tempx;
      }
    }
  }
  
  
  UNPROTECT(1);
  return(res);  
  

}