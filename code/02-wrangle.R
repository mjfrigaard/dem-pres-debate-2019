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
ls()

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

# export wiki table -------------------------------------------------------

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


# wrangle Google trend data -----------------------------------------------
# convert Dems2020Group1 to tibble
Dems2020Group1IOT <- Dems2020Night1Group1$interest_over_time %>% as_tibble()
# convert Dems2020Group2 to tibble
Dems2020Group2IOT <- Dems2020Night1Group2$interest_over_time %>% as_tibble()

# create numeric hits 
Dems2020Group1IOT <- Dems2020Group1IOT %>% 
  dplyr::mutate(hits = as.numeric(hits)) 
Dems2020Group2IOT <- Dems2020Group2IOT %>%
  dplyr::mutate(hits = as.numeric(hits)) 

# bind -----------------------------------------------
Dems2020Debate01IOT <- bind_rows(Dems2020Group1IOT, 
          Dems2020Group2IOT,
          .id = "data") 

# Dems2020Debate01IOT %>% glimpse(78)

# gender ------------------------------------------------------------------

Dems2020Debate01IOT <- Dems2020Debate01IOT %>% 
  dplyr::mutate(gender = case_when(
    stringr::str_detect(keyword, "Elizabeth Warren") ~ "Women", 
    stringr::str_detect(keyword, "Amy Klobuchar") ~ "Women",
    stringr::str_detect(keyword, "Tulsi Gabbard") ~ "Women",
    TRUE ~ "Men"))

# get distinct
Dems2020Debate01IOT <- Dems2020Debate01IOT %>% distinct()
# Dems2020Debate01IOT %>% glimpse(78)


# join with wikipedia data ------------------------------------------------
# sort alphabetically, join on id
WikiDemAirTime01 <- WikiDemAirTime01 %>% dplyr::arrange(desc(candidate))
# add id
WikiDemAirTime01 <- WikiDemAirTime01 %>% 
  mutate(candidate_id = row_number())
# WikiDemAirTime01
Dems2020Debate01IOT <- Dems2020Debate01IOT %>% 
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

Dems2020Debate01IOTAirTime <- Dems2020Debate01IOT %>% 
  dplyr::left_join(x = ., 
                   y = WikiDemAirTime01, 
                   by = "candidate_id")

# Dems2020Debate01IOTAirTime %>% 
#   count(keyword, candidate) %>% 
#   tidyr::spread(keyword, n)

# prior_vperc -------------------------------------------------------------

Dems2020Debate01IOTAirTime <- Dems2020Debate01IOTAirTime %>% 
  dplyr::mutate(prior_vperc = case_when(
    stringr::str_detect(keyword, "O’Rourke") ~ "> 1.0% of voters",
    stringr::str_detect(keyword, "Warren") ~ "> 1.0% of voters",
    stringr::str_detect(keyword, "Booker") ~ "> 1.0% of voters",
    
    stringr::str_detect(keyword, "Klobuchar") ~ "0.5 - 0.9% of voters",
    stringr::str_detect(keyword, "Castro") ~ "0.5 - 0.9% of voters",


    stringr::str_detect(keyword, "Gabbard") ~ "0.2 - 0.4% of voters",
    stringr::str_detect(keyword, "Ryan") ~ "0.2 - 0.4% of voters",
    stringr::str_detect(keyword, "Inslee") ~ "0.2 - 0.4% of voters",
    stringr::str_detect(keyword, "de Blasio") ~ "0.2 - 0.4% of voters",

    stringr::str_detect(keyword, "Delaney") ~ "0.2% of voters"))

# assing labels
Dems2020Debate01IOTAirTime <- Dems2020Debate01IOTAirTime %>% 
  dplyr::mutate(prior_vperc_fct = factor(x = prior_vperc))
# check levels 
# Dems2020Debate01IOTAirTime$prior_vperc_fct %>% levels()

# relvel
Dems2020Debate01IOTAirTime <- Dems2020Debate01IOTAirTime %>% 
  dplyr::mutate(prior_vperc_fct = forcats::fct_relevel(.f = prior_vperc_fct,
                    "> 1.0% of voters",
                    "0.5 - 0.9% of voters",
                    "0.2 - 0.4% of voters",
                    "0.2% of voters"))

# check levels 
Dems2020Debate01IOTAirTime$prior_vperc_fct %>% levels()

# mapping data (by region) ------------------------------------------------
# convert to tibble (another data structure in R)
Dems2020IBRGroup1 <- tibble::as_tibble(Dems2020Night1Group1$interest_by_region)
Dems2020IBRGroup2 <- tibble::as_tibble(Dems2020Night1Group2$interest_by_region)
# bind Dems2020IBRGroup1 Dems2020IBRGroup2 together 
Dems2020IBR <- bind_rows(Dems2020IBRGroup1, 
                              Dems2020IBRGroup2, .id = "data")

# convert the region to lowercase
Dems2020InterestByRegion <- Dems2020IBR %>% 
  dplyr::mutate(region = stringr::str_to_lower(location))
# create a data set for the states in the US
statesMap = ggplot2::map_data("state")
# now merge the two data sources together
Dems2020InterestByRegion <- Dems2020InterestByRegion %>% 
  dplyr::inner_join(x = .,
                   y = statesMap, 
                   by = "region")



# create processed data folder --------
if (!file.exists("data/processed")) {
  dir.create("data/processed")
} 

# export Dems2020InterestByRegion
readr::write_csv(as.data.frame(Dems2020InterestByRegion), paste0("data/processed/",
                                        noquote(lubridate::today()),
                                        "-Dems2020InterestByRegion.csv"))
# export Dems2020Debate01IOT

readr::write_csv(as.data.frame(Dems2020Debate01IOT), paste0("data/processed/",
                                        noquote(lubridate::today()),
                                        "-Dems2020Debate01IOT.csv"))
