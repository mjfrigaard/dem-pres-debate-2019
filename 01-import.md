Import Democratic Candidate 2019 Data
================
Jane Doe

**Rmarkdown:**

This is an R Markdown format used for publishing markdown documents.
When you click the **Knit** button all R code chunks are run and a
markdown file (`.md`) suitable for publishing to GitHub is generated.

**Including Code:**

You can include R code in the document to keep track of your work\!
Below we perform a search for Democratic presidential candidates during
the debates in June of 2019.

# Motivation

This document describes how various data sources were downloaded for
this project. The first night of the Democratic presidential debate held
in Miami, Florida, on June 26, 2019.

## The data

  - Google trend data from the
    [`gtrendsR`](https://github.com/PMassicotte/gtrendsR) package for R
    gives us access to Google search terms and trends. We’re going to
    use this to import data on Google searches for the candidates before
    and after the night of the debates.

<!-- end list -->

2)  The [`rtweet`](https://rtweet.info/) package in R takes a little bit
    to get set up. Fortunately, we’ve written a tutorial
    [here](http://www.storybench.org/get-twitter-data-rtweet-r/) and the
    package has excellent documentation (see
    [here](https://rtweet.info/articles/auth.html) and
    [here](https://rtweet.info/articles/intro.html)).

We passed the following search items through the `gtrendsR::gtrends()`
function below to download the data into our RStudio environment. The
first night of the Democratic presidential debate was June 26, 2019, but
the code below will collected data for 30 days of June. We will be
collecting data from June 01, 2019 until June 30, 2019 to get a gauge of
how well (or how bad) each candidate did in terms of gaining interest
(as measured by Google search trends).

``` r
# get group 1 from debate
# Dems2020Night1Group1 <- 
gtrendsR::gtrends(keyword = c("Bill de Blasio 2020",
                                               "Cory Booker 2020",
                                               "Julián Castro 2020",
                                               "John Delaney 2020",
                                               "Jay Inslee 2020"), 
                                    # enter dates
                                    time = "2019-06-01 2019-06-30",
                                    gprop = "web",
                                    geo = c("US"))



# get group 2 from debate
# Dems2020Night1Group2 <- 
gtrendsR::gtrends(keyword = c("Amy Klobuchar 2020",
                                                "Tulsi Gabbard 2020",
                                                "Beto O’Rourke 2020",
                                                "Tim Ryan 2020",
                                                "Elizabeth Warren 2020"), 
                                                # enter dates
                                      time = "2019-06-01 2019-06-30",
                                      gprop = "web",
                                      geo = c("US"))
```

Below is an example of how to download twitter data using multiple
search terms.

``` r
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
```

3)  There are data from voters on how they felt about each candidate
    going into the debates stored in a Google Sheet
    [here](http://bit.ly/2YEVASu) that we’ve accessed using the
    [`googlesheets`](https://cran.r-project.org/web/packages/googlesheets/vignettes/basic-usage.html)
    package in R (*you will need to copy this sheet into your Google
    drive to get this data set*). Another option is to use the
    [`datapasta`](https://cran.r-project.org/web/packages/datapasta/README.html)
    package and copy + paste these data into R.

4)  There is a
    [Wikipedia](https://en.wikipedia.org/wiki/2020_Democratic_Party_presidential_debates_and_forums)
    page dedicated to the debates. We will be extracting the tables with
    airtime for candidate using the
    [`xml2`](https://cran.r-project.org/web/packages/xml2/index.html)
    and [`rvest`](https://rvest.tidyverse.org/) packages.

<!-- end list -->

``` r
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
```

## Packages

The Google search trends are accessible via the
[gtrendsR](https://github.com/PMassicotte/gtrendsR) package. This and
other packages are in the `00-packages.R` script. We load these packages
in the code chunk below.

``` r
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
```

## The candidates

There were ten candidates in the first night of the debates, and ten in
the second night. We have created a table with all of them listed
alphabetically below.

``` r
dem_candidates <- c("Amy Klobuchar",
                "Beto O’Rourke",
                "Bill de Blasio",
                "Cory Booker",
                "Elizabeth Warren",
                "Jay Inslee",
                "John Delaney",
                "Julián Castro",
                "Tim Ryan",
                "Tulsi Gabbard")
writeLines(dem_candidates)
```

We can pass the following search items through the `gtrendsR::gtrends()`
function below to download the data into our RStudio environment.

The first night of the Democratic presidential debate was held in Miami,
Florida, on June 26, 2019, so we’ve included the day before (June 25th)
and the day of the debate.

The code below was used to get the Google trend data the day after the
debate, **so don’t run this again** (it’s been placed here just for
documentation purposes).

``` r
# get group 1 from debate
gtrendsR::gtrends(keyword = c("Bill de Blasio 2020",
                               "Cory Booker 2020",
                               "Julián Castro 2020",
                               "John Delaney 2020",
                               "Jay Inslee 2020"), 
                                    # enter dates
                                    time = "now 7-d",
                                    gprop = "web",
                                    geo = c("US"))

# get group 2 from debate
gtrendsR::gtrends(keyword = c("Amy Klobuchar 2020",
                                                "Tulsi Gabbard 2020",
                                                "Beto O’Rourke 2020",
                                                "Tim Ryan 2020",
                                                "Elizabeth Warren 2020"), 
                                                # enter dates
                                                time = "now 7-d",
                                                    gprop = "web",
                                                    geo = c("US"))
```

We will import the data using the script below

``` r
source("code/01-import.R")
ls()
```

    #>   [1] "Cand538Fav"               "Dems2020Night1Group1"    
    #>   [3] "Dems2020Night1Group2"     "google_data_files"       
    #>   [5] "google_data_path"         "GoogleData"              
    #>   [7] "twitter_data_files"       "twitter_data_path"       
    #>   [9] "twitter_users_data_files" "TwitterData"             
    #>  [11] "TwitterUsersData"         "wiki_data_files"         
    #>  [13] "wiki_data_path"           "WikiData"                
    #>  [15] "WikiDemAirTime01Raw"      "WikiDemAirTime02Raw"

### Understanding the data structures

What did we just download? We can check this with `utils::str()`

``` r
utils::str(Dems2020Night1Group1)
```

    #>  List of 7
    #>   $ interest_over_time :'data.frame':    150 obs. of  7 variables:
    #>    ..$ date    : POSIXct[1:150], format: "2019-06-01" ...
    #>    ..$ hits    : int [1:150] 0 0 7 3 0 0 5 0 4 0 ...
    #>    ..$ geo     : chr [1:150] "US" "US" "US" "US" ...
    #>    ..$ time    : chr [1:150] "2019-06-01 2019-06-30" "2019-06-01 2019-06-30" "2019-06-01 2019-06-30" "2019-06-01 2019-06-30" ...
    #>    ..$ keyword : chr [1:150] "Bill de Blasio 2020" "Bill de Blasio 2020" "Bill de Blasio 2020" "Bill de Blasio 2020" ...
    #>    ..$ gprop   : chr [1:150] "web" "web" "web" "web" ...
    #>    ..$ category: int [1:150] 0 0 0 0 0 0 0 0 0 0 ...
    #>   $ interest_by_country: NULL
    #>   $ interest_by_region :'data.frame':    255 obs. of  5 variables:
    #>    ..$ location: chr [1:255] "New Jersey" "Connecticut" "Michigan" "Virginia" ...
    #>    ..$ hits    : int [1:255] 100 92 76 74 65 53 33 31 28 20 ...
    #>    ..$ keyword : chr [1:255] "Bill de Blasio 2020" "Bill de Blasio 2020" "Bill de Blasio 2020" "Bill de Blasio 2020" ...
    #>    ..$ geo     : chr [1:255] "US" "US" "US" "US" ...
    #>    ..$ gprop   : chr [1:255] "web" "web" "web" "web" ...
    #>   $ interest_by_dma    :'data.frame':    1050 obs. of  5 variables:
    #>    ..$ location: chr [1:1050] "Atlanta GA" "Washington DC (Hagerstown MD)" "Boston MA-Manchester NH" "New York NY" ...
    #>    ..$ hits    : int [1:1050] 100 87 79 70 21 NA NA NA NA NA ...
    #>    ..$ keyword : chr [1:1050] "Bill de Blasio 2020" "Bill de Blasio 2020" "Bill de Blasio 2020" "Bill de Blasio 2020" ...
    #>    ..$ geo     : chr [1:1050] "US" "US" "US" "US" ...
    #>    ..$ gprop   : chr [1:1050] "web" "web" "web" "web" ...
    #>   $ interest_by_city   : NULL
    #>   $ related_topics     : NULL
    #>   $ related_queries    : NULL
    #>   - attr(*, "class")= chr [1:2] "gtrends" "list"

``` r
utils::str(Dems2020Night1Group2)
```

    #>  List of 7
    #>   $ interest_over_time :'data.frame':    150 obs. of  7 variables:
    #>    ..$ date    : POSIXct[1:150], format: "2019-06-01" ...
    #>    ..$ hits    : int [1:150] 3 3 0 2 0 2 4 3 0 2 ...
    #>    ..$ geo     : chr [1:150] "US" "US" "US" "US" ...
    #>    ..$ time    : chr [1:150] "2019-06-01 2019-06-30" "2019-06-01 2019-06-30" "2019-06-01 2019-06-30" "2019-06-01 2019-06-30" ...
    #>    ..$ keyword : chr [1:150] "Amy Klobuchar 2020" "Amy Klobuchar 2020" "Amy Klobuchar 2020" "Amy Klobuchar 2020" ...
    #>    ..$ gprop   : chr [1:150] "web" "web" "web" "web" ...
    #>    ..$ category: int [1:150] 0 0 0 0 0 0 0 0 0 0 ...
    #>   $ interest_by_country: NULL
    #>   $ interest_by_region :'data.frame':    255 obs. of  5 variables:
    #>    ..$ location: chr [1:255] "Rhode Island" "Vermont" "North Dakota" "Minnesota" ...
    #>    ..$ hits    : int [1:255] 100 99 93 49 46 44 43 18 16 15 ...
    #>    ..$ keyword : chr [1:255] "Amy Klobuchar 2020" "Amy Klobuchar 2020" "Amy Klobuchar 2020" "Amy Klobuchar 2020" ...
    #>    ..$ geo     : chr [1:255] "US" "US" "US" "US" ...
    #>    ..$ gprop   : chr [1:255] "web" "web" "web" "web" ...
    #>   $ interest_by_dma    :'data.frame':    1050 obs. of  5 variables:
    #>    ..$ location: chr [1:1050] "Fargo-Valley City ND" "Buffalo NY" "Portland-Auburn ME" "Ft. Myers-Naples FL" ...
    #>    ..$ hits    : int [1:1050] 100 61 48 44 39 38 36 34 29 29 ...
    #>    ..$ keyword : chr [1:1050] "Amy Klobuchar 2020" "Amy Klobuchar 2020" "Amy Klobuchar 2020" "Amy Klobuchar 2020" ...
    #>    ..$ geo     : chr [1:1050] "US" "US" "US" "US" ...
    #>    ..$ gprop   : chr [1:1050] "web" "web" "web" "web" ...
    #>   $ interest_by_city   : NULL
    #>   $ related_topics     : NULL
    #>   $ related_queries    :'data.frame':    3 obs. of  6 variables:
    #>    ..$ subject        : chr [1:3] "100" "44" "Breakout"
    #>    ..$ related_queries: chr [1:3] "top" "top" "rising"
    #>    ..$ value          : chr [1:3] "democratic candidates 2020" "elizabeth warren age" "elizabeth warren age"
    #>    ..$ geo            : chr [1:3] "US" "US" "US"
    #>    ..$ keyword        : chr [1:3] "Elizabeth Warren 2020" "Elizabeth Warren 2020" "Elizabeth Warren 2020"
    #>    ..$ category       : int [1:3] 0 0 0
    #>    ..- attr(*, "reshapeLong")=List of 4
    #>    .. ..$ varying:List of 1
    #>    .. .. ..$ value: chr "top"
    #>    .. .. ..- attr(*, "v.names")= chr "value"
    #>    .. .. ..- attr(*, "times")= chr "top"
    #>    .. ..$ v.names: chr "value"
    #>    .. ..$ idvar  : chr "id"
    #>    .. ..$ timevar: chr "related_queries"
    #>   - attr(*, "class")= chr [1:2] "gtrends" "list"

We can see this creates two objects, each as a `List of 7`. We’ll go
ahead and export these into the `data/raw` folder now for safe keeping.

### A little R programming

Your code will always be communicating to at least two audiences: your
computer, and your future self. Be nice to both of them\!

Things like the pipe `%>%` in R can help with clarity. It takes code
written like this:

``` r
outer_function(inner_function(Data_X), Data_Y)
```

And makes it look like this:

``` r
Data_X %>% # do this 
   inner_function() %>% # then do this
   outer_function(Data_Y)
```

Convert to tibble.

``` r
# convert Dems2020Night1Group1 to tibble
Dems2020Night1Group1IOT <- Dems2020Night1Group1$interest_over_time %>% as_tibble()
# convert Dems2020Night1Group2 to tibble
Dems2020Night1Group2IOT <- Dems2020Night1Group2$interest_over_time %>% as_tibble()
Dems2020Night1Group1IOT %>% glimpse(78)
```

    #>  Observations: 150
    #>  Variables: 7
    #>  $ date     <dttm> 2019-06-01, 2019-06-02, 2019-06-03, 2019-06-04, 2019-06-0…
    #>  $ hits     <int> 0, 0, 7, 3, 0, 0, 5, 0, 4, 0, 0, 0, 0, 7, 0, 4, 3, 0, 3, 0…
    #>  $ geo      <chr> "US", "US", "US", "US", "US", "US", "US", "US", "US", "US"…
    #>  $ time     <chr> "2019-06-01 2019-06-30", "2019-06-01 2019-06-30", "2019-06…
    #>  $ keyword  <chr> "Bill de Blasio 2020", "Bill de Blasio 2020", "Bill de Bla…
    #>  $ gprop    <chr> "web", "web", "web", "web", "web", "web", "web", "web", "w…
    #>  $ category <int> 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0…

``` r
Dems2020Night1Group2IOT %>% glimpse(78)
```

    #>  Observations: 150
    #>  Variables: 7
    #>  $ date     <dttm> 2019-06-01, 2019-06-02, 2019-06-03, 2019-06-04, 2019-06-0…
    #>  $ hits     <int> 3, 3, 0, 2, 0, 2, 4, 3, 0, 2, 0, 0, 5, 2, 0, 3, 0, 0, 4, 0…
    #>  $ geo      <chr> "US", "US", "US", "US", "US", "US", "US", "US", "US", "US"…
    #>  $ time     <chr> "2019-06-01 2019-06-30", "2019-06-01 2019-06-30", "2019-06…
    #>  $ keyword  <chr> "Amy Klobuchar 2020", "Amy Klobuchar 2020", "Amy Klobuchar…
    #>  $ gprop    <chr> "web", "web", "web", "web", "web", "web", "web", "web", "w…
    #>  $ category <int> 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0…

Change the `hits` to numeric (from string)

``` r
# create numeric hits 
Dems2020Night1Group1IOT <- Dems2020Night1Group1IOT %>% 
  dplyr::mutate(hits = as.numeric(hits)) 
Dems2020Night1Group2IOT <- Dems2020Night1Group2IOT %>%
  dplyr::mutate(hits = as.numeric(hits)) 
Dems2020Night1Group1IOT %>% glimpse(78)
```

    #>  Observations: 150
    #>  Variables: 7
    #>  $ date     <dttm> 2019-06-01, 2019-06-02, 2019-06-03, 2019-06-04, 2019-06-0…
    #>  $ hits     <dbl> 0, 0, 7, 3, 0, 0, 5, 0, 4, 0, 0, 0, 0, 7, 0, 4, 3, 0, 3, 0…
    #>  $ geo      <chr> "US", "US", "US", "US", "US", "US", "US", "US", "US", "US"…
    #>  $ time     <chr> "2019-06-01 2019-06-30", "2019-06-01 2019-06-30", "2019-06…
    #>  $ keyword  <chr> "Bill de Blasio 2020", "Bill de Blasio 2020", "Bill de Bla…
    #>  $ gprop    <chr> "web", "web", "web", "web", "web", "web", "web", "web", "w…
    #>  $ category <int> 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0…

``` r
Dems2020Night1Group2IOT %>% glimpse(78)
```

    #>  Observations: 150
    #>  Variables: 7
    #>  $ date     <dttm> 2019-06-01, 2019-06-02, 2019-06-03, 2019-06-04, 2019-06-0…
    #>  $ hits     <dbl> 3, 3, 0, 2, 0, 2, 4, 3, 0, 2, 0, 0, 5, 2, 0, 3, 0, 0, 4, 0…
    #>  $ geo      <chr> "US", "US", "US", "US", "US", "US", "US", "US", "US", "US"…
    #>  $ time     <chr> "2019-06-01 2019-06-30", "2019-06-01 2019-06-30", "2019-06…
    #>  $ keyword  <chr> "Amy Klobuchar 2020", "Amy Klobuchar 2020", "Amy Klobuchar…
    #>  $ gprop    <chr> "web", "web", "web", "web", "web", "web", "web", "web", "w…
    #>  $ category <int> 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0…

Bind these together.

``` r
# bind
Dems2020Debate01IOT <- bind_rows(Dems2020Night1Group1IOT, 
                                 Dems2020Night1Group2IOT,
                                 .id = "data") 
```

Check the min and max for the date.

``` r
# get min
min(Dems2020Debate01IOT$date)
```

    #>  [1] "2019-06-01 GMT"

``` r
# get max
max(Dems2020Debate01IOT$date)
```

    #>  [1] "2019-06-30 GMT"

This is measuring interest from 2019-06-01 until 2019-06-30 the next
day.

## Wrangle

We will perform a few functions to get these data ready for
visualizations.

### Men and Women

Create a `gender` variable for each candidate.

``` r
Dems2020Debate01IOT <- Dems2020Debate01IOT %>% 
  dplyr::mutate(gender = case_when(
    stringr::str_detect(keyword, "Elizabeth Warren") ~ "Women", 
    stringr::str_detect(keyword, "Amy Klobuchar") ~ "Women",
    stringr::str_detect(keyword, "Tulsi Gabbard") ~ "Women",
    TRUE ~ "Men"))
# get distinct
Dems2020Debate01IOT <- Dems2020Debate01IOT %>% distinct()
# check new gender variable 
Dems2020Debate01IOT %>% 
  dplyr::count(keyword, gender) %>%
  tidyr::spread(gender, n)
```

    #>  # A tibble: 10 x 3
    #>     keyword                 Men Women
    #>     <chr>                 <int> <int>
    #>   1 Amy Klobuchar 2020       NA    30
    #>   2 Beto O’Rourke 2020       30    NA
    #>   3 Bill de Blasio 2020      30    NA
    #>   4 Cory Booker 2020         30    NA
    #>   5 Elizabeth Warren 2020    NA    30
    #>   6 Jay Inslee 2020          30    NA
    #>   7 John Delaney 2020        30    NA
    #>   8 Julián Castro 2020       30    NA
    #>   9 Tim Ryan 2020            30    NA
    #>  10 Tulsi Gabbard 2020       NA    30

### Priors: Calculate the % of likely Democratic voters

We’ll split the men into three groups based on the [article updated on
JUN. 26, 2019, AT 5:53 PM by
fivethirtyeight](https://projects.fivethirtyeight.com/democratic-debate-poll/),
“Who likely Democratic voters would vote for if the election were held
today.”

These data are stored in

``` r
Cand538Fav %>% 
  dplyr::count(candidate, before) %>% 
  dplyr::arrange(desc(before))
```

    #>  # A tibble: 20 x 3
    #>     candidate           before     n
    #>     <chr>                <dbl> <int>
    #>   1 Joe Biden             38.5     1
    #>   2 Bernie Sanders        16.3     1
    #>   3 Elizabeth Warren      12.7     1
    #>   4 Kamala Harris          7.9     1
    #>   5 Pete Puttigieg         6.9     1
    #>   6 Beto O’Rourke          3.9     1
    #>   7 Cory Booker            2.8     1
    #>   8 Andrew Yang            1       1
    #>   9 Kirsten Gillibrand     0.8     1
    #>  10 Julian Castro          0.6     1
    #>  11 Tulsi Gabbard          0.6     1
    #>  12 Jay Inslee             0.5     1
    #>  13 John Hickenlooper      0.4     1
    #>  14 Amy Klobuchar          0.2     1
    #>  15 Eric Swalwell          0.2     1
    #>  16 John Delaney           0.2     1
    #>  17 Michael Bennet         0.2     1
    #>  18 Tim Ryan               0.2     1
    #>  19 Marianne Williamson    0.1     1
    #>  20 Bill de Blasio         0       1

These groups were: `"> 1.0% of voters"`, `"0.5 - 0.9% of voters"`, `"0.2
- 0.4% of voters"`, and `"0.2 % of voters"`

See the categories below.

``` r
Dems2020Debate01IOT <- Dems2020Debate01IOT %>% 
  dplyr::mutate(prior_vperc = case_when(
    # high voters
    stringr::str_detect(keyword, "O’Rourke") ~ "> 1.0% of voters",
    stringr::str_detect(keyword, "Warren") ~ "> 1.0% of voters",
    stringr::str_detect(keyword, "Booker") ~ "> 1.0% of voters",
    # med voters
    stringr::str_detect(keyword, "Klobuchar") ~ "0.5 - 0.9% of voters",
    stringr::str_detect(keyword, "Castro") ~ "0.5 - 0.9% of voters",

    # low voters
    stringr::str_detect(keyword, "Gabbard") ~ "0.2 - 0.4% of voters",
    stringr::str_detect(keyword, "Ryan") ~ "0.2 - 0.4% of voters",
    stringr::str_detect(keyword, "Inslee") ~ "0.2 - 0.4% of voters",
    stringr::str_detect(keyword, "de Blasio") ~ "0.2 - 0.4% of voters",
    # very low voters
    stringr::str_detect(keyword, "Delaney") ~ "0.2% of voters"))
# verify the new variable
Dems2020Debate01IOT %>% 
  dplyr::count(prior_vperc, keyword) %>%
  tidyr::spread(prior_vperc, n)
```

    #>  # A tibble: 10 x 5
    #>     keyword               `> 1.0% of voters` `0.2 - 0.4% of voters`
    #>     <chr>                              <int>                  <int>
    #>   1 Amy Klobuchar 2020                    NA                     NA
    #>   2 Beto O’Rourke 2020                    30                     NA
    #>   3 Bill de Blasio 2020                   NA                     30
    #>   4 Cory Booker 2020                      30                     NA
    #>   5 Elizabeth Warren 2020                 30                     NA
    #>   6 Jay Inslee 2020                       NA                     30
    #>   7 John Delaney 2020                     NA                     NA
    #>   8 Julián Castro 2020                    NA                     NA
    #>   9 Tim Ryan 2020                         NA                     30
    #>  10 Tulsi Gabbard 2020                    NA                     30
    #>     `0.2% of voters` `0.5 - 0.9% of voters`
    #>                <int>                  <int>
    #>   1               NA                     30
    #>   2               NA                     NA
    #>   3               NA                     NA
    #>   4               NA                     NA
    #>   5               NA                     NA
    #>   6               NA                     NA
    #>   7               30                     NA
    #>   8               NA                     30
    #>   9               NA                     NA
    #>  10               NA                     NA

The `prior_vperc` is a character variable, so there is not inherent
order to their levels. I will also create a factor variable (and orderd
categorical variable) and specify the levels. I can do this below using
the `forcats::fct_relevel()` function.

``` r
# convert to a factor 
Dems2020Debate01IOT <- Dems2020Debate01IOT %>% 
  dplyr::mutate(prior_vperc_fct = factor(x = prior_vperc))
# relevel the factor variable 
Dems2020Debate01IOT <- Dems2020Debate01IOT %>% 
  dplyr::mutate(prior_vperc_fct = forcats::fct_relevel(.f = prior_vperc_fct,
                    "> 1.0% of voters",
                    "0.5 - 0.9% of voters",
                    "0.2 - 0.4% of voters",
                    "0.2% of voters"))
# check levels of new factor
Dems2020Debate01IOT$prior_vperc_fct %>% levels()
```

    #>  [1] "> 1.0% of voters"     "0.5 - 0.9% of voters" "0.2 - 0.4% of voters"
    #>  [4] "0.2% of voters"

## Skim of the Google data

This is a very top level view of the Google trend data.

``` r
Dems2020Debate01IOT %>% skimr::skim()
```
