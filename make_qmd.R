
# set-up ====
library(stringi)
source("siteutils.R")
tinycodet::import_as(~ .clp, "collapse")


################################################################################
# Make organization ====
#
#
search_db <- utils::help.search(
  pattern = ".", package = "asub"
)$matches

funs <- search_db[search_db$Field == "alias", c("Topic", "Entry")]
colnames(funs)[2] <- "Funs"
concepts <- search_db[search_db$Field == "concept", c("Topic", "Entry")]
colnames(concepts)[2] <- "Concepts"

# declare folder names ====
folders <- data.frame(Topic = unique(search_db$Topic))
intros <- paste(
  "asub_", c("help", "methods", "index_fundamentals", "keywords"),
  sep = ""
)
intros <- paste0(intros, collapse = "|")
args <- paste(
  "asub_",
  c("supported_structures", "index_args", "modify", "options", "ellipsis", "stride"),
  sep = ""
)
args <- paste0(args, collapse = "|")
other <- "asub_"
folders$Folder <- NA
folders$Folder[stri_detect(folders[[1]], regex = intros)] <- "overview_intro"
folders$Folder[stri_detect(folders[[1]], regex = args)] <- "overview_arguments"
folders$Folder[stri_detect(folders[[1]], regex = other) & is.na(folders$Folder)] <- "overview_other"

folders$Folder[stri_detect(folders$Topic, fixed = "generic_")] <- "methods_generic"
folders$Folder[stri_detect(folders$Topic, regex = "long|lst|dt|stride_")] <- "methods_specialized"
folders$Folder[stri_detect(folders$Topic, fixed = "sb_")] <- "methods_other"

folders$Folder[stri_detect(folders$Topic, regex = "mutatomic")] <- "mutatomic_class"
folders$Folder[stri_detect(folders$Topic, regex = "developer")] <- "developer"
folders$Folder[stri_detect(folders$Topic, regex = "ArrayShadow")] <- "developer"
helperfuns <- c("idx_by", "match_all", "size", "nest", "ss2ii", "dropl", "is.formula")
folders$Folder[folders$Topic %in% helperfuns] <- "helper"
folders$Folder[is.na(folders$Folder)] <- "misc"

search_db2 <- .clp$join(funs, concepts, on = "Topic")
search_db2 <- .clp$join(search_db2, folders, on = "Topic")
funs <- search_db2$Funs
concepts <- search_db2$Concepts
folders <- unique(search_db2$Folder)

# make yaml hierarchy text:
my_yml <- vector("list", length(folders))
names(my_yml) <- paste0("section ", folders, " contents")
i <- 1L
for(iFolder in folders) {
  temp <- unique(search_db2[search_db2$Folder == iFolder,]$Topic)
  temp <- paste0("man/", temp, ".qmd")
  my_yml[[i]] <- as.list(temp)
  i <- i + 1L
}
my_yml <- yaml::as.yaml(list(sidebar = my_yml), indent = 10, omap = FALSE, indent.mapping.sequence = TRUE)
my_yml <- stri_replace_all(my_yml, "\n- section: ", fixed = "section")
my_yml <- stri_replace_all(my_yml, "\n  contents:", fixed = "contents:")

cat(my_yml)


################################################################################
# Create man pages ====
#

# make vector of function and topic names
search_db <- utils::help.search(
  pattern = ".", package = "asub"
)$matches

funs <- search_db[search_db$Field == "alias", c("Topic", "Entry")]
colnames(funs)[2] <- "Funs"
concepts <- search_db[search_db$Field == "concept", c("Topic", "Entry")]
colnames(concepts)[2] <- "Concepts"


search_db2 <- .clp$join(funs, concepts, on = "Topic")
funs <- search_db2$Funs
concepts <- search_db2$Concepts
#
#

## pre-process Rds for linking
lst.files <- list.files("man", pattern = "Rd")
pkgpath <- getwd()
for(i in lst.files) {
  print(i)
  filepath <- file.path("man", i)
  topic <- stri_replace_last(i, "", fixed = ".Rd")
  outpath <- file.path("preprocess", "man")
  print(outpath)
  rd_links(filepath, outpath, funs)
}



## convert Rd to qmd
lst.files <- list.files(file.path("preprocess", "man"), pattern = "Rd")
pkgpath <- getwd()
for(i in lst.files) {
  print(i)
  filepath <- file.path("preprocess", "man", i)
  temp_html <- stri_replace_last(i, ".html", fixed = ".Rd")
  temp_html <- file.path("preprocess", "man", temp_html)
  outpath <- file.path("website", "man")
  rd2qmd(filepath, temp_html, outpath, pkgpath)
}



## adapt man titles
format <- "
format:
  html:
    css: /man.css
"
detection <- "---\ntitle:"

