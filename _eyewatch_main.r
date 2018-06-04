# Facebook Eyewatch data
# Nicholas Spyrison 
# May 2018

#library(Rfacebook)
#library(tidyverse)
#library(plotly)
#library(tibble)

source("./R/pull_fb_posts.r")
source("./R/clean_fb_posts.r")

### TEMP TOKEN
browseURL("https://developers.facebook.com/tools/explorer/?method=GET&path=me%3Ffields%3Did%2Cname&version=v3.0)")

token <- "EAACEdEose0cBAFwvxqDOvzkZCMSPf2YWD91mAyUURNiFSQUBY8MooC7oOBf6QRoDMFZCuAXuIEJaX10CWYm0em2mJ8FYL5jeb3PRaxDidO452HIZAw2dbAu4Xj6nUCyRwl90XEqcoMwmKYOx0q5whYqLq4m2fM4wRnEUzHQWeY3FbqUw3N8d0ZCDQZAaruDkhHKLst1wfHQZDZD" 

p <- "eyewatchBallarat"
myFileName <-
  pull_fb_posts(p, n_ppp=20, token = token)
myFileName <- "data/posts_raw_2018_06_03.rda"
clean_fb_posts(myFileName) #WILL OVERWRITE

pull_fb_reactions(myFileName, token = token)

load(myFileName)
## Getting reactions for most recent post
post <- getReactions(post=posts_raw$id[1], token=token)

###toy:
load("data/posts_raw_2018_06_03.rda")



### token defaulted in func load("fb_oauth")
#load("fb_oauth")
#(me <- getUsers("me",token=fb_oauth))

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



### TEMP TOKEN
##token <- "EAACEdEose0cBAEM4hwfLCrIZBI1pHhtGOIaw1ejkgdhKzgG8bGVcqLNA75Jvl73AKNTQW6OVV3X56bp86GHM6A5uOkskXnZC4kmo1kfkYwavM22SvhtbgNaC81ZBsF65aSSgjDjbKCWX1sMHZAQu8JlmuLejkWz88ei5NmNC7FxXUgyivF4V0Iiacc0SCOUZD" 
##temp token, will need to gen each time.

#browseURL("https://developers.facebook.com/tools/explorer/?method=GET&path=me%3Ffields%3Did%2Cname&version=v3.0)")

#load("fb_oauth")
#me <- getUsers("me",token=fb_oauth)
#my_likes <- getLikes(user="me", token=fb_oauth)





### Focus on these 12.
#station <- cat("eyewatch",c("Wyndham", "Melton", "Whittlesea", "Cardinia", "Latrobe", "Ballarat", "Brimbank", "Greater Shepparton", "Greater Dandenong", "Frankston", "Knox", "Geelong"))

### Not in focus. HUME has some 21K followers, seems fishy
# not in email: "Monash", "Hume", "Kingston", "Latrobe", "Boroondara", "Yarra Ranges", "Bass Coast", "Warrnambool", "Casey", "Mildura", "Swan Hill", "Mornington Peninsula", "Darebin", "Moreland", "Bendigo", "Horsham", "Moorabool", "Baw Baw", "Hobsons Bay", "Benalla", "Northern Grampians"  __ anadditional 21 stations not mentioned. 33 in total









## EDA
load(file = "data/eyewatch_posts_clean.rda")
eyewatch_posts_clean
visdat::vis_dat(eyewatch_posts_clean)
sub <- eyewatch_posts_clean[c("created_date", "wday", "likes_count", "comments_count", "shares_count")]
GGally::ggpairs(data = sub)






