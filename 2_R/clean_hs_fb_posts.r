# Nicholas Spyrison. 30/11/2018
# Expects .csv output of the Hootsuite report Facebook_PostReactions_ns.

library(lubridate)
library(tsibble)
library(dplry)

## EXAMPLE:
path <- "./1_raw_data/facebook_postreactions_ns_2017-11-18_to_2018-11-29_created_on_20181130T0509Z_facebook_posts.csv"
clean_hs_fb_posts(path)
  ## for all 55 stations.

clean_hs_fb_posts <- function(path) {
  ### ASSERT AND LOAD
  stopifnot(is.character(path))
  stopifnot(file.exists(path))
  filename = substr(path, 14, nchar(path) - 4) 
    #SPECIFIC TO './1_raw_data/' & '.csv'
  
  dat_in <- tibble::as_tibble(readr::read_csv(path))
  dat <- dat_in
  
  if (nrow(dat) == 10000) warning("Data contains exactly 10,000 rows, make sure it contains the expected date range")
  
  ### STAGE AND CLEAN
  dat <- dplyr::rename(.data = dat, 
                       `Datetime`      = `Date (GMT)`,
                       `PagePostID`    = `Facebook Post ID`,
                       `PostLink`      = `Post Permalink`,
                       `PostType`      = `Post Type`,
                       `PostMessage`   = `Post Message`,
                       `ReactionCount` = `Reactions`,
                       `CommentCount`  = `Comments`,
                       `ShareCount`    = `Shares`
  )
  
  dat <- dplyr::mutate(
    .data = dat,
    `Station`            = as.factor(substr(`Facebook Page`, 12, 100)),
    `Date`               = as.Date(`Datetime`),
    `Time`               = substr(`Datetime`, 12, 23),
    `Hour`               = as.factor(substr(`Datetime`, 12, 13)),
    `Year`               = lubridate::year(`Datetime`),
    `Quarter`            = lubridate::quarter(`Datetime`, with_year = F),
    `Month`              = lubridate::month(`Datetime`, abbr = T),
    `Week`               = lubridate::week(`Datetime`),
    `YearQuarter`        = tsibble::yearquarter(`Datetime`),
    `YearMonth`          = tsibble::yearmonth(`Datetime`),
    `YearWeek`           = tsibble::yearweek(`Datetime`),
    `Weekday`            = lubridate::wday(`Datetime`, label = TRUE, week_start = 1),
    `PostDaysOld`        = as.integer(max(`Date`) - `Date`),
    `PostType`           = as.factor(`PostType`),
    `ReactionCount`      = as.integer(`ReactionCount`),
    `CommentCount`       = as.integer(`CommentCount`),
    `ShareCount`         = as.integer(`ShareCount`),
    `EngagementCount`    = `ReactionCount` + `CommentCount` + `ShareCount`,
    `PostMessage`        = 
      ifelse(`PostMessage` == "(Post with no description)", NA, `PostMessage`),
    `IsCsnStation`       = ifelse (`Station` %in% c(
      "Wyndham", "Melton", "Whittlesea", "Cardinia", "Latrobe", "Ballarat", 
      "Brimbank", "Greater Shepparton", "Greater Dandenong", "Frankston", 
      "Knox", "Geelong"), "CSN", "not CSN")
    #`HasVicpolLink`      = (grepl("vicpol", `PostLink`) & `PostType` == "link"),
    #`HasHttpsVicpolLink` = (grepl("https", `PostLink`) & `HasVicpolLink` == T)
  )
  
  clean_dat <- dat[
    ,c("PagePostID", "Station",  "Datetime", "PostLink", "PostType",
       "PostMessage", "ReactionCount", "CommentCount", "ShareCount",
       "EngagementCount", "IsCsnStation", "Date",
       #"HasVicpolLink", "HasHttpsVicpolLink"
       "Time", "Hour", "Year", "Quarter", "Month", "Week", "YearQuarter",
       "YearMonth", "YearWeek", "Weekday", "PostDaysOld")
    ]
  
  ### RETURN
  filename <- paste0(filename, "_cleaned")
  path <- paste0("./3_staged_data/", filename, ".rda")
  eval(parse(text = paste0(filename, " <- clean_dat")))
    # assign clean_dat to filename
  save(list = filename, file = file)
  
  ifelse(file.exists(path),
         message(paste0("Clean data has been saved to  ", file, 
                        ".  The filepath is also returned by this function.")),
         warning(paste0("File not saved to the expected filepath."))
  )
  
  return(file)
}
