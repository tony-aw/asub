
# set-up ====
library(stringi)
source("siteutils.R")
tinycodet::import_as(~ .clp, "collapse")

################################################################################
# Create man pages ====
#

# make vector of function and topic names ====
search_db <- utils::help.search(
  pattern = ".", package = "asub"
)$matches

funs <- search_db[search_db$Field == "alias", c("Topic", "Entry")]
colnames(funs)[2] <- "Funs"
concepts <- search_db[search_db$Field == "concept", c("Topic", "Entry")]
colnames(concepts)[2] <- "Concepts"

# declare folder names ====
folders <- data.frame(Topic = unique(search_db$Topic))
folders$Folder <- NA
folders$Folder[c(1:3, 12)] <- "overview_intro"
folders$Folder[4:9] <- "overview_arguments"
folders$Folder[10:11] <- "overview_other"

folders$Folder[stri_detect(folders$Topic, fixed = "generic_")] <- "methods_generic"
folders$Folder[stri_detect(folders$Topic, regex = "long|lst|dt|stride")] <- "methods_specialized"
folders$Folder[stri_detect(folders$Topic, fixed = "sb_")] <- "methods_other"

folders$Folder[stri_detect(folders$Topic, regex = "mutatomic")] <- "mutatomic_class"
folders$Folder[stri_detect(folders$Topic, regex = "developer")] <- "developer"
helperfuns <- c("idx_by", "match_all", "size", "nest", "ss2ii", "dropl", "is.formula")
folders$Folder[folders$Topic %in% helperfuns] <- "helper"
folders$Folder[is.na(folders$Folder)] <- "misc"

search_db2 <- .clp$join(funs, concepts, on = "Topic")
search_db2 <- .clp$join(search_db2, folders, on = "Topic")
funs <- search_db2$Funs
concepts <- search_db2$Concepts



## pre-process Rds for linking ====
lst.files <- list.files("man", pattern = "Rd")
pkgpath <- getwd()
for(i in lst.files) {
  print(i)
  filepath <- file.path("man", i)
  topic <- stri_replace_last(i, "", fixed = ".Rd")
  outpath <- file.path("preprocess", "man", search_db2$Folder[search_db2$Topic == topic])[1L]
  print(outpath)
  rd_links(filepath, outpath, funs)
}



## convert Rd to qmd ====
lst.dir <- list.dirs(file.path("preprocess", "man"), full.names = FALSE)[-1]
for(iFolder in lst.dir) {
  lst.files <- list.files(file.path("preprocess", "man", iFolder), pattern = "Rd")
  pkgpath <- getwd()
  for(i in lst.files) {
    print(i)
    filepath <- file.path("preprocess", "man", iFolder, i)
    temp_html <- stri_replace_last(i, ".html", fixed = ".Rd")
    temp_html <- file.path("preprocess", "man", iFolder, temp_html)
    topic <- stri_replace_last(i, "", fixed = ".Rd")
    outpath <- file.path("website", "man", iFolder)
    rd2qmd(filepath, temp_html, outpath, pkgpath)
  }
}



## adapt man titles ====
format <- "
format:
  html:
    css: /man.css
"
detection <- "---\ntitle:"

for(iFolder in lst.dir) {
  lst.files <- list.files(file.path("website", "man", iFolder), pattern = "qmd")
  for(i in lst.files) {
    print(i)
    filename <- i
    topic <- stri_replace_last(filename, "", fixed = ".qmd")
    title <- search_db2[search_db2$Topic == topic, "Concepts"][1]
    if(is.na(title)) title <- topic
    temp <- readLines(file.path("website", "man", iFolder, filename))
    check <- stringi::stri_detect(paste0(temp[1:2], collapse = "\n"), fixed = detection)
    if(!check && !stri_detect(title, fixed = "aaa")) {
      print(title)
      temp <- c("---", paste0("title: ", title), format, "---", temp)
      writeLines(temp, file.path("website", "man", iFolder, filename))
    }
  }
}



## unpack links in man pages ====
for(iFolder in lst.dir) {
  lst.files <- list.files(file.path("website", "man", iFolder), pattern = "qmd")
  for(i in lst.files) {
    filepath <- file.path("website", "man", iFolder, i)
    outpath <- file.path("website", "man", iFolder)
    qmd_extractlinks(filepath, outpath, funs)
  }
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

