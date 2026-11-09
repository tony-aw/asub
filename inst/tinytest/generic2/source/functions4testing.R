errorfun <- function(tt) {
  
  if(isFALSE(tt)) stop(print(tt))
}

any_empty_indices <- function(...) {
  lst <- list(...)
  return(asub:::.any_empty_indices(lst))
}
