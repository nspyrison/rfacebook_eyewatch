# Nicholas Spyrison. 30/11/2018
# Expects .csv output of the Hootsuite report Facebook_PostReactions_ns.

library(lubridate)
library(tsibble)
library(dplyr)

## EXAMPLE:
# f1 <- "./1_raw_data/facebook_post_performance_2017-11-18_to_2018-03-31_created_on_20190112T0507Z_facebook_post_performance.csv"
# outpath <- clean_hs_fb_posts(f1)

clean_hs_fb_posts <- function(path) {
  ### ASSERT AND LOAD
  stopifnot(is.character(path))
  stopifnot(length(path) == 1)
  stopifnot(file.exists(path))
  
  filename = substr(path, 14, nchar(path) - 4) 
    #SPECIFIC TO './1_raw_data/' & '.csv'
  
  dat_in <- suppressWarnings(tibble::as_tibble(readr::read_csv(path)))
  dat <- dat_in
  if (nrow(dat) == 10000) warning("Data contains exactly 10,000 rows, Data export may have been turncated by Hootsuite")
  
  ### STAGE AND CLEAN
  dat <- dplyr::rename(.data = dat, 
                       `Datetime`      = `Date (GMT)`,
                       `PagePostID`    = `Post ID`, 
                       `PostLink`      = `Post Permalink`
  )
  
  dat <- dplyr::mutate(
    .data = dat,
    `Station` = as.factor(gsub(" Police Service Area", "", # Trim page names to LGA name.
                               gsub("Eyewatch - ", "" , 
                                    gsub("â€“", "-", `Facebook Page`)
                               ))),
    `Date`              = as.Date(`Datetime`),
    `Time`              = substr(`Datetime`, 12, 23),
    `Hour`              = as.factor(substr(`Datetime`, 12, 13)),
    `Year`              = lubridate::year(`Datetime`),
    `Quarter`           = lubridate::quarter(`Datetime`, with_year = F),
    `Month`             = lubridate::month(`Datetime`, abbr = T),
    `Week`              = lubridate::week(`Datetime`),
    `YearQuarter`       = tsibble::yearquarter(`Datetime`),
    `YearMonth`         = tsibble::yearmonth(`Datetime`),
    `YearWeek`          = tsibble::yearweek(`Datetime`),
    `Weekday`           = lubridate::wday(`Datetime`, label = TRUE, week_start = 1),
    `DaysOld`           = as.integer(max(`Date`) - `Date`),
    `PostType`          = as.factor(`Post Type`),
    `Clicks`            = as.integer(`Clicks`),
    `EngagedFans`       = as.integer(`Engaged Fans`),
    `EngagedUsers`      = as.integer(`Engaged Users`),
    `EngagementRate`    = as.integer(`Engagement Rate`),
    `Impressions`       = as.integer(`Impressions`),
    `LinkClicks`        = as.integer(`Link Clicks`),
    `Reach`             = as.integer(`Reach`),
    `Reactions`          = as.integer(`Reactions`),
    `Reactions_Anger`   = as.integer(`Reactions: Anger`),
    `Reactions_Haha`    = as.integer(`Reactions: Haha`),
    `Reactions_Like`    = as.integer(`Reactions: Like`),
    `Reactions_Love`    = as.integer(`Reactions: Love`),
    `Reactions_Sorry`   = as.integer(`Reactions: Sorry`),
    `Reactions_Wow`     = as.integer(`Reactions: Wow`),
    `VideoPlays`        = as.integer(`Video Plays`),
    `VideoReach`        = as.integer(`Video Reach`),
    `VideoViews`        = as.integer(`Video Views`),
    `VideoViews(auto-play)` = as.integer(`Video Views (auto-play)`),
    `VideoViews(click-to-play)` = as.integer(`Video Views (click-to-play)`),
    `VideoViews(sound-on)` = as.integer(`Video Views (sound-on)`),
    `VideoWatchDuration` = as.integer(`Video Watch Duration`),
    `ViralImpressions`  = as.integer(`Viral Impressions`),
    `ViralReach`        = as.integer(`Viral Reach`),
    `Comments`          = as.integer(`Comments`),
    `Shares`            = as.integer(`Shares`),
    `Engagements`       = `Reactions` + `Comments` + `Shares`,
    `PostMessage`       = ifelse(`Post Message` == "(Post with no description)", NA, `Post Message`),
    `DateAquired`       = as.Date(substr(path, nchar(path) - 32, nchar(path) - 25), "%Y%m%d"),
    `IsCsnStation`      = ifelse(`Station` %in% c(
      "Wyndham", "Melton", "Whittlesea", "Cardinia", "Latrobe", "Ballarat", 
      "Brimbank", "Greater Shepparton", "Greater Dandenong", "Frankston", 
      "Knox", "Geelong"), "CSN", "not CSN")
  )
  levels(dat$PostType) <- c("Event", "Video", "Link", "Status", "Photo")
  
  clean_dat <- dat[
    ,c("PagePostID", "Station",  "Datetime", "PostLink", "PostType",
       "PostMessage", "Engagements", "Comments", "Shares", "Reactions",
       "Reactions_Anger", "Reactions_Haha", "Reactions_Like", "Reactions_Love",
       "Reactions_Sorry", "Reactions_Wow",
       "VideoPlays", "VideoReach", "VideoViews", "VideoViews(auto-play)",
       "VideoViews(click-to-play)", "VideoViews(sound-on)", 
       "VideoWatchDuration", "ViralImpressions", "ViralReach",
       "DateAquired", "IsCsnStation", 
       "Date", "Time", "Hour", "Year", "Quarter", "Month", "Week", 
       "YearQuarter", "YearMonth", "YearWeek", "Weekday", "DaysOld")
    ]
  
  ### FILTER
  filt_dat <- clean_dat
  filt_dat <- dplyr::filter(filt_dat, PostType != "music")
  
  ### IF MORE THAN 3 DAYS ARE MISSING FROM THE START OR END MONTH,
  ###   ASSUME THE MONTH IS INCOMPLETE AND DROP IT.
  startDate <- min(filt_dat$`Date`)
  endDate   <- max(filt_dat$`Date`)
  startDay  <- as.integer(substr(startDate,9,10))
  endDay    <- as.integer(substr(endDate,9,10))
  startDaysAfterFirst <- startDay - 1
  endDaysBeforeLast <- as.integer(lubridate::days_in_month(endDate) - endDay)
  if (startDaysAfterFirst > 3) {
    daysTillEoM <- as.integer(lubridate::days_in_month(startDate) - startDay)
    dateFloor <- lubridate::as_date(startDate + daysTillEoM)
    filt_dat <- dplyr::filter(filt_dat, `Date` > dateFloor)
  }
  if (endDaysBeforeLast > 3) {
    dateCeiling <- lubridate::as_date(endDate - endDay + 1)
    filt_dat <- dplyr::filter(filt_dat, `Date` < dateCeiling)
  }
  
  ### RETURN
  filename <- paste0(filename, "_cleaned")
  csv_path <-paste0("./3_staged_data/", filename, ".csv")
  rda_path <- paste0("./3_staged_data/", filename, ".rda")
  
  output <- filt_dat
  assign(filename, output)
  write.csv(filt_dat, file = csv_path, row.names = FALSE)
  save(list = filename, file = rda_path)
  
  ifelse(file.exists(csv_path) & file.exists(rda_path),
         message("Clean data has been saved to ./3_staged_data/ as .rda and .csv. The .rda filepath is also returned by this function."),
         warning("File not saved to the expected filepath.")
  )
  
  return(rda_path)
}
