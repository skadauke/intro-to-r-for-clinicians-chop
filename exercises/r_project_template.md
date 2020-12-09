---
title: "CHOP R 101"
author: "R User Group + Arcus Ed"
date: "`r Sys.Date()`"
output: html_document
---

```{r setup, include=FALSE}
knitr::opts_chunk$set(echo = TRUE)

# This is the "setup chunk" where you load in R packages to use in this R Markdown file
# Note that "library(tidyverse)" actually brings in several different packages
# such as dplyr, readr, ggplot2, etc! You can add additional "libary(package_name)"
# lines to bring in additional functionality. More on this: https://www.tidyverse.org/packages/

library(tidyverse)

```

## Use this template!

Coders often use templates and code snippets as a starting point for their analysis or find solutions to common problems.

Things we will commonly want to do in an RMarkdown:

* Introduction: what are you trying to accomplish in this script?
* Import data: bring in relevant data from a .csv, from an API, etc.
* Tidy and transform data
* Exploratory cycle: summarize and visualize your data, check your assumptions
* Share your results: conclusions, findings, and/or export data

Note that this template provides a starting point, but not an unchangeable structure -- feel free to modify, expand, and remove as you see fit (but try to keep the basic mix of code and narrative if possible!)

## Introduction

This is your project! What problem are you trying to solve?

## Import data

This step usually requires a particular R library to bring in data, such as `readr`, which is happy grabbing data from a variety of sources.

For example, we might want to bring in a .csv from a location online AND capture it in a named object so we can use it later:


```{r message=FALSE}
# Below is an example of importing tabular (.csv) data into R
# In this case, COVID reports by state from the NY Times

covid <- read_csv('https://raw.githubusercontent.com/nytimes/covid-19-data/master/us-states.csv')

covid
```

## Tidy and transform data

## Exploratory cycle

## Share your results
