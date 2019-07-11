#=====================================================================#
# This is code to create: 00-download-google.R
# Authored by and feedback to:
# MIT License
# Version: 1.0
# This script file imports the Google trend data for the Democratic
# presidential debate.
#=====================================================================#


# packages ----------------------------------------------------------------

library(gtrendsR)
library(janitor)
library(tidyverse)


# import night 1 Google data -------------------------------------------------
if (!file.exists("data/raw/google-trends/")) {
  dir.create("data/raw/google-trends/")
}
# get group 1 from debate
Dems2020Night1Group1 <- gtrendsR::gtrends(keyword = c("Bill de Blasio 2020",
                                               "Cory Booker 2020",
                                               "Julián Castro 2020",
                                               "John Delaney 2020",
                                               "Jay Inslee 2020"), 
                                    # enter dates
                                    time = "2019-06-01 2019-06-30",
                                    gprop = "web",
                                    geo = c("US"))

# verify dates
# min(Dems2020Night1Group1$interest_over_time$date)
# max(Dems2020Night1Group1$interest_over_time$date)

# export Dems2020Night1Group1 ----
readr::write_rds(x = Dems2020Night1Group1, path = paste0(
                     "data/raw/google-trends/", 
                     base::noquote(lubridate::today()), 
                     "-Dems2020Night1Group1.rds"))

# get group 2 from debate
Dems2020Night1Group2 <- gtrendsR::gtrends(keyword = c("Amy Klobuchar 2020",
                                                "Tulsi Gabbard 2020",
                                                "Beto O’Rourke 2020",
                                                "Tim Ryan 2020",
                                                "Elizabeth Warren 2020"), 
                                                # enter dates
                                      time = "2019-06-01 2019-06-30",
                                      gprop = "web",
                                      geo = c("US"))
# verify dates
# min(Dems2020Night1Group2$interest_over_time$date)
# max(Dems2020Night1Group2$interest_over_time$date)

# export Dems2020Night1Group2 ----
readr::write_rds(x = Dems2020Night1Group2, path = paste0(
                     "data/raw/google-trends/", 
                     base::noquote(lubridate::today()), 
                     "-Dems2020Night1Group2.rds"))