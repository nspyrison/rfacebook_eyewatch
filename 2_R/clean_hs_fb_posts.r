# Nicholas Spyrison. 30/11/2018
# Expects .csv output of the Hootsuite report Facebook_PostReactions_ns.

library(lubridate)
library(tsibble)
library(dplry)


## EXAMPLE:
#path <- "./1_raw_data/facebook_postreactions_ns_2017-11-18_to_2018-11-29_created_on_20181130T0509Z_facebook_posts.csv"
path <- "./1_raw_data/facebook_postreactions_ns_2017-11-18_to_2018-09-19_created_on_20180920T0920Z_facebook_posts.csv"
c_rdapath <- clean_hs_fb_posts(path)
  ## for all 55 stations.

clean_hs_fb_posts <- function(path) {
  ### ASSERT AND LOAD
  stopifnot(is.character(path))
  stopifnot(length(path) == 1)
  stopifnot(file.exists(path))
  
  filename = substr(path, 14, nchar(path) - 4) 
    #SPECIFIC TO './1_raw_data/' & '.csv'
  
  dat_in <- suppressMessages(tibble::as_tibble(readr::read_csv(path)))
  dat <- dat_in
  
  if (nrow(dat) == 10000) warning("Data contains exactly 10,000 rows, Data export may have been turncated by Hootsuite")
  
  ### STAGE AND CLEAN
  dat <- dplyr::rename(.data = dat, 
                       `Datetime`      = `Date (GMT)`,
                       `PagePostID`   = `Post ID`, # Old col name.
                       #`PagePostID`    = `Facebook Post ID`, # New col name.
                       `PostLink`      = `Post Permalink`,
                       `PostType`      = `Post Type`,
                       `PostMessage`   = `Post Message`,
                       `ReactionCount` = `Reactions`,
                       `CommentCount`  = `Comments`,
                       `ShareCount`    = `Shares`
  )
  
  dat <- dplyr::mutate(
    .data = dat,
    `Station`            = as.factor(
      gsub(" Police Service Area", "", gsub("Eyewatch - ", "" , gsub(
        "â€“", "-", `Facebook Page`)))# Trim page names to LGA name.
    ),
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
    `PostMessage`        = ifelse(`PostMessage` == "(Post with no description)", NA, `PostMessage`),
    `DateAquired`        = as.Date(substr(path, nchar(path) - 32, nchar(path) - 25), "%Y%m%d"),
    `IsCsnStation`       = ifelse (`Station` %in% c(
      "Wyndham", "Melton", "Whittlesea", "Cardinia", "Latrobe", "Ballarat", 
      "Brimbank", "Greater Shepparton", "Greater Dandenong", "Frankston", 
      "Knox", "Geelong"), "CSN", "not CSN")
    #`HasVicpolLink`      = (grepl("vicpol", `PostLink`) & `PostType` == "link"),
    #`HasHttpsVicpolLink` = (grepl("https", `PostLink`) & `HasVicpolLink` == T)
      # Only the ballarat sample data had direct vic pol links. 
      # Now only the Victoria Police Page has fb/victoriapolice links.
  )
  
  clean_dat <- dat[
    ,c("PagePostID", "Station",  "Datetime", "PostLink", "PostType",
       "PostMessage", "ReactionCount", "CommentCount", "ShareCount",
       "EngagementCount", "DateAquired", "IsCsnStation", 
       #"HasVicpolLink", "HasHttpsVicpolLink"
       "Date", "Time", "Hour", "Year", "Quarter", "Month", "Week", 
       "YearQuarter", "YearMonth", "YearWeek", "Weekday", "PostDaysOld")
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
  
  ### Order PostType by ~asc mean EngagementCount (hard coded prior)
  filt_dat$PostType = factor(
    filt_dat$PostType, levels = c("Event", "Video", "Link", "Status", "Photo"))
  output <- filt_dat
  
  ### RETURN
  filename <- paste0(filename, "_cleaned")
  csv_path <-paste0("./3_staged_data/", filename, ".csv")
  rda_path <- paste0("./3_staged_data/", filename, ".rda")
  
  assign(filename, output)
    # assign filt_dat to filename
  write.csv(filt_dat, file = csv_path, row.names = FALSE)
  save(list = filename, file = rda_path)
  
  ifelse(file.exists(csv_path) & file.exists(rda_path),
         message(paste0("Clean data has been saved to ./3_staged_data/ as .rda and .csv. The .rda filepath is also returned by this function.")),
         warning(paste0("File not saved to the expected filepath."))
  )
  
  return(rda_path)
}
