2019 Democratic Debates data project
================
Jane Doe

# Motivation

We read [this interesting article on
fivethirtyeight](https://projects.fivethirtyeight.com/democratic-debate-poll/)
about the democratic debates in June of 2019. In particular, the image
below that displays how voters had changed their minds after watching
the candidates.

![](figs/03-538-night-one-debates.png)<!-- -->

Naturally, we wanted to see how popular each democratic candidate did
*after* the first round of [2019 Democratic Presidential
Debates](https://en.wikipedia.org/wiki/2020_Democratic_Party_presidential_debates_and_forums),
but we’d missed all the coverage.

This document outlines the data import, wrangling, and visulizations
used in this project. Below is a folder tree of this project so you can
get oriented to it’s structure.

``` r
fs::dir_tree(".", recurse = FALSE)    
```

    ## .
    ## ├── 01-import.Rmd
    ## ├── 02-wrangle.Rmd
    ## ├── 03-visualize.Rmd
    ## ├── README.Rmd
    ## ├── README.md
    ## ├── code
    ## ├── data
    ## ├── dem-pres-debate-2019.Rproj
    ## └── figs

## Data sources

These data come from four different sources: Google trends, twitter,
Google sheets, and Wikipedia. Details on the data sources are found the
`00-download-` files below.

``` r
fs::dir_ls("code", regexp = "download")
```

    ## code/ 00-download-tweets.R   code/00-download-538.R       
    ## code/00-download-google.R    code/00-download-wikipedia.R

## Import the data

The code chunk below will run in `01-import.R` file and load all the
data into the RStudio session.

``` r
source("code/01-import.R")
```

The data sources are all `CamelCase` (read more about it
[here](https://en.wikipedia.org/wiki/Camel_case)), so we can list them
using the code chunk below.

``` r
ls(pattern = "[A-Z]+")
```

    ##  [1] "GoogleData"             "GSheetCand538Fav"      
    ##  [3] "GTrendDems2020Night1G1" "GTrendDems2020Night1G2"
    ##  [5] "TwitterData"            "TwitterUsersData"      
    ##  [7] "WikiData"               "WikiDemAirTime01Raw"   
    ##  [9] "WikiDemAirTime02Raw"    "WikiPollCriterionRaw"

## The democratic candidates (night 1)

There were ten candidates in the first night of debates, and all are
listed alphabetically below.

``` r
dem_candidates <- c("Warren", "Ryan", "O'Rourke", "Klobuchar", "Inslee", 
                    "Gabbard", "Delaney", "de Blasio", "Castro", "Booker")
base::writeLines(dem_candidates)
```

    ## Warren
    ## Ryan
    ## O'Rourke
    ## Klobuchar
    ## Inslee
    ## Gabbard
    ## Delaney
    ## de Blasio
    ## Castro
    ## Booker

### The Wikipedia table

[Wikipedia page on 2020 democratic debates (first
night)](https://en.wikipedia.org/wiki/2020_Democratic_Party_presidential_debates_and_forums#First_debates_\(June_26%E2%80%9327,_2019\)).

The data, `WikiDemAirTime01Raw` and `WikiDemAirTime02Raw` are in the
work session below.

``` r
WikiDemAirTime01Raw %>% utils::str()
```

    ## Classes 'spec_tbl_df', 'tbl_df', 'tbl' and 'data.frame': 12 obs. of  2 variables:
    ##  $ X1: chr  "Night one airtime" "Candidate" "Booker" "O'Rourke" ...
    ##  $ X2: chr  "Night one airtime" "Airtime (min.)[57]" "10.9" "10.3" ...
    ##  - attr(*, "spec")=
    ##   .. cols(
    ##   ..   X1 = col_character(),
    ##   ..   X2 = col_character()
    ##   .. )

``` r
WikiDemAirTime02Raw %>% utils::str()
```

    ## Classes 'spec_tbl_df', 'tbl_df', 'tbl' and 'data.frame': 12 obs. of  2 variables:
    ##  $ X1: chr  "Night two airtime" "Candidate" "Biden" "Harris" ...
    ##  $ X2: chr  "Night two airtime" "Airtime (min.)[57]" "13.6" "11.9" ...
    ##  - attr(*, "spec")=
    ##   .. cols(
    ##   ..   X1 = col_character(),
    ##   ..   X2 = col_character()
    ##   .. )

We can see these two tables have some extra information in them, so
they’ll need a bit of wrangling work done.

### Google trends data

We’re interested in collecting data from June 25, 2019 until June 27,
2019 to get a gauge of how well (or how bad) each candidate did in terms
of gaining interest (as measured by Google search trends). The Google
search trends are accessible via the
[gtrendsR](https://github.com/PMassicotte/gtrendsR) package.

### Google search terms

Each candidates name was searched for with “2020”. We thought it would
be a good idea to add “2020” to the candidates name to make it easier to
identify searches that corresponded to the interested with the upcoming
election.

These data are stored in `GoogleData` list (visibile below).

``` r
GoogleData %>% utils::str(max.level = 2)
```

    ## List of 2
    ##  $ :List of 7
    ##   ..$ interest_over_time :'data.frame':  150 obs. of  7 variables:
    ##   ..$ interest_by_country: NULL
    ##   ..$ interest_by_region :'data.frame':  255 obs. of  5 variables:
    ##   ..$ interest_by_dma    :'data.frame':  1050 obs. of  5 variables:
    ##   ..$ interest_by_city   : NULL
    ##   ..$ related_topics     : NULL
    ##   ..$ related_queries    : NULL
    ##   ..- attr(*, "class")= chr [1:2] "gtrends" "list"
    ##  $ :List of 7
    ##   ..$ interest_over_time :'data.frame':  150 obs. of  7 variables:
    ##   ..$ interest_by_country: NULL
    ##   ..$ interest_by_region :'data.frame':  255 obs. of  5 variables:
    ##   ..$ interest_by_dma    :'data.frame':  1050 obs. of  5 variables:
    ##   ..$ interest_by_city   : NULL
    ##   ..$ related_topics     : NULL
    ##   ..$ related_queries    :'data.frame':  3 obs. of  6 variables:
    ##   .. ..- attr(*, "reshapeLong")=List of 4
    ##   ..- attr(*, "class")= chr [1:2] "gtrends" "list"

## Wrangle the data

See the script for more details.

``` r
source("code/02-wrangle.R")
ls(pattern = "[A-Z]+")
```

    ##  [1] "GoogleData"                     "GSheetCand538Fav"              
    ##  [3] "GTrendDems2020Debate01IOT"      "GTrendDems2020Group1IOT"       
    ##  [5] "GTrendDems2020Group2IOT"        "GtrendDems2020IBR"             
    ##  [7] "GtrendDems2020IBRGroup1"        "GtrendDems2020IBRGroup2"       
    ##  [9] "GtrendDems2020InterestByRegion" "GTrendDems2020Night1G1"        
    ## [11] "GTrendDems2020Night1G2"         "GtrendWikiIOTAirTime"          
    ## [13] "statesMap"                      "TwitterData"                   
    ## [15] "TwitterUsersData"               "WikiData"                      
    ## [17] "WikiDemAirTime01"               "WikiDemAirTime01Raw"           
    ## [19] "WikiDemAirTime02"               "WikiDemAirTime02Raw"           
    ## [21] "WikiPollCriterion"              "WikiPollCriterionRaw"

# Exploratory Data Analysis

We will use tables and graphs to explore the data we imported and
wrangled and see if it looks like the `fivethirtyeight` data. We will
start with a table of the data on voter preferences on candidates before
and after the night of the election.

``` r
dplyr::filter(GSheetCand538Fav, candidate %in% c("Elizabeth Warren",
   "Tim Ryan", "Beto O’Rourke", "Amy Klobuchar", "Jay Inslee",
   "Tulsi Gabbard", "John Delaney", "Bill de Blasio", "Julian Castro",
   "Cory Booker")) %>% 
  DT::datatable(data = ., colnames = c("Democratic Candidate", 
    "Before the election", "After the first election",
    "After the second election"), 
    caption = 'source: https://53eig.ht/2Yg0Smp')
```

![](figs/GSheetCand538Fav-1.png)<!-- -->

This looks identical to the data in the figure on the
[article](https://projects.fivethirtyeight.com/democratic-debate-poll/).
We will compare this to the data from the wikipedia table.

``` r
knitr::kable(
WikiPollCriterion, align = 'c')
```

| candidates | poll\_perc | poll\_count |
| :--------: | :--------: | :---------: |
|   Warren   |   0.163    |     23      |
|  O’Rourke  |   0.103    |     23      |
|   Booker   |   0.040    |     23      |
| Klobuchar  |   0.037    |     23      |
|   Castro   |   0.020    |     16      |
|  Gabbard   |   0.013    |     11      |
|    Ryan    |   0.013    |      9      |
|   Inslee   |   0.010    |      9      |
| de Blasio  |   0.010    |      6      |
|  Delaney   |   0.010    |      5      |

We like to start with visualizing as much of the data as possible. These
two graphs tell us 1) “what kind of variables are in the data set?” and
2) “how much are missing?”

``` r
visdat::vis_dat(WikiPollCriterion) + 
  ggplot2::coord_flip()
```

![](figs/visdat-inspectdf-1.png)<!-- -->

## Google trend data

The next few visualizations are of the Google trend data.

### Candidates with high polling criterions

When we look at the candidates with the highest percent of polling
criterion on the 26th, we see the following:

``` r
GtrendWikiIOTAirTime %>% 
  dplyr::filter(poll_perc_fct == "> 10.0% of voters") %>% 
  ggplot2::ggplot(aes(x = date, 
             y = hits, 
             color = keyword)) +
  ggplot2::geom_line(aes(group = keyword), show.legend = FALSE) + 
  ggplot2::labs(
    x = "Date",
    y = "Google search hits",
  subtitle = "Google trends for candidates with > 10.0% polling") + 
  ggthemes::theme_wsj(base_size = 7.5, 
                      title_family = "mono") +
  ggplot2::facet_wrap(~ keyword, ncol = 2)
```

![](figs/top-3-candidates-1.png)<!-- -->

This shows Warren doing well after the first night. If we narrow this
down to the week of the debates and widen the list of candidates, we see
the following:

### Candidates with low polling criterions

``` r
GtrendWikiIOTAirTime7day <- GtrendWikiIOTAirTime %>% 
                                   dplyr::filter(date >= "2019-06-22" & 
                                                 date < "2019-06-30")
GtrendWikiIOTAirTime7day %>% 
  dplyr::filter(poll_perc_fct %in% c("> 10.0% of voters", 
                                     "2-4.0% of voters")) %>% 
  ggplot2::ggplot(aes(x = date, 
             y = hits, 
             color = keyword)) +
  ggplot2::geom_line(aes(group = keyword), show.legend = FALSE) + 
  ggplot2::labs(
    x = "Date",
    y = "Google search hits",
    title = "Google search hits",
    subtitle = "Democratic candidates with 1.0-4.0% of voters") + 
  ggthemes::theme_clean(base_size = 7.5) +
  ggplot2::facet_wrap(~ keyword, ncol = 2)
```

![](figs/7-day-top-3-1.png)<!-- -->

Now we can see Warren is definitely ahead of O’Rourke, but Booker has
also moved above Warren.

### Candidates with low polling criterions

For candidates in the lowest percentage of Polling Criterion, `1 - 1.3%
of voters` we see the following:

``` r
GtrendWikiIOTAirTime7day %>% 
  dplyr::filter(poll_perc_fct %in% c("> 10.0% of voters", 
                                     "2-4.0% of voters",
                                     "1 - 1.3% of voters")) %>% 
  ggplot2::ggplot(aes(x = date, 
             y = hits, 
             color = keyword)) +
  ggplot2::geom_line(aes(group = keyword), show.legend = FALSE) + 
  ggplot2::labs(
    x = "Date",
    y = "Google search hits",
    caption = paste0("Google search hits between ", 
                   min(GtrendWikiIOTAirTime7day$date),
                   " and ",
                   max(GtrendWikiIOTAirTime7day$date)),
    subtitle = "Google search hits for democratic candidates") + 
    ggthemes::theme_tufte(base_size = 7) +
    ggplot2::facet_wrap(~ keyword, ncol = 2)
```

![](figs/google-middle-percent-candidates-1.png)<!-- -->

This looks like Gabbard had a better night on Google than the other four
candidates in this group.

### Women candidates

We can also check the `gender` categorical variable to see how the
candidates break down across `Men` and `Women`

``` r
GtrendWikiIOTAirTime7day %>% 
  dplyr::filter(gender == "Women") %>% 
  ggplot2::ggplot(aes(x = date, 
             y = hits, 
             color = keyword)) +
  ggplot2::geom_line(aes(group = keyword), show.legend = FALSE) + 
  ggplot2::labs(subtitle = "Women Democratic Candidates",
    caption = paste0("Data between ", 
                   min(GtrendWikiIOTAirTime7day$date),
                   " and ",
                   max(GtrendWikiIOTAirTime7day$date))) + 
  ggthemes::theme_fivethirtyeight(base_size = 8) + 
  ggplot2::facet_wrap(. ~ keyword)
```

![](figs/Dems2020Debate01IOT-date-hits-women-1.png)<!-- -->

This shows Gubbard outperforming Warren in Google searches. And as for
the men…

### Men candidates

We’re going to use a different theme (`ggthemes::theme_tufte`) to look
at the

``` r
font <- "Helvetica"
GtrendWikiIOTAirTime7day %>% 
  dplyr::filter(gender == "Men") %>% 
  ggplot2::ggplot(aes(x = date, 
             y = hits, 
             color = keyword)) +
  ggplot2::geom_line(aes(group = keyword), 
            show.legend = FALSE) + 
  ggplot2::labs(
    x = "Date",
    y = "Google search hits",
    subtitle = "Google search trends for June 26, 2019 Democratic candidates",
    caption = "source: http://bit.ly/2SKZXt4") +
  ggthemes::theme_few() +
  ggplot2::facet_wrap(. ~ keyword, ncol = 3)
```

![](figs/GtrendWikiIOTAirTime7day-date-hits-men-1.png)<!-- -->

This shows Cory Booker doing the best, followed by John Delany.

## Twitter data

The twitter data for the first night of candidates are below. These data
were collected \~1 week after the debates and the figure below shows the
most common content for each metadata variable about the tweets.

``` r
TwitterDataPlotImb <- TwitterData %>% 
  inspectdf::inspect_imb() 
TwitterDataPlotImb %>% 
  inspectdf::show_plot(col_palette = 2)
```

![](figs/TwitterDataPlotImb-1.png)<!-- -->

``` r
TwitterData %>%
  ts_plot("3 hours") +
  ggplot2::theme_minimal() +
  ggplot2::theme(plot.title = 
                   ggplot2::element_text(face = "bold")) 
```

![](figs/ts_plot-1.png)<!-- -->

The twitter search string included all the candidates, so this will need
some additional cleaning/wrangling to figure out who is driving the
trends.

### Summarize Interest Data

What does the interest look like by location (i.e. `"region"`)?

We’ve created a new data structure `Dems2020InterestByRegion`. What does
it look like? We can use `skimr::skim_to_wide()` to answer this.

``` r
# recheck the structure
GtrendDems2020InterestByRegion %>%
  skimr::skim_to_wide() %>% 
  dplyr::filter(type %in% c("integer", "numeric")) %>% 
  dplyr::select(variable, 
                n, 
                mean, 
                sd, 
                median = p50, 
                hist)
```

    ## # A tibble: 5 x 6
    ##   variable n      mean      sd        median   hist    
    ##   <chr>    <chr>  <chr>     <chr>     <chr>    <chr>   
    ## 1 hits     155370 "  17.4 " "  19.5 " 11       ▇▂▁▁▁▁▁▁
    ## 2 order    155370 7798.15   4503.19   7794     ▇▇▇▇▇▇▇▇
    ## 3 group    155370 " 30.15"  18.13     " 26   " ▅▇▇▆▃▃▇▃
    ## 4 lat      155370 " 38.18"  " 5.79"   " 38.18" ▂▅▅▆▇▆▆▃
    ## 5 long     155370 -89.67    14.08     -87.61   ▂▂▁▃▇▇▇▃

### Map the data by state

It looks like the variable of interest (`hits`) is pretty lopsided–what
can we do about it? After googling, we discover [this
article](https://medium.com/@TheDataGyan/day-8-data-transformation-skewness-normalization-and-much-more-4c144d370e55)
with this information,

> “The logarithm, x to log base 10 of x, or x to log base e of x (ln x),
> or x to log base 2 of x, is a strong transformation and can be used to
> reduce right skewness.”

Now we’ve documented our thought process (the “why”), and can
log-transform the data in the next graph.

## Tulsi Gabbard 2020 searches

``` r
GtrendDems2020InterestByRegion %>% 
  dplyr::filter(keyword %in% "Tulsi Gabbard 2020") %>% 
  ggplot(aes(x = long, 
             y = lat)) +
  ggplot2::geom_polygon(aes(group = group,
                   # get the log(hits)
                   fill = log(hits)), 
                   color = "white") + 
  ggthemes::theme_map() + 
  ggplot2::labs(
    title = "Google searches for Tulsi Gabbard in 2020 on June 26, 2019",
    subtitle = "lighter colors = more searches for 'Tulsi Gabbard 2020'",
    caption = "using RStudio and gtrendsR") 
```

![](figs/visualize-Gabbard-locations-1.png)<!-- -->

## Cory Booker 2020 searches

These are the searches for Cory Booker on states.

``` r
GtrendDems2020InterestByRegion %>% 
  dplyr::filter(keyword == "Cory Booker 2020") %>% 
  ggplot(aes(x = long, 
             y = lat)) +
  ggplot2::geom_polygon(aes(group = group,
                   # get the log(hits)
                   fill = log(hits)), 
                   color = "white") + 
  ggthemes::theme_map() + 
  ggplot2::labs(
    title = "Google searches for Cory Booker in 2020 on June 26, 2019",
    subtitle = "lighter colors = more searches for 'Cory Booker 2020'",
    caption = "using RStudio and gtrendsR")
```

![](figs/visualize-Booker-locations-1.png)<!-- -->

## Sharing your work

Click `knit` to get the markdown file to share.

## Ask more questions

What other questions can we answer with these data?
