#=====================================================================#
# This is code to create: 02-wrangle.R
# Authored by and feedback to:
# MIT License
# Version: 1.0
#=====================================================================#


# packages ----------------------------------------------------------------
library(gtrendsR)
library(maps)
library(ggplot2)
library(lettercase)
library(viridis)
library(pals)
library(scico)
library(ggrepel)
library(tidyverse)
library(skimr)

# import  -----------------------------------------------------------------
source("code/01-import.R")

# wrangle wikipedia data night 1 --------
WikiDemAirTime01 <- WikiDemAirTime01Raw %>% 
  magrittr::set_colnames(value = c("candidate", "airtime_night1"))

WikiDemAirTime01 <- WikiDemAirTime01 %>% 
  dplyr::filter(candidate %nin% c("Night one airtime", "Candidate") & 
         airtime_night1  %nin% c("Night one airtime", "Airtime (min.)[58]")) %>% 
  dplyr::mutate(airtime_night1 = as.numeric(airtime_night1))

# wrangle wikipedia data night 2 --------
WikiDemAirTime02 <- WikiDemAirTime02Raw %>% 
  magrittr::set_colnames(value = c("candidate", "airtime_night2")) 
WikiDemAirTime02 <- WikiDemAirTime02 %>% 
    dplyr::filter(candidate %nin% c("Night two airtime", "Candidate") & 
         airtime_night2  %nin% c("Night one airtime", "Airtime (min.)[58]")) %>%
  dplyr::mutate(airtime_night2 = as.numeric(airtime_night2))

# wrangle polling criterion data ------------------------------------------
# create list from names
# dput(WikiPollCriterionRaw[ 1:11, 1])
cand_names_wiki <- c("Warren[note 2]", 
                     "O'Rourke[note 2]", 
                     "Booker[note 2]", 
                     "Klobuchar[note 2]", 
                     "Castro[note 2]", 
                     "Gabbard", 
                     "Ryan", 
                     "Inslee", 
                     "de Blasio", 
                     "Delaney")
# subset with list
WikiPollCriterion <- WikiPollCriterionRaw %>% 
  dplyr::filter(`Candidates drawn for the June 26 debate` %in% cand_names_wiki)
# clean up
WikiPollCriterion <- WikiPollCriterion %>%
  # new names
  magrittr::set_names(value = c("candidates", "polling_crit_perc")) %>% 
  # remove table junk from wiki
  dplyr::mutate(candidates = stringr::str_remove_all(string = candidates, 
                                                 pattern = "\\[note 2\\]")) %>% 
  # split up counts and percents
  tidyr::separate(col = polling_crit_perc, 
                  into = c("poll_perc", "poll_count"), 
                  sep = " ") %>% 
  # remove more junk from wiki
  dplyr::mutate(poll_count = stringr::str_remove_all(string = poll_count, 
                                                 pattern = "\\("),
                # convert to numeric
                poll_count = as.numeric(poll_count),
                # remove % symbol
                poll_perc = stringr::str_remove_all(string = poll_perc, 
                                                 pattern = "\\%"),
                # convert to numeric
                poll_perc = as.numeric(poll_perc),
                # get actual percent
                poll_perc = poll_perc*0.01)

# export wiki tables -------------------------------------------------------
readr::write_csv(as.data.frame(WikiDemAirTime01), path = 
                   paste0(
                     "data/processed/",
                     base::noquote(lubridate::today()),
                     "-WikiDemAirTime01.csv"
                   ))

readr::write_csv(as.data.frame(WikiDemAirTime02), path = 
                   paste0(
                     "data/processed/",
                     base::noquote(lubridate::today()),
                     "-WikiDemAirTime02.csv"
                   ))

readr::write_csv(as.data.frame(WikiPollCriterion), path = 
                   paste0(
                     "data/processed/",
                     base::noquote(lubridate::today()),
                     "-WikiPollCriterion.csv"
                   ))

# wrangle Google trend data -----------------------------------------------
# convert Dems2020Group1 to tibble
GTrendDems2020Group1IOT <- GTrendDems2020Night1G1$interest_over_time %>% 
  as_tibble()
# convert Dems2020Group2 to tibble
GTrendDems2020Group2IOT <- GTrendDems2020Night1G2$interest_over_time %>% 
  as_tibble()

# create numeric hits 
GTrendDems2020Group1IOT <- GTrendDems2020Group1IOT %>% 
  dplyr::mutate(hits = as.numeric(hits)) 
GTrendDems2020Group2IOT <- GTrendDems2020Group2IOT %>%
  dplyr::mutate(hits = as.numeric(hits)) 

# bind -----------------------------------------------
GTrendDems2020Debate01IOT <- bind_rows(GTrendDems2020Group1IOT, 
          GTrendDems2020Group2IOT,
          .id = "data") 

# GTrendDems2020Debate01IOT %>% glimpse(78)
# gender ------------------------------------------------------------------

GTrendDems2020Debate01IOT <- GTrendDems2020Debate01IOT %>% 
  dplyr::mutate(gender = case_when(
    stringr::str_detect(keyword, "Elizabeth Warren") ~ "Women", 
    stringr::str_detect(keyword, "Amy Klobuchar") ~ "Women",
    stringr::str_detect(keyword, "Tulsi Gabbard") ~ "Women",
    TRUE ~ "Men"))

