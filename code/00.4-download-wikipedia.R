#=====================================================================#
# This is code to create: 00-download-wikipedia.R
# Authored by and feedback to:
# MIT License
# Version: 1.0
# This script file imports the wikipedia airtime data for the Democratic
# presidential debate.
#=====================================================================#


# packages ----------------------------------------------------------------

library(tidyverse)
library(xml2)
library(rvest)


# import wikipedia url ----------------------------------------------------
dem2020_url <- "https://en.wikipedia.org/wiki/2020_Democratic_Party_presidential_debates_and_forums"
dem2020_tables <- dem2020_url %>%
  xml2::read_html() %>%
  rvest::html_nodes("table")
dem2020_tables %>% length()

# export wiki data --------------------------------------------------------
# export table from night 1
WikiDemAirTime01Raw <- rvest::html_table(x = dem2020_tables[[7]], 
                                  fill = TRUE)
# export table from night 2
WikiDemAirTime02Raw <- rvest::html_table(x = dem2020_tables[[8]],
                                  fill = TRUE)

# WikiDemAirTime01Raw %>% glimpse(78)
# WikiDemAirTime02Raw %>% glimpse(78)

PollingCriterion <- rvest::html_table(x = dem2020_tables[[6]], 
                                  fill = TRUE)

# PollingCriterion %>% glimpse(78)

# create raw/wikipedia data folder --------
if (!file.exists("data/raw/wikipedia/")) {
  dir.create("data/raw/wikipedia/")
}

# export night 1 -------------------------------------------------------------
readr::write_csv(as.data.frame(WikiDemAirTime01Raw), path = 
                   paste0(
                     "data/raw/wikipedia/",
                     base::noquote(lubridate::today()),
                     "-WikiDemAirTime01Raw.csv"
                   ))

# export night 2 -------------------------------------------------------------
readr::write_csv(as.data.frame(WikiDemAirTime02Raw), path = 
                   paste0(
                     "data/raw/wikipedia/",
                     base::noquote(lubridate::today()),
                     "-WikiDemAirTime02Raw.csv"
                   ))

# export Polling criterion ----------------------------------------------------
readr::write_csv(as.data.frame(PollingCriterion), path = 
                   paste0(
                     "data/raw/wikipedia/",
                     base::noquote(lubridate::today()),
                     "-PollingCriterionRaw.csv"
                   ))