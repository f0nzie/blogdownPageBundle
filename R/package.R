#' The \pkg{pageBundle} package
#'
#' The comprehensive documentation of this package is the book \bold{pageBundle:
#' Creating Websites with R Markdown}
#' (\url{https://bookdown.org/yihui/blogdown/}). You are expected to read at
#' least the first chapter. If you are really busy or do not care about an
#' introduction to \pkg{pageBundle} (e.g., you are very familiar with creating
#' websites), set your working directory to an empty directory, and run
#' \code{pageBundle::\link{new_site}()} to get started right away.
#' @name blogdownPageBundle
#' @aliases pageBundle-package
#' @import utils
#' @import stats
#' @importFrom xfun attr in_dir read_utf8 write_utf8
NULL










# capture the YAML header of a markdown file
fetch_yaml = function(f) bookdown:::fetch_yaml(read_utf8(f))

# match_dashes = function(x) grep('^---\\s*$', x)
#
# fetch_yaml = function(x) {
#     i = match_dashes(x)
#     if (length(i) >= 2) x[(i[1]):(i[2])]
# }
