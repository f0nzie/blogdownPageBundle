root_dir = '/media/msfz751/2560x/repos/blogdown-sites/fonzie-oilgains'

output_folder <- "converted"                  # folder for converted posts
static_dir <- file.path(root_dir, "static")
img_target_dir <- "."                         # images folder in the bundle page



get_dated_files <- function(root_dir, post_dir) {
    # get only markdown files that are dated postsx
    content_dir <- file.path(root_dir, "content", post_dir)
    files <- list.files(path = content_dir, pattern = "\\.md$", recursive = TRUE)
    full_files <- list.files(path = content_dir, pattern = "\\.md$",
                             recursive = TRUE, full.names = TRUE)
    dated_files <- grep("\\d{4}-\\d{2}-\\d{2}", full_files,
                        value = TRUE, perl = TRUE)
}


file_to_folder <- function(dated_files, out_dir) {
    # add output folder as prefix of dated posts and remove extension
    file.path(out_dir, basename(tools::file_path_sans_ext(dated_files)))
}

convert_single_pages <- function(root_dir, post_dir) {

    out_dir <- file.path(root_dir, output_folder)
    if (!dir.exists(root_dir)) stop()     # if blogdown folder does not exist exit
    if (dir.exists(out_dir)) unlink(out_dir, recursive = TRUE, force = TRUE)
    dir.create(out_dir)                   # create folder for converted posts
    dated_files <- get_dated_files(root_dir, post_dir)       # name of the post file
    pagedir <- file_to_folder(dated_files, out_dir)
    invisible(sapply(pagedir, dir.create))   # create bundle folder for post
    copy_single_pages(dated_files, pagedir)  # copy post as index.md to new bundle folder
    copy_post_images(dated_files, pagedir)   # copy linked images in post from /img to page bundle
    copy_featured_image(root_dir, post_dir, out_dir)
}


copy_featured_image <- function(root_dir, post_dir, out_dir) {
    # copy image used as post cover to featured image in page bundle
    content_dir <- file.path(root_dir, "content", post_dir)
    img_vec <- collect_yaml_coverpage(dir = content_dir)[["image"]]  # extract field image

    dated_files <- get_dated_files(root_dir, post_dir)       # name of the post file
    isect <- intersect(names(img_vec), dated_files)
    if (all(names(img_vec) == isect)) {
        source_image <- file.path(static_dir, "img", img_vec)
        target_dir <- file_to_folder(isect, out_dir)
        if (!all(file.exists(source_image))) stop("image not in /static/img folder")
        # replace image file name by featured.ext
        featured_file <- gsub("^.*(?=[.])", "featured", as.character(img_vec), perl = TRUE)
        featured_file <- file.path(target_dir, featured_file)
        file.copy(source_image, featured_file)  # copy cover image to bundle as featured.ext
    } else {
        stop("image not in dated post")
    }
}


copy_single_pages <- function(dated_files, pagedir) {
    file.copy(dated_files, file.path(pagedir, "index.md"), overwrite = TRUE)
    list(dated_files, pagedir)
}


copy_post_images <- function(dated_files, pagedir) {
    # copy images in "/static/img" that have links in the post
    # still not covering local images that use "<img src/>"
    num_files <- length(dated_files)
    for (i in seq(num_files)) {
        file <- dated_files[i]
        text_md <- readLines(file, warn = FALSE) # https://stackoverflow.com/a/47359712/5270873
        images_md_hhtp  <- grep("!\\[.*\\]\\((?!http).*", text_md, value = TRUE, perl = TRUE)
        images_md <- grep("!\\[.*\\]\\(/img.*\\)", images_md_hhtp, value = TRUE, perl = TRUE)
        images_src <- grep("<img src.*\\/>", text_md, value = TRUE)
        # image files of the form "/img/image_name.ext"
        matches <- regmatches(images_md_hhtp, regexpr("(?<=]\\().+.(?=\\)[\\]\\(])",
                                                      images_md_hhtp, perl = TRUE))
        n_images_md_hhtp  <- length(images_md_hhtp)
        n_images_md  <- length(images_md)
        n_images_src <- length(images_src)
        # cat(basename(file), n_images_md_hhtp, n_images_md, n_images_src, "\n")
        if (length(matches) > 0) {
            page_img_dir <- file.path(pagedir[i], img_target_dir)
            if (!dir.exists(page_img_dir)) dir.create(page_img_dir)
            source_image <- file.path(static_dir, matches)
            # cat(i, basename(file), file.exists(source_image), "\n")
            # print(matches)
            file.copy(source_image, page_img_dir)
        }
    }

}


copy_cover_page_image <- function(dated_files, pagedir) {
    for (i in seq(length(dated_files))) {
        file <- dated_files[i]
        text_md <- readLines(file, warn = FALSE)
    }

}




