#=====================================================================#
# This is code to create: 00-packages.R
# Authored by and feedback to mjfrigaard@gmail.com
# MIT License
# Version: 1.1
#=====================================================================#

# first install devtools
install.packages("devtools")

# now get the gtrends package
devtools::install_github('PMassicotte/gtrendsR')

# install the other packages for mapping
install.packages(c("gtrendsR", "maps", 
                   "lettercase", "viridis", 
                   "pals", "tidyverse", 
                   "ggrepel", "scico", 
                   "ggthemes", "skimr",
                   "Hmisc", "janitor"))


