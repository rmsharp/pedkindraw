## Copyright(c) 2017-2026 R. Mark Sharp
## This file is part of pedkindraw

#' The example code of a help page, as text
#'
#' Plan Phase G9 (pedkindraw S50). Reads \code{man/<topic>.Rd} from the source
#' tree when the tests run there (\code{testthat::test_local()}); under
#' \code{R CMD check} there is no source tree, and the installed package's
#' help database is read instead. \code{\\dontrun} code is left out, as
#' \code{example()} leaves it out.
#'
#' @param topic the name of the Rd file, without \code{.Rd}.
#' @return one character string, the example's R code.
helpExampleCode <- function(topic) {
  rdFile <- testthat::test_path("..", "..", "man", paste0(topic, ".Rd"))
  rd <- if (file.exists(rdFile)) {
    tools::parse_Rd(rdFile)
  } else {
    tools::Rd_db("pedkindraw")[[paste0(topic, ".Rd")]]
  }
  out <- tempfile(fileext = ".R")
  on.exit(unlink(out))
  tools::Rd2ex(rd, out, commentDontrun = TRUE)
  paste(readLines(out), collapse = "\n")
}
