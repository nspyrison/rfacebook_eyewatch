clean_fb_posts <- function(file) {
  stopifnot(is.character(file))
  stopifnot(file.exists(file))
  require(Rfacebook)
  
  ###  CLEAN
  #TODO: time (char to ts)
  load(file = file)
  filename = substr(file, 6, nchar(file) - 4) #SPECIFIC TO 'data/' % '.rda'
  
  posts_clean <- eval(parse(text = filename))
  posts_clean <- as.data.frame(posts_clean)
  posts_clean$from_id <- as.factor(posts_clean$from_id) #too large for int
  posts_clean$from_idd <- as.factor(as.numeric(factor( #simple id.
    posts_clean$from_id, levels=unique(posts_clean$from_id)
    )))
  names(posts_clean)[names(posts_clean) == 'created_time'] <- 'created_datetime'
  posts_clean$created_date <- substr(posts_clean$created_datetime, 1, 10)
  posts_clean$created_time <- substr(posts_clean$created_datetime, 11, 24) #CHAR STRING
  posts_clean$created_hour <- as.factor(substr(posts_clean$created_time, 2, 3))
  posts_clean$created_date <- as.Date(posts_clean$created_date, "%Y-%m-%d")
  posts_clean$wday <- 
    lubridate::wday(posts_clean$created_date, label = TRUE)
  posts_clean$daysfrom0 <- 
    as.integer(posts_clean$created_date-min(posts_clean$created_date))
  posts_clean$likes_count <- as.integer(posts_clean$likes_count)
  posts_clean$comments_count <- as.integer(posts_clean$comments_count)
  posts_clean$shares_count <- as.integer(posts_clean$shares_count)
  
  ### DEV TS
  #load(file = file) ; posts_clean <- get(filename)
  #t=substr(posts_clean$created_time, 11, 24)
  #gsub("T", " ", t)
  #as.POSIXct(t, format = "%Y-%m-%d %H:%M")
  #as.POSIXct(dt, format = "%y%m%d %H:%M")
  #strftime(t, "%H:%M:%S")
  
  ### RETURN
  filename <- gsub("raw", "clean", filename)
  file <- paste0("data/", filename,".rda")
  eval(parse(text = paste0(filename, " <- posts_clean")))
  save(list = filename, file = file)
  
  print(paste0("Clean data has been saved to  ", file, ".  The filepath is also returned by this function."))
  stopifnot(ncol(posts_clean) == 18)
  return(file)
}