# get distinct
GTrendDems2020Debate01IOT <- GTrendDems2020Debate01IOT %>% distinct()
# GTrendDems2020Debate01IOT %>% glimpse(78)


# join Gtrend with wikipedia data --------------------------------------------
# sort alphabetically, join on id
WikiDemAirTime01 <- WikiDemAirTime01 %>% dplyr::arrange(desc(candidate))
# add id
WikiDemAirTime01 <- WikiDemAirTime01 %>% 
  mutate(candidate_id = row_number())

# WikiDemAirTime01
GTrendDems2020Debate01IOT <- GTrendDems2020Debate01IOT %>% 
  dplyr::mutate(candidate_id = case_when(
    stringr::str_detect(string = keyword, pattern = "Warren") ~ 1,
    stringr::str_detect(string = keyword, pattern = "Ryan") ~ 2,
    stringr::str_detect(string = keyword, pattern = "Beto") ~ 3,
    stringr::str_detect(string = keyword, pattern = "Klobuchar") ~ 4,
    stringr::str_detect(string = keyword, pattern = "Inslee") ~ 5,
    stringr::str_detect(string = keyword, pattern = "Gabbard") ~ 6,
    stringr::str_detect(string = keyword, pattern = "Delaney") ~ 7,
    stringr::str_detect(string = keyword, pattern = "de Blasio") ~ 8,
    stringr::str_detect(string = keyword, pattern = "Castro") ~ 9,
    stringr::str_detect(string = keyword, pattern = "Booker") ~ 10)) %>% 
  dplyr::arrange(desc(candidate_id))

GtrendWikiIOTAirTime <- GTrendDems2020Debate01IOT %>% 
  dplyr::left_join(x = ., 
                   y = WikiDemAirTime01, 
                   by = "candidate_id")

# GtrendWikiIOTAirTime %>%
#   count(keyword, candidate) %>%
#   tidyr::spread(keyword, n)

# poll_perc_cat -------------------------------------------------------------
GtrendWikiIOTAirTime <- GtrendWikiIOTAirTime %>% 
  dplyr::mutate(poll_perc_cat = case_when(
    stringr::str_detect(keyword, "O’Rourke") ~ "> 10.0% of voters",
    stringr::str_detect(keyword, "Warren") ~ "> 10.0% of voters",
    
    stringr::str_detect(keyword, "Booker") ~ "2-4.0% of voters",
    stringr::str_detect(keyword, "Klobuchar") ~ "2-4.0% of voters",
    stringr::str_detect(keyword, "Castro") ~ "2-4.0% of voters",


    stringr::str_detect(keyword, "Gabbard") ~ "1 - 1.3% of voters",
    stringr::str_detect(keyword, "Ryan") ~ "1 - 1.3% of voters",
    stringr::str_detect(keyword, "Inslee") ~ "1 - 1.3% of voters",
    stringr::str_detect(keyword, "de Blasio") ~ "1 - 1.3% of voters",
    stringr::str_detect(keyword, "Delaney") ~ "1 - 1.3% of voters"))

# assing labels
GtrendWikiIOTAirTime <- GtrendWikiIOTAirTime %>% 
  dplyr::mutate(poll_perc_fct = factor(x = poll_perc_cat))
# check levels 
# Dems2020Debate01IOTAirTime$poll_perc_fct %>% levels()

# relvel
GtrendWikiIOTAirTime <- GtrendWikiIOTAirTime %>% 
  dplyr::mutate(poll_perc_fct = forcats::fct_relevel(.f = poll_perc_fct,
                    "> 10.0% of voters",
                    "2-4.0% of voters",
                    "1 - 1.3% of voters"))

# check levels 
GtrendWikiIOTAirTime$poll_perc_fct %>% levels()

# mapping data (by region) ------------------------------------------------
# convert to tibble (another data structure in R)
GtrendDems2020IBRGroup1 <- tibble::as_tibble(GTrendDems2020Night1G1$interest_by_region)
GtrendDems2020IBRGroup2 <- tibble::as_tibble(GTrendDems2020Night1G2$interest_by_region)
# bind Dems2020IBRGroup1 Dems2020IBRGroup2 together 
GtrendDems2020IBR <- bind_rows(GtrendDems2020IBRGroup1, 
                        GtrendDems2020IBRGroup2, .id = "data")

# convert the region to lowercase
GtrendDems2020InterestByRegion <- GtrendDems2020IBR %>% 
  dplyr::mutate(region = stringr::str_to_lower(location))
# create a data set for the states in the US
statesMap = ggplot2::map_data("state")
# now merge the two data sources together
GtrendDems2020InterestByRegion <- GtrendDems2020InterestByRegion %>% 
  dplyr::inner_join(x = .,
                   y = statesMap, 
                   by = "region")


# create processed data folder --------
if (!file.exists("data/processed")) {
  dir.create("data/processed")
} 

# export GtrendDems2020InterestByRegion ----
readr::write_csv(as.data.frame(GtrendDems2020InterestByRegion), 
                                        paste0("data/processed/",
                                        noquote(lubridate::today()),
                                        "-GtrendDems2020InterestByRegion.csv"))
# export GtrendWikiIOTAirTime ----
readr::write_csv(as.data.frame(GtrendWikiIOTAirTime), paste0("data/processed/",
                                        noquote(lubridate::today()),
                                        "-GtrendWikiIOTAirTime.csv"))
