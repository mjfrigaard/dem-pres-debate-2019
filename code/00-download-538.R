#=====================================================================#
# This is code to create: 00-download-538.R
# Authored by and feedback to:
# MIT License
# Version: 1.0
# This script file imports the 538 morning consult data for the Democratic
# presidential debate.
#=====================================================================#

# packages ----------------------------------------------------------------

library(tidyverse)
library(datapasta)
library(googlesheets)
# devtools::install_github("tidyverse/googlesheets4")
library(googlesheets4)
library(googledrive)



# 538 morning consult data  -----------------------------------------------
if (!file.exists("data/raw/538/")) {
  dir.create("data/raw/538/")
}
# this was created using datapasta from an Google sheet here: 
# http://bit.ly/2YEVASu
# datapasta: https://cran.r-project.org/web/packages/datapasta/README.html
Cand538Fav <- tibble::tribble(
                ~candidate, ~before, ~perc_after_first, ~perc_after_second,
               "Joe Biden",    38.5,              33.7,                 31,
          "Bernie Sanders",    16.3,              17.8,               16.8,
        "Elizabeth Warren",    12.7,              17.7,               14.4,
           "Kamala Harris",     7.9,               6.6,               16.8,
          "Pete Puttigieg",     6.9,               4.8,                5.9,
             "Cory Booker",     2.8,               3.6,                2.5,
           "Beto O’Rourke",     3.9,               3.1,                2.1,
           "Julian Castro",     0.6,               2.5,                1.7,
             "Andrew Yang",       1,               1.3,                0.8,
           "Amy Klobuchar",     0.2,               0.9,                0.6,
           "Tulsi Gabbard",     0.6,               0.7,                0.6,
      "Kirsten Gillibrand",     0.8,               0.7,                0.5,
                "Tim Ryan",     0.2,               0.7,                0.3,
            "John Delaney",     0.2,               0.6,                0.4,
       "John Hickenlooper",     0.4,               0.4,                0.4,
          "Bill de Blasio",       0,               0.6,                0.2,
          "Michael Bennet",     0.2,               0.3,                0.5,
              "Jay Inslee",     0.5,               0.6,                0.2,
           "Eric Swalwell",     0.2,               0.1,                0.1,
     "Marianne Williamson",     0.1,                 0,                0.1)
# export 538 data ----
write_csv(as.data.frame(Cand538Fav), 
                         paste0("data/raw/538/",
                           base::noquote(lubridate::today()),
                                             "-Cand538Fav.csv"))