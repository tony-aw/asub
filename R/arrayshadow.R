#' @keywords internal
#' @noRd
cast_ArrayShadow <- function(type, length, dim, names, dimnames, comment, oldClass) {
  structure(vector(type, 1L), 
            shadow_len = length,
            shadow_dim = dim,
            shadow_nms = names,
            shadow_dimnames = dimnames,
            comment = comment,
            class = c("ArrayShadow", oldClass))
}


#' @keywords internal
#' @noRd
cast_ArrayShadow2 <- function(x_expr, env) {
  
  meta_expr <- substitute(
    list(
      type = base::typeof(x_expr),
      length = base::length(x_expr),
      dim = base::dim(x_expr),
      names = base::names(x_expr),
      dimnames = base::dimnames(x_expr),
      comment = base::comment(x_expr),
      oldClass = base::oldClass(x_expr)
    ), 
    list(x_expr = x_expr)
  )
  x_meta <- eval(meta_expr, envir = env)
  x_type  <- x_meta$type
  x_len <- x_meta$len
  x_dim <- x_meta$dim
  x_names <- x_meta$names
  x_dimnames <- x_meta$dimnames
  x_comment <- x_meta$comment
  x_oldClass <- x_meta$oldClass
  
  x_shadow <- cast_ArrayShadow(
    x_type, x_len, x_dim, x_names, x_dimnames, x_comment, x_oldClass
  )
  return(x_shadow)
}



#' @export
length.ArrayShadow <- function(x) {
  attr(x, "shadow_len")
}

#' @export
names.ArrayShadow <- function(x) {
  attr(x, "shadow_nms")
}

#' @export
dim.ArrayShadow <- function(x) {
  attr(x, "shadow_dim")
}

#' @export
dimnames.ArrayShadow <- function(x) {
  attr(x, "shadow_dimnames")
}