lst.files <- list.files(file.path("website", "man"), pattern = "qmd")
for(i in lst.files) {
  print(i)
  filename <- i
  topic <- stri_replace_last(filename, "", fixed = ".qmd")
  title <- search_db2[search_db2$Topic == topic, "Concepts"][1]
  if(is.na(title)) title <- topic
  temp <- readLines(file.path("website", "man", filename))
  check <- stringi::stri_detect(paste0(temp[1:2], collapse = "\n"), fixed = detection)
  if(!check && !stri_detect(title, fixed = "aaa")) {
    print(title)
    temp <- c("---", paste0("title: ", title), format, "---", temp)
    writeLines(temp, file.path("website", "man", filename))
  }
}



## unpack links in man pages

lst.files <- list.files(file.path("website", "man"), pattern = "qmd")
for(i in lst.files) {
  filepath <- file.path("website", "man", i)
  outpath <- file.path("website", "man")
  qmd_extractlinks(filepath, outpath, funs)
}


# repair lingering issues in html code
lst.files <- list.files(file.path("website", "man"), pattern = "qmd")
for(i in lst.files) {
  print(i)
  target_dir <- file.path("website", "man")
  filepath <- file.path("website", "man", i)
  tmp <- readLines(filepath)
  tmp <- repair_html_styling(tmp)
  fn <- file.path(target_dir, basename(filepath))
  writeLines(tmp, con = fn)
}




################################################################################
# Process Index page ====
#

# clear any present links ====
funs <- getNamespaceExports("broadcast")
filepath <- file.path("website", "index.qmd")
temp <- readLines(filepath)
p <- paste0("[", funs, "()]", "(/man/", rd_index(funs), ".qmd)")
rp <- paste0("`", funs, "()`")
temp <- stri_replace_all(
  temp, rp, fixed = p, vectorize_all = FALSE
)
writeLines(temp, file.path("website", "index.qmd"))


# # create links ====
p <- paste0("`", funs, "()`")
rp <- paste0("[", funs, "()]", "(/man/", rd_index(funs), ".qmd)")
temp <- stri_replace_all(
  temp, rp, fixed = p, vectorize_all = FALSE
)
writeLines(temp, file.path("website", "index.qmd"))


################################################################################
# Process Vignettes, Index page ====
#


# clear any present links in vignettes ====
funs <- getNamespaceExports("broadcast")
lst.files <- list.files(file.path("website", "vignettes"), pattern = "qmd")
for(i in lst.files) {
  print(i)
  filepath <- file.path("website", "vignettes", i)
  temp <- readLines(filepath)
  p <- paste0("[", funs, "()]", "(/man/", rd_index(funs), ".qmd)")
  rp <- paste0("`", funs, "()`")
  temp <- stri_replace_all(
    temp, rp, fixed = p, vectorize_all = FALSE
  )
  writeLines(temp, file.path("website", "vignettes", i))
}


# create links in vignettes ====
funs <- getNamespaceExports("broadcast")
lst.files <- list.files(file.path("website", "vignettes"), pattern = "qmd")
for(i in lst.files) {
  print(i)
  filepath <- file.path("website", "vignettes", i)
  temp <- readLines(filepath)
  p <- paste0("`", funs, "()`")
  rp <- paste0("[", funs, "()]", "(/man/", rd_index(funs), ".qmd)")
  temp <- stri_replace_all(
    temp, rp, fixed = p, vectorize_all = FALSE
  )
  writeLines(temp, file.path("website", "vignettes", i))
}




################################################################################
# Process About pages ====
#



# clear any present links in About pages ====
funs <- getNamespaceExports("broadcast")
lst.files <- list.files(file.path("website", "About"), pattern = "qmd")
for(i in lst.files) {
  print(i)
  filepath <- file.path("website", "About", i)
  temp <- readLines(filepath)
  p <- paste0("[", funs, "()]", "(/man/", rd_index(funs), ".qmd)")
  rp <- paste0("`", funs, "()`")
  temp <- stri_replace_all(
    temp, rp, fixed = p, vectorize_all = FALSE
  )
  writeLines(temp, file.path("website", "About", i))
}


# create links in About pages ====
funs <- getNamespaceExports("broadcast")
lst.files <- list.files(file.path("website", "About"), pattern = "qmd")
for(i in lst.files) {
  print(i)
  filepath <- file.path("website", "About", i)
  temp <- readLines(filepath)
  p <- paste0("`", funs, "()`")
  rp <- paste0("[", funs, "()]", "(/man/", rd_index(funs), ".qmd)")
  temp <- stri_replace_all(
    temp, rp, fixed = p, vectorize_all = FALSE
  )
  writeLines(temp, file.path("website", "About", i))
}

# end of rd2qmd ====

