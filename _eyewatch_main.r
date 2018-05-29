# Facebook Eyewatch data
# Nicholas Spyrison 
# May 2018
library(dplyr)
library(Rfacebook)
#library(tidyverse)
#library(plotly)
#library(tibble)

###https://mail.google.com/mail/u/1/#inbox/163a5bcef5819280
#JULY 6: have 1) done (for Ballarat) and presented to Rebecca by Friday July 6th.
#Loose order of work:
#1) Proof of concept: Posts, Post Replies, and Reactions
#2) Appending new data to current
#3) Going from 1 station to 12 (or 33)
#4) Shared Posts; Reactions and Replies
#5) Location data and maps (if possible/applicable)
#6) Text Analysis

?Rfacebook::fbOAuth
?Rfacebook::getCommentReplies
?Rfacebook::getLikes
?Rfacebook::getReactions
?Rfacebook::getShares
?Rfacebook::getUsers

?Rfacebook::getInsights #requires page admin. contains page_fans_country.

source(".\\R\\pull_fb_posts.r") # get Posts

token <- "EAACEdEose0cBAEM4hwfLCrIZBI1pHhtGOIaw1ejkgdhKzgG8bGVcqLNA75Jvl73AKNTQW6OVV3X56bp86GHM6A5uOkskXnZC4kmo1kfkYwavM22SvhtbgNaC81ZBsF65aSSgjDjbKCWX1sMHZAQu8JlmuLejkWz88ei5NmNC7FxXUgyivF4V0Iiacc0SCOUZD" 
#temp token, will need to gen each time.
#browseURL("https://developers.facebook.com/tools/explorer/?method=GET&path=me%3Ffields%3Did%2Cname&version=v3.0)")

### Focus on these 12.
#station <- cat("eyewatch",c("Wyndham", "Melton", "Whittlesea", "Cardinia", "Latrobe", "Ballarat", "Brimbank", "Greater Shepparton", "Greater Dandenong", "Frankston", "Knox", "Geelong"))

### Not in focus. HUME has some 21K followers, seems fishy
# not in email: "Monash", "Hume", "Kingston", "Latrobe", "Boroondara", "Yarra Ranges", "Bass Coast", "Warrnambool", "Casey", "Mildura", "Swan Hill", "Mornington Peninsula", "Darebin", "Moreland", "Bendigo", "Horsham", "Moorabool", "Baw Baw", "Hobsons Bay", "Benalla", "Northern Grampians"  __ anadditional 21 stations not mentioned. 33 in total

s <- "eyewatchMonash, eyewatchMelton"
pages <- s
file <- pull_fb_posts(s)

#file <- paste0("data/eyewatch_posts_raw_", Sys.Date(),".rda")
load("data/eyewatch_posts_raw_2018-05-25.rda")


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






