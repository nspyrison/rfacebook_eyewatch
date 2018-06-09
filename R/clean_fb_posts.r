#file= "data/postsreactions_raw_2018_06_03.rda"
clean_fb_posts <- function(file) {
  stopifnot(is.character(file))
  stopifnot(file.exists(file))
  stopifnot(grepl("postsreactions_raw", file)) # expects postsreactions_raw file.
  require(Rfacebook)
  
  ###  CLEAN
  #TODO: time (char to ts)
  load(file = file)
  filename = substr(file, 6, nchar(file) - 4) #SPECIFIC TO 'data/' % '.rda'
  
  pr_clean <- eval(parse(text = filename)) #pr for posts and reactions
  pr_clean <- as.data.frame(pr_clean)
  #pr_clean$from_id <- as.factor(pr_clean$from_id) #too large for int
  #pr_clean$from_idd <- as.factor(as.numeric(factor( #simple id.
  #  pr_clean$from_id, levels=unique(pr_clean$from_id)
  #  )))
  names(pr_clean)[names(pr_clean) == 'created_time'] <- 'created_datetime'
  pr_clean$created_date <- substr(pr_clean$created_datetime, 1, 10)
  pr_clean$created_time <- substr(pr_clean$created_datetime, 11, 24) #CHAR STRING
  pr_clean$created_hour <- as.factor(substr(pr_clean$created_time, 2, 3))
  pr_clean$created_date <- as.Date(pr_clean$created_date, "%Y-%m-%d")
  pr_clean$wday <- 
    lubridate::wday(pr_clean$created_date, label = TRUE)
  pr_clean$daysfrom0 <- 
    as.integer(pr_clean$created_date-min(pr_clean$created_date))
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
  
  
  ### DEV TS
  #load(file = file) ; pr_clean <- eval(parse(text = filename))
  #t=substr(pr_clean$created_time, 11, 24)
  #gsub("T", " ", t)
  #as.POSIXct(t, format = "%Y-%m-%d %H:%M")
  #as.POSIXct(dt, format = "%y%m%d %H:%M")
  #strftime(t, "%H:%M:%S")
  
  ### RETURN
  stopifnot(ncol(pr_clean) == 22)
  filename <- gsub("raw", "clean", filename)
  file <- paste0("data/", filename,".rda")
  eval(parse(text = paste0(filename, " <- pr_clean")))
  save(list = filename, file = file)
  
  print(paste0("Clean data has been saved to  ", file, ".  The filepath is 
               also returned by this function."))
  return(file)
}

