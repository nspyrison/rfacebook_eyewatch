# Nicholas Spyrison. 18/10/2018
# Expecting the output of clean_hs_fb_posts().


sample_hs_fb_posts <- function(data       = NULL,
                               size       = 10,
                               stations   = c("ballarat"),
                               post_type  = c("link","photo","status","video"),
                               start_percentile = 0,   # pct or rate
                               end_percentile   = 100, # pct or rate
                               start_date = as.Date.character("2017-11-18"),
                               end_date   = Sys.Date()) {
  #LOAD CLEAN DATA
  #FILTER ON STATION, TYPE, DATE
  #MAKE PERCENTILE INTER AND INTRA STATION
  #DRAW n=size
  #return(tibble)
}

# Standardize by rough population
