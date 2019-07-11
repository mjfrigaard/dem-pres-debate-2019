2019 Democratic Debates data project
================
Jane Doe

# Motivation

We’ve want see how popular each democratic candidate did after the first
round of [2019 Democratic Presidential
Debates](https://en.wikipedia.org/wiki/2020_Democratic_Party_presidential_debates_and_forums),
but we missed all the coverage.

We happened to read an article from the data journalism website
[`fivethirtyeight`](https://projects.fivethirtyeight.com/democratic-debate-poll/),
and it displayed an image showing how voters had changed their minds
after seeing the candidates.

![](figs/03-538-night-one-debates.png)<!-- -->

This document outlines the data import, wrangling, and visulizations
used in this project.

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

These data come from two sources, Wikipedia and Google trends. We will
start be collecting the data from Wikipedia on the debate.

``` r
source("code/01-import.R")
```

## The democratic candidates

There were ten candidates in the first night of debates, and all are
listed alphabetically below.

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

    ## Amy Klobuchar
    ## Beto O’Rourke
    ## Bill de Blasio
    ## Cory Booker
    ## Elizabeth Warren
    ## Jay Inslee
    ## John Delaney
    ## Julián Castro
    ## Tim Ryan
    ## Tulsi Gabbard

### The Wikipedia table

[Wikipedia page on 2020 democratic debates (first
night)](https://en.wikipedia.org/wiki/2020_Democratic_Party_presidential_debates_and_forums#Summary).

The data, `WikiDemAirTime01Raw` are in the work session below.

``` r
WikiDemAirTime01Raw %>% head(10)
```

    ## # A tibble: 10 x 2
    ##    X1                X2                
    ##    <chr>             <chr>             
    ##  1 Night one airtime Night one airtime 
    ##  2 Candidate         Airtime (min.)[57]
    ##  3 Booker            10.9              
    ##  4 O'Rourke          10.3              
    ##  5 Warren            9.3               
    ##  6 Castro            8.8               
    ##  7 Klobuchar         8.5               
    ##  8 Ryan              7.7               
    ##  9 Gabbard           6.6               
    ## 10 Delaney           6.6

``` r
WikiDemAirTime02Raw %>% head(10)
```

    ## # A tibble: 10 x 2
    ##    X1                X2                
    ##    <chr>             <chr>             
    ##  1 Night two airtime Night two airtime 
    ##  2 Candidate         Airtime (min.)[57]
    ##  3 Biden             13.6              
    ##  4 Harris            11.9              
    ##  5 Sanders           11.0              
    ##  6 Buttigieg         10.5              
    ##  7 Bennet            8.1               
    ##  8 Gillibrand        7.5               
    ##  9 Hickenlooper      5.2               
    ## 10 Williamson        5.0

### Google trends data

We are interested in collecting data from June 25, 2019 until June 27,
2019 to get a gauge of how well (or how bad) each candidate did in terms
of gaining interest (as measured by Google search trends). The Google
search trends are accessible via the
[gtrendsR](https://github.com/PMassicotte/gtrendsR) package. This and
other packages are in the `00-packages.R` script.

### Google search terms

Each candidates name was searched for with “2020”. We thought it would
be a good idea to add “2020” to the candidates name to make it easier to
identify searches that corresponded to the interested with the upcoming
election.

## Twitter data

The twitter data for the first night of candidates are below. These data
were collected \~1 week after the debates.

``` r
TwitterData %>%
  ts_plot("3 hours") +
  ggplot2::theme_minimal() +
  ggplot2::theme(plot.title = ggplot2::element_text(face = "bold")) 
```

![](figs/ts_plot-1.png)<!-- -->

## Wrangle data

See the script for more details.

``` r
source("code/02-wrangle.R")
```

## Exploratory Data Analysis

Start with visualizing as much of the data as possible. These two graphs
tell us 1) “what kind of variables are in the data set?” and 2) “how
much are missing?”

``` r
library(visdat)
library(inspectdf)
inspectdf::inspect_types(Dems2020Debate01IOTAirTime) %>% 
  inspectdf::show_plot()
```

![](figs/visdat-inspectdf-1.png)<!-- -->

``` r
visdat::vis_miss(Dems2020Debate01IOTAirTime) + 
  ggplot2::coord_flip()
```

![](figs/visdat-inspectdf-2.png)<!-- -->

### Candidates with high % going into debates

[fivethirtyeight](https://projects.fivethirtyeight.com/democratic-debate-poll/)
did a pre-debate survey with MorningConsult and asked who voters were
most likely to vote for before each debate, then asked them who they
would vote for *after the debate*, this .

> *To track which candidates are winning over voters, we asked
> respondents who they would vote for before and after each debate. That
> lets us measure not only who gained (or lost) support, but also where
> that support came from (or went to).*

When we look at the candidates with the highest percent of likely voters
on the 26th, we see the following:

``` r
Dems2020Debate01IOTAirTime %>% 
  dplyr::filter(prior_vperc_fct == "> 1.0% of voters") %>% 
  ggplot(aes(x = date, 
             y = hits, 
             color = keyword)) +
  geom_line(aes(group = keyword), show.legend = FALSE) + 
  ggplot2::labs(
    x = "Date",
    y = "Google search hits",
    caption = paste0("Google search hits between ", 
                   min(Dems2020Debate01IOTAirTime$date),
                   " and ",
                   max(Dems2020Debate01IOTAirTime$date)),
    subtitle = "Google search hits for Candidates with > 1.0% of voters") + 
  ggthemes::theme_fivethirtyeight(base_size = 9) +
  facet_wrap(~ keyword, ncol = 2)
```

![](figs/top-3-candidates-1.png)<!-- -->

This shows Booker doing well, Warren getting some searches later in the
evening, etc. But we should narrow this down to the 7 day we’re
interested in (23rd - 29th) and store it in `Dems2020IOTAirTime7day`.

``` r
Dems2020IOTAirTime7day <- Dems2020Debate01IOTAirTime %>% 
                                   dplyr::filter(date >= "2019-06-22" & 
                                                 date < "2019-06-30")
```

If we narrow this down to the week of the debates, we see the following:

``` r
Dems2020IOTAirTime7day %>% 
  dplyr::filter(prior_vperc_fct == "> 1.0% of voters") %>% 
  ggplot(aes(x = date, 
             y = hits, 
             color = keyword)) +
  geom_line(aes(group = keyword), show.legend = FALSE) + 
  ggplot2::labs(
    x = "Date",
    y = "Google search hits",
    subtitle = "Google search hits for Candidates with > 1.0% of voters") + 
  ggthemes::theme_fivethirtyeight(base_size = 8) +
  facet_wrap(~ keyword, ncol = 2)
```

![](figs/7-day-top-3-1.png)<!-- -->

Now we can see Booker is definitely ahead of Warren in terms of hits
over time.

``` r
Dems2020IOTAirTime7day %>% 
  dplyr::filter(prior_vperc_fct == "0.5 - 0.9% of voters") %>% 
  ggplot(aes(x = date, 
             y = hits, 
             color = keyword)) +
  geom_line(aes(group = keyword), show.legend = FALSE) + 
  ggplot2::labs(
    x = "Date",
    y = "Google search hits",
    caption = paste0("Google search hits between ", 
                   min(Dems2020Debate01IOT$date),
                   " and ",
                   max(Dems2020Debate01IOT$date)),
    subtitle = "Google Search Hits for Candidates with between 0.5 - 0.9% of voters") + 
  ggthemes::theme_fivethirtyeight(base_size = 9) +
  facet_wrap(~ keyword, ncol = 2)
```

![](figs/google-middle-percent-candidates-1.png)<!-- -->

``` r
Dems2020IOTAirTime7day %>% 
  dplyr::filter(prior_vperc_fct == "0.2 - 0.4% of voters") %>% 
  ggplot(aes(x = date, 
             y = hits, 
             color = keyword)) +
  geom_line(aes(group = keyword), show.legend = FALSE) + 
  ggplot2::labs(
    x = "Date",
    y = "Google search hits",
    subtitle = "Google search hits for candidates with between 0.2 - 0.4% of voters",
    caption = paste0("0.2 - 0.4% of voters",
                     min(Dems2020Debate01IOT$date),
                   " and ",
                   max(Dems2020Debate01IOT$date))) + 
  ggthemes::theme_fivethirtyeight(base_size = 7.5) +
  facet_wrap(~ keyword, ncol = 3)
```

![](figs/google-low-candidates-1.png)<!-- -->

This looks like Gabbard had a better night than the other three
candidates in her group.

### Candidates who had to gain ground in the debates

This is the middle group of candidates who would need to grab one of the
top-ranking spots.

``` r
Dems2020IOTAirTime7day %>%  
  dplyr::filter(prior_vperc_fct == "0.2% of voters") %>% 
  ggplot(aes(x = date, 
             y = hits, 
             color = keyword)) +
  geom_line(aes(group = keyword), show.legend = FALSE) + 
  ggplot2::labs(
    x = "Date",
    y = "Google search hits",
    subtitle = paste0("Google search hits between ", 
                   min(Dems2020Debate01IOT$date),
                   " and ",
                   max(Dems2020Debate01IOT$date)),
    caption = "using RStudio and gtrendsR") + 
  ggthemes::theme_fivethirtyeight() +
  facet_wrap(~ keyword, ncol = 3)
```

![](figs/google-bottom-percent-candidate-1.png)<!-- -->

For coming in with the lowest polling percentage (based on voting that
day), John Delaney ended up with a moderate boost in Google searches.

### Women candidates

We can also check the `gender` categorical variable to see how the
candidates break down across `Men` and `Women`

``` r
Dems2020IOTAirTime7day %>% 
  dplyr::filter(gender == "Women") %>% 
  ggplot(aes(x = date, 
             y = hits, 
             color = keyword)) +
  geom_line(aes(group = keyword)) + 
  ggplot2::labs(
    x = "Date",
    y = "Google search hits",
    subtitle = paste0("Google search trends between ", 
                   min(Dems2020Debate01IOT$date),
                   " and ",
                   max(Dems2020Debate01IOT$date)),
    caption = "using RStudio and gtrendsR") + 
  ggthemes::theme_fivethirtyeight(base_size = 8) + 
  facet_wrap(. ~ keyword)
```

![](figs/Dems2020Debate01IOT-date-hits-women-1.png)<!-- -->

This shows Gubbard outperforming Warren in Google searches. And the
`Men`…

``` r
Dems2020IOTAirTime7day %>% 
  dplyr::filter(gender == "Men") %>% 
  ggplot(aes(x = date, 
             y = hits, 
             color = keyword)) +
  geom_line(aes(group = keyword)) + 
  ggplot2::labs(
    x = "Date",
    y = "Google search hits",
    subtitle = paste0("Google search trends between ", 
                   min(Dems2020Debate01IOT$date),
                   " and ",
                   max(Dems2020Debate01IOT$date)),
    caption = "using RStudio and gtrendsR") + 
  ggthemes::theme_fivethirtyeight(base_size = 7.5) + 
  facet_wrap(. ~ keyword, ncol = 3)
```

![](figs/Dems2020Debate01IOT-date-hits-men-1.png)<!-- -->

Shows Cory Booker doing the best, followed by John Delany.

### Map the data by state

What does the interest look like by location (i.e. `"region"`)?

We’ve created a new data structure `Dems2020InterestByRegion`. What does
it look like?

``` r
# recheck the structure
Dems2020InterestByRegion %>%
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
Dems2020InterestByRegion %>% 
  dplyr::filter(keyword %in% "Tulsi Gabbard 2020") %>% 
  ggplot(aes(x = long, 
             y = lat)) +
  geom_polygon(aes(group = group,
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
Dems2020InterestByRegion %>% 
  dplyr::filter(keyword == "Cory Booker 2020") %>% 
  ggplot(aes(x = long, 
             y = lat)) +
  geom_polygon(aes(group = group,
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
