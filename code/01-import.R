#=====================================================================#
# This is code to create: 01-import.R
# Authored by and feedback to:
# MIT License
# Version: 1.0
# This script file imports the Google trend data and the wikipedia table
# for the Democratic presidential debate.
#=====================================================================#

# create raw data folder --------
if (!file.exists("data/raw/")) {
  dir.create("data/raw/")
}

# packages ----------------------------------------------------------------

library(tidyverse)
library(Hmisc)
library(janitor)
library(magrittr)
library(rvest)
library(methods)


# import Google data -----------------------------------------------------
# these have been imported using the 01.2-twitter-data.R file. Open it for more 
# details
# fs::dir_ls("data/raw/google-trends/")
google_data_path <- "data/raw/google-trends/"   # path to the data
google_data_files <- dir(google_data_path, 
                          pattern = "*.rds") # get file names
GoogleData <- google_data_files %>%
  # read in all the files, appending the path before the filename
  purrr::map(~ readr::read_rds(file.path(google_data_path, .)))
GTrendDems2020Night1G1 <- GoogleData[[1]]
GTrendDems2020Night1G2 <- GoogleData[[2]]


# import 538 --------------------------------------------------------------
# fs::dir_ls("data/raw/538/")
GSheetCand538Fav <- readr::read_csv("data/raw/538/2019-07-06-Cand538Fav.csv")


# import wikipedia --------------------------------------------------------
wiki_data_path <- "data/raw/wikipedia/"   # path to the data
wiki_data_files <- dir(wiki_data_path, 
                          pattern = "*.csv") # get file names
WikiData <- wiki_data_files %>%
  # read in all the files, appending the path before the filename
  purrr::map(~ readr::read_csv(file.path(wiki_data_path, .)))
WikiDemAirTime01Raw <- WikiData[[1]]
# WikiDemAirTime01Raw
WikiDemAirTime02Raw <- WikiData[[2]]
# WikiDemAirTime02Raw
WikiPollCriterionRaw <- WikiData[[3]]
# WikiPollCriterionRaw

# import twitter data -----------------------------------------------------
# these have been imported using the 01.2-twitter-data.R file. Open it for more 
# details
# fs::dir_ls("data/raw/twitter/")
twitter_data_path <- "data/raw/twitter/"   # path to the data
twitter_data_files <- dir(twitter_data_path, 
                          pattern = "*Tweets.rds") # get file names
TwitterData <- twitter_data_files %>%
  # read in all the files, appending the path before the filename
  purrr::map(~ readr::read_rds(file.path(twitter_data_path, .))) %>% 
  reduce(rbind)
# TwitterData

twitter_data_path <- "data/raw/twitter/"   # path to the data
twitter_users_data_files <- dir(twitter_data_path, 
                                pattern = "*Users.rds") # get file names
TwitterUsersData <- twitter_users_data_files %>%
  # read in all the files, appending the path before the filename
  purrr::map(~ readr::read_rds(file.path(twitter_data_path, .))) %>% 
  reduce(rbind)
# TwitterUsersData

