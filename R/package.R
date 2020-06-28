#' The \pkg{blogdownPageBundle} package
#'
#' This package has functions to convert the old blogdown post style of
#' file pages to page bundles or folders
#'
#' @name blogdownPageBundle
#' @aliases blogdownPageBundle-package
#' @import utils
#' @import stats
#' @import bookdown
#' @importFrom xfun attr in_dir read_utf8 write_utf8
NULL



# this ::: call causing a Note during checks
# fetch_yaml = function(f) bookdown:::fetch_yaml(read_utf8(f))


match_dashes = function(x) grep('^---\\s*$', x)

fetch_yaml = function(f) fetch_yaml_x(read_utf8(f))

fetch_yaml_x = function(x) {
    i = match_dashes(x)
    if (length(i) >= 2) x[(i[1]):(i[2])]
}




