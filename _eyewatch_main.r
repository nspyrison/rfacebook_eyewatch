# Facebook Eyewatch data
# Nicholas Spyrison 
# May 2018
library(tidyverse) 
library(plotly)
library(Rfacebook)

token <- "EAACEdEose0cBABDfswl3dCe1uUCrFgfve6gJ6cKtBMcfUxVzSkLuL01SaXE3FwIbZCZC7tv6ftD6pXLIzcaSeMW3FGzpVlL3orUlbw3vGeJ56cDMFrTgXxZBEQxbGvhle7X1R0KSkPKnD2x9zXYv0AYfCwcY3ctHu8IzaLrKLXSFjUKSZAKnXAg1hZAuMgjMZD" 
#temp token, will need to gen each time.
#https://developers.facebook.com/tools/explorer/?method=GET&path=me%3Ffields%3Did%2Cname&version=v3.0)

eyewatch_posts_raw <- NULL
start_time <- Sys.time()
for(i in 1:length(station)){
  delta <- getPage(station[i], token, n=200, feed = TRUE) %>% as_tibble() %>% cbind("station" = station[i])
  eyewatch_posts_raw <- rbind(eyewatch_posts_raw, delta)
} 
end_time <- Sys.time()
end_time - start_time #1.04 min, 952 x 11. ballarat, 5:30pm 16 May 2018

#save(eyewatch_posts_raw, file = "data/eyewatch_posts_raw.rda")


## ETL
#TODO: renames, id's, time, datetime
load(file = "data/eyewatch_posts_raw.rda")
eyewatch_posts_clean <- eyewatch_posts_raw
#eyewatch_posts_clean$from_id <- as.integer(eyewatch_posts_clean$from_id) #ALL NA after
#eyewatch_posts_clean <- rename(eyewatch_posts_clean, created_datetime = created_time)
#eyewatch_posts_clean <- rename(eyewatch_posts_clean, id = form_message_id)
eyewatch_posts_clean$created_datetime <- eyewatch_posts_clean$created_time
eyewatch_posts_clean$created_date <- substr(eyewatch_posts_clean$created_datetime, 1, 10)
eyewatch_posts_clean$created_time <- substr(eyewatch_posts_clean$created_datetime, 11, 24)
eyewatch_posts_clean$created_date <- as.Date(eyewatch_posts_clean$created_date, "%Y-%m-%d")
eyewatch_posts_clean$wday <- 
  lubridate::wday(eyewatch_posts_clean$created_date, label = TRUE)
eyewatch_posts_clean$day0 <- 
  as.integer(eyewatch_posts_clean$created_date-min(eyewatch_posts_clean$created_date))
eyewatch_posts_clean$likes_count <- as.integer(eyewatch_posts_clean$likes_count)
eyewatch_posts_clean$comments_count <- as.integer(eyewatch_posts_clean$comments_count)
eyewatch_posts_clean$shares_count <- as.integer(eyewatch_posts_clean$shares_count)
save(eyewatch_posts_clean, file = "data/eyewatch_posts_clean.rda")

## EDA
load(file = "data/eyewatch_posts_clean.rda")
eyewatch_posts_clean
visdat::vis_dat(eyewatch_posts_clean)
sub <- eyewatch_posts_clean[c("created_date", "wday", "likes_count", "comments_count", "shares_count")]
GGally::ggpairs(data = sub)






