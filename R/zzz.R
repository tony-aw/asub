

.pkgenv_mutatomic <- new.env(parent=emptyenv())

.onLoad <- function(libname, pkgname) {
  options(
    asub.cn = FALSE,
    asub.chkdup = FALSE,
    asub.ma_messages = FALSE,
    asub.sticky = c("difftime", "broadcaster")
  )
  .pkgenv_mutatomic[["protected"]] <- .protected_addresses()
}


.onAttach <- function(libname, pkgname) {
  txt <- paste0(
    "Run `",
    '?asub::asub_help',
    "` to open the introduction help page of 'asub'."
  )
  packageStartupMessage(txt)
}



