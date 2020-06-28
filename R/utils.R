




rmd_pattern = '[.][Rr](md|markdown)$'
md_pattern  = '[.][Rr]?(md|markdown)$'

# scan YAML metadata of all Rmd/md files
scan_yaml = function(dir = 'content') {
    if (missing(dir)) dir = switch(generator(),
                                   hugo = 'content', jekyll = '.', hexo = 'source'
    )
    files = list.files(dir, md_pattern, recursive = TRUE, full.names = TRUE)
    if (length(files) == 0) return(list())
    res = lapply(files, function(f) {
        yaml = fetch_yaml(f)   # only grab the YAML header
        if (length(yaml) == 0) return()
        yaml = yaml[-c(1, length(yaml))]
        if (length(yaml) == 0) return()
        tryCatch(yaml::yaml.load(paste(yaml, collapse = '\n')), error = function(e) {
            warning("Cannot parse the YAML metadata in '", f, "'")
            NULL
        })
    })
    setNames(res, files)
}

# collect specific fields of all YAML metadata
collect_yaml = function(
    fields = c('categories', 'tags'), dir, uniq = TRUE, sort = TRUE
) {
    res = list()
    meta = scan_yaml(dir)
    for (i in fields) {
        res[[i]] = unlist(lapply(meta, `[[`, i))
        if (sort) res[[i]] = sort2(res[[i]])
        if (uniq) res[[i]] = unique(res[[i]])
    }
    res
}





#' Count the number of YAML field occurrences
#'
#' One of various functions to deal with YAML
#'
#' @param fields A character vector of YAML field names.
#' @param sort_by_count Whether to sort the frequency tables by counts.
#' @export
#' @rdname find_yaml
count_yaml = function(fields = c('categories', 'tags'), sort_by_count = TRUE) {
    res = collect_yaml(fields, uniq = FALSE)
    res = lapply(res, function(x) {
        z = table(x)
        if (sort_by_count) sort(z) else z
    })
    res
}


# prevent sort(NULL), which will trigger a warning "is.na() applied to non-(list
# or vector) of type 'NULL'"
sort2 = function(x, ...) {
    if (length(x) == 0) x else sort(x, ...)
}


# collect specific fields of all YAML metadata
collect_yaml_coverpage = function(
    fields = c('image', 'online'), dir, image_only = FALSE, sort = TRUE
) {
    res = list()
    file_coverpage <- list()
    meta = scan_yaml(dir)
    for (i in fields) {
        res[[i]] = unlist(lapply(meta, `[[`, i))
        # print(names(res[[i]]))
        if (sort) res[[i]] = sort2(res[[i]])
        if (image_only) res[[i]] = unique(res[[i]])
        # file_coverpage[[i]] <- list(names(res[[i]]), res[[i]])
    }
    # file_coverpage
    res
}
