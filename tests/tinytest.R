
if ( requireNamespace("tinytest", quietly = TRUE) ){
  
  options(warn=1) # as requested by CRAN
  
  tinytest::test_package(
    "asub", set_env=list(LC_COLLATE="C")
  )
  
  tinytest::test_package(
    "asub", testdir = "tinytest/args", set_env=list(LC_COLLATE="C")
  )
  
  tinytest::test_package(
    "asub", testdir = "tinytest/developer", set_env=list(LC_COLLATE="C")
  )
  
  tinytest::test_package(
    "asub", testdir = "tinytest/generic", set_env=list(LC_COLLATE="C")
  )
  tinytest::test_package(
    "asub", testdir = "tinytest/generic2", set_env=list(LC_COLLATE="C")
  )
  tinytest::test_package(
    "asub", testdir = "tinytest/generic_rename", set_env=list(LC_COLLATE="C")
  )
  
  tinytest::test_package(
    "asub", testdir = "tinytest/helper", set_env=list(LC_COLLATE="C")
  )
  tinytest::test_package(
    "asub", testdir = "tinytest/internal", set_env=list(LC_COLLATE="C")
  )
  
  tinytest::test_package(
    "asub", testdir = "tinytest/mutatomic", set_env=list(LC_COLLATE="C")
  )
  
  tinytest::test_package(
    "asub", testdir = "tinytest/semantics", set_env=list(LC_COLLATE="C")
  )
  
  tinytest::test_package(
    "asub", testdir = "tinytest/special_dt", set_env=list(LC_COLLATE="C")
  )
  tinytest::test_package(
    "asub", testdir = "tinytest/special_lst", set_env=list(LC_COLLATE="C")
  )
  
  tinytest::test_package(
    "asub", testdir = "tinytest/src_related", set_env=list(LC_COLLATE="C")
  )
  
  tinytest::test_package(
    "asub", testdir = "tinytest/ss2ii", set_env=list(LC_COLLATE="C")
  )
  
  tinytest::test_package(
    "asub", testdir = "tinytest/zerolen", set_env=list(LC_COLLATE="C")
  )
  
}


