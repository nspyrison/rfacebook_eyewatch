# Nicholas Spyrison. 18/10/2018
# Expects .csv output of the Hootsuite report Facebook_PostReactions_ns.

#file= "data/postreactions_raw_2018_06_03.rda"
clean_hs_fb_posts <- function(file) {
  stopifnot(is.character(file))
  stopifnot(file.exists(file))
  #stopifnot(grepl("some file name fragment", file)) 
    # expects "postreactions_raw" in filename.
  
  library(lubridate)
  
  ###CLEAN
  load(file = file)
  filename = substr(file, 6, nchar(file) - 4) #SPECIFIC TO 'data/' % '.rda'
  
  pr_clean <- eval(parse(text = filename)) #pr for posts and reactions
  pr_clean <- as.data.frame(pr_clean)
  #pr_clean$from_id <- as.factor(pr_clean$from_id) #too large for int
  #pr_clean$from_idd <- as.factor(as.numeric(factor( #simple id.
  #  pr_clean$from_id, levels=unique(pr_clean$from_id)
  #  )))
  names(pr_clean["created_time"]) <- 'created_datetime'
  pr_clean$created_datetime <- ymd_hms(pr_clean$created_time)
  pr_clean$created_date <- as.Date(pr_clean$created_datetime)
  pr_clean$created_time <- substr(pr_clean$created_datetime, 12, 23)
  pr_clean$created_hour <- as.factor(substr(pr_clean$created_datetime, 12, 13))
  pr_clean$created_year <- year(pr_clean$created_date)
  pr_clean$created_quarter <- quarter(pr_clean$created_date, with_year = F)
  pr_clean$created_month <- month(pr_clean$created_date, abbr = T)
  pr_clean$created_week <- week(pr_clean$created_date)
  pr_clean$created_yearQuarter <- 
    paste0(as.integer(pr_clean$created_year), " Q", pr_clean$created_quarter)
  pr_clean$created_yearMonth <- 
    paste0(pr_clean$created_year, " ", pr_clean$created_month)
  pr_clean$created_yearMonth <- zoo::as.yearmon(tmp$created_yearMonth, "%Y %b")
  pr_clean$created_yearWeek <- 
    paste0(pr_clean$created_year, " wk", pr_clean$created_week)
  pr_clean$created_weekday <- 
    wday(pr_clean$created_date, label = TRUE, week_start = 1)
  firstday <- min(pr_clean$created_date)
  pr_clean$post_daysfrom0 <- 
    as.integer(pr_clean$created_date - firstday)
  lastday <- max(pr_clean$created_date)
  pr_clean$post_age <- 
    as.integer(lastday - pr_clean$created_date)
  pr_clean$post_age <- 
    as.integer(pr_clean$created_date - firstday)
  pr_clean$type <- as.factor(pr_clean$type)
  pr_clean$type <- as.factor(pr_clean$type)
  pr_clean$likes_count.x <- 
    as.integer(max(pr_clean$likes_count.x,pr_clean$likes_count.y))
  names(pr_clean)[names(pr_clean) == 'likes_count.x'] <- 'likes_count'
  pr_clean <- pr_clean[names(pr_clean) != 'likes_count.y']
  pr_clean$comments_count <- as.integer(pr_clean$comments_count)
  pr_clean$shares_count <- as.integer(pr_clean$shares_count)
  pr_clean$love_count <- as.integer(pr_clean$love_count)
  pr_clean$haha_count <- as.integer(pr_clean$haha_count)
  pr_clean$wow_count <- as.integer(pr_clean$wow_count)
  pr_clean$sad_count <- as.integer(pr_clean$sad_count)
  pr_clean$angry_count <- as.integer(pr_clean$angry_count)
  pr_clean$reactions_count <- as.integer(pr_clean$likes_count + 
                                           pr_clean$love_count + pr_clean$haha_count + pr_clean$wow_count + 
                                           pr_clean$sad_count + pr_clean$angry_count
  )
  pr_clean$link_has_vicpol <- 
    (grepl("vicpol", pr_clean$link) & pr_clean$type == "link")
  station <- strsplit(pr_clean$from_name,' ')[[1]][3]
  pr_clean$link_has_station <- 
    (grepl(station, pr_clean$link) & pr_clean$type == "link")
  
  ### RETURN
  stopifnot(ncol(pr_clean) == 29)
  filename <- gsub("raw", "clean", filename)
  file <- paste0("data/", filename,".rda")
  eval(parse(text = paste0(filename, " <- pr_clean") ) )
  save(list = filename, file = file)
  
  print(paste0("Clean data has been saved to  ", file, 
               ".  The filepath is also returned by this function."
  )
  )
  return(file)
}