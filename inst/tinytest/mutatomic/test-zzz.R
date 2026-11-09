
x <- letters
expect_true(
  asub:::.rcpp_address(x) %in% asub:::.protected_addresses()
)

x <- 1
expect_false(
  asub:::.rcpp_address(x) %in% asub:::.protected_addresses()
)
