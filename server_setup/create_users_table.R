#!/usr/bin/env Rscript

library(magrittr)
library(stringr)

args <- commandArgs(trailingOnly=TRUE)

if (length(args) != 4) {
  stop("Usage: ./create_users_table.R <prefix> <n_users> <pw_seed> <filename>")
}

prefix <- args[1]
n_users <- args[2] %>% as.numeric()
pw_seed <- args[3] %>% as.numeric()
filename <- args[4]

if (is.na(n_users)) {
  stop("Number of users <n_users> must be a number.")
}

if (n_users > 999) {
  stop("Maximum number of users is 999. Please adjust n_users.")
}

if (is.na(pw_seed)) {
  stop("Password seed <pw_seed> must be a number.")
}

set.seed(pw_seed)
users <- tibble::tibble(
  username = glue::glue("{prefix}{1:n_users %>% str_pad(3, '0', side = 'left')}"),
  password = runif(n_users, min = 100000, max = 999999) %>% as.integer %>% str_pad(6, '0', side = "left")
)

users %>%
  readr::write_tsv(filename, col_names = FALSE)