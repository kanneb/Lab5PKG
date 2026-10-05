test_that("translate_region returns a list", {
  reg <- translate_region("Europe")

  expect_true(is.list(reg) == TRUE)
})

test_that("earthquake returns a data.frame", {
  re <- earthquake("Europe", "2025-01-01", "2025-01-03",1)

  expect_true(is.data.frame(re) == TRUE)
})


