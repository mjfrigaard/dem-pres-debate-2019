#=====================================================================#
# This is code to create: 00-download-tweets.R
# Authored by and feedback to:
# MIT License
# Version: 1.0
# democratic presidential debate data from twitter
#=====================================================================#

# packages ----------------------------------------------------------------

## install remotes package if it's not already
if (!requireNamespace("remotes", quietly = TRUE)) {
  install.packages("remotes")
}

## install dev version of rtweet from github
remotes::install_github("mkearney/rtweet")

## load rtweet package
library(rtweet)
library(tidyverse)


# background --------------------------------------------------------------
# this script is here for documentation purposes only (you will not be able to 
# run this without your own API key). 


# import twitter night 1 ----------------------------------------------------
# night one group 1 tweets 
Night01TweetsRaw <- Map(
  "search_tweets",
      c("Bill de Blasio 2020",
       "Cory Booker 2020",
       "Julián Castro 2020",
       "John Delaney 2020",
        "Jay Inslee 2020"),
  n = 1000
)
# verify names
Night01TweetsRaw %>% names()
# convert to data frame
Night01Tweets <- rtweet::do_call_rbind(Night01TweetsRaw)
# user data 
Night01TweetsUsers <- rtweet::users_data(Night01Tweets)
# verify
# Night01Tweets %>% glimpse(78)


# export night 01/group 01 ------------------------------------------------
if (!file.exists("data/raw/twitter/")) {
  dir.create("data/raw/twitter/")
}
# export Night01TweetsRaw ----
readr::write_rds(x = Night01TweetsRaw, path = paste0(
                     "data/raw/twitter/", 
                     base::noquote(lubridate::today()), 
                     "-Night01TweetsRaw.rds"))

# export Night01Tweets ----
readr::write_rds(x = Night01Tweets, path = paste0(
                     "data/raw/twitter/", 
                     base::noquote(lubridate::today()), 
                     "-Night01Tweets.rds"))

# export Night01TweetsUsers ----
readr::write_rds(x = Night01TweetsUsers, path = paste0(
                     "data/raw/twitter/", 
                     base::noquote(lubridate::today()), 
                     "-Night01TweetsUsers.rds"))

# import twitter night 1 group 2 ---------------------------------------------------
Night02TweetsRaw <- Map(
  "search_tweets",
      c("Amy Klobuchar 2020",
        "Tulsi Gabbard 2020",
        "Beto O’Rourke 2020",
        "Tim Ryan 2020",
        "Elizabeth Warren 2020"),
  n = 1000
)

Night02TweetsRaw %>% names()
# convert to data frame
Night02Tweets <- rtweet::do_call_rbind(Night02TweetsRaw)
# get user data
Night02TweetsUsers <- rtweet::users_data(Night02Tweets)
# Night02TweetsUsers %>% glimpse(78)

# export Night02TweetsRaw ----
readr::write_rds(x = Night02TweetsRaw, path = paste0(
                     "data/raw/twitter/", 
                     base::noquote(lubridate::today()), 
                     "-Night02TweetsRaw.rds"))

# export Night02Tweets ----
readr::write_rds(x = Night02Tweets, path = paste0(
                     "data/raw/twitter/", 
                     base::noquote(lubridate::today()), 
                     "-Night02Tweets.rds"))

# export Night02TweetsUsers ----
readr::write_rds(x = Night02TweetsUsers, path = paste0(
                     "data/raw/twitter/", 
                     base::noquote(lubridate::today()), 
                     "-Night02TweetsUsers.rds"))




