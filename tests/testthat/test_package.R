## The package's DESCRIPTION and LICENSE files (plan Phase 5b).
## Each file is found with system.file(), which finds the source file under
## pkgload::load_all() and the installed file under R CMD check.

readPackageFile <- function(fileName) {
  path <- system.file(fileName, package = "pedkindraw")
  if (!nzchar(path)) {
    stop("pedkindraw has no ", fileName, " file", call. = FALSE)
  }
  read.dcf(path)
}

fieldValue <- function(dcf, field) {
  if (field %in% colnames(dcf)) unname(dcf[1L, field]) else NA_character_
}

test_that("DESCRIPTION names the package, its license, encoding and edition", {
  description <- readPackageFile("DESCRIPTION")
  expect_identical(fieldValue(description, "Package"), "pedkindraw")
  expect_identical(fieldValue(description, "License"), "MIT + file LICENSE")
  expect_identical(fieldValue(description, "Encoding"), "UTF-8")
  expect_identical(fieldValue(description, "Config/testthat/edition"), "3")
})

test_that("the version is below 1.0.0 and CRAN's check would not flag it", {
  version <- fieldValue(readPackageFile("DESCRIPTION"), "Version")
  ## API contract section 6: 0.x until the first CRAN release.
  expect_true(package_version(version) < "1.0.0")
  ## R's CRAN incoming check notes a part of 1234 or more ("large
  ## components", e.g. 0.0.0.9000) and a part with a leading zero.
  expect_true(all(unlist(package_version(version)) < 1234L))
  expect_false(grepl("(^|[.-])0[0-9]+", version))
})

test_that("R. Mark Sharp is the one maintainer in Authors@R", {
  authorsText <- fieldValue(readPackageFile("DESCRIPTION"), "Authors@R")
  authors <- eval(parse(text = authorsText))
  isMaintainer <- vapply(seq_along(authors),
                         function(i) "cre" %in% authors[i]$role,
                         logical(1L))
  expect_identical(sum(isMaintainer), 1L)
  expect_identical(format(authors[isMaintainer],
                          include = c("given", "family")),
                   "R. Mark Sharp")
})

test_that("LICENSE holds only the two lines of CRAN's MIT template", {
  ## A LICENSE carrying the full MIT text is not a DCF file, so read.dcf()
  ## fails on it; CRAN rejects that form for "MIT + file LICENSE".
  license <- readPackageFile("LICENSE")
  expect_identical(colnames(license), c("YEAR", "COPYRIGHT HOLDER"))
  expect_identical(nrow(license), 1L)
  expect_match(fieldValue(license, "YEAR"), "^[0-9]{4}(-[0-9]{4})?$")
  expect_identical(fieldValue(license, "COPYRIGHT HOLDER"), "R. Mark Sharp")
})
