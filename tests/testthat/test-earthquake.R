test_that("translate_region returns a list", {
  reg <- translate_region("Europe")
  expect_true(is.list(reg))
})

test_that("earthquake returns a data.frame", {
  skip_if_offline()
  re <- earthquake("Europe", "2025-01-01", "2025-01-03",1)
  expect_s3_class(re, "data.frame")
})

test_that("translate_region returns NULL for unknown region", {
  expect_null(translate_region("Liu"))
})

test_that("earthquake rejects bad input", {
  expect_error(earthquake("Europe", "2025-01-01", "2025-01-03", "5"), "single number")
  expect_error(earthquake("Europe", "2025-01-01", "2025-01-03", c(1, 2)), "single number")
  expect_error(earthquake("Europe", "2025-01-01", "2025-01-03", -1), "0 or higher")
  expect_error(earthquake("Mars", "2025-01-01", "2025-01-03", 5), "Not valid region")
  expect_error(earthquake("Europe", "hej", "2025-01-03", 5), "Start time")
  expect_error(earthquake("Europe", "2025-13-01", "2025-01-03", 5), "Start time")
  expect_error(earthquake("Europe", "2025-01-01", "2025/01/03", 5), "End time")
  expect_error(earthquake("Europe", "2025-01-05", "2025-01-01", 5), "after start time")
})

test_that("earthquake handles a search with no results",{
  skip_if_offline()
  df <- earthquake("Antarctica", "2025-01-01","2025-01-02",8)
  expect_s3_class(df,"data.frame")
  expect_equal(nrow(df), 0)
})


test_that("earthquake returns data matching the request", {
  skip_if_offline()
  df <- earthquake("Europe", "2025-01-01", "2025-01-10", 3)
  reg <- translate_region("Europe")

  expect_named(df, c("time", "latitude", "longitude", "depth", "mag",
                     "magError", "place", "rms", "type"))
  expect_true(all(df$mag >= 3))
  expect_true(all(df$latitude  >= reg$minlatitude  & df$latitude  <= reg$maxlatitude))
  expect_true(all(df$longitude >= reg$minlongitude & df$longitude <= reg$maxlongitude))
})

test_that("earthquake returns NULL when over the API limit", {
  skip_if_offline()
  expect_null(earthquake("North America", "2024-01-01", "2024-12-31", 0))
})
