# Facebook Eyewatch data
# Nicholas Spyrison 
# May 2018

require(Rfacebook)
require(tidyverse)
require(plotly)
require(tibble)
require(lubridate)

source("./R/pull_fb_posts.r")
source("./R/add_fb_reactions.r") # Joins reactions and saves comments.
source("./R/clean_fb_postreactions.r")

# file.edit("./R/pull_fb_posts.r")
# file.edit("./R/add_fb_reactions.r") # Joins reactions and saves comments.
# file.edit("./R/clean_fb_postreactions.r")

args(pull_fb_posts)
args(add_fb_reactions)
args(clean_fb_postreactions)

###TODO:
# validate pull comments
# validate clean comments
# validate pull reactions
?args

### TEMP TOKEN
browseURL("https://developers.facebook.com/tools/explorer/?method=GET&path=me%3Ffields%3Did%2Cname&version=v3.0)")

### scratch run
token <- "EAAC5ZBNCmpAwBALYm8agR7iVmwYZCv29RaV4cZByGUYZBqNovE92ORZCNMKYSLFGMDLvbbXUoYmERCSbNH6xZAQ43Bwc7tZBcBGfo64q2rgPkwxMx3azXo3KC5WP2Vda7Hth3WEyVmY8qaVUMg6xHCM0tW2glAN5kZAzKDX6DkIUx0pJlKI4teBEUBKmiGCGAm0ZD"  # temporary
pages <- "eyewatchBallarat"

pull_fb_posts(pages, n_ppp=1500, token = token) -> myFilePath
add_fb_reactions(myFilePath, token = token) -> myFilePath
clean_fb_postreactions("data/postreactions_raw_2018_06_03.rda")

myFilePath <- "data/archive/bal_posts_raw_(copy).rda"
### get filename:
#paste0("data/postreactions_clean_", gsub("-", "_", Sys.Date()), ".rda")

### toy:
load("data/comments_raw_2018_06_03.rda")
load("data/postsreactions_clean_2018_06_03.rda")
postreactions_clean_2018_06_03 <- postsreactions_clean_2018_06_03
save(postreactions_clean_2018_06_03, file="data/postreactions_clean_2018_06_03.rda")

parse(eval(a))
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
?Rfacebook::getLikes #users likes for a page
?Rfacebook::getReactions #reaction breakdown of a post
?Rfacebook::getShares
?Rfacebook::getUsers

?Rfacebook::getInsights #requires page admin. contains page_fans_country.

# 12 focus stations: 
#stations <- c("Wyndham", "Melton", "Whittlesea", "Cardinia", "Latrobe", "Ballarat", "Brimbank", "Greater Shepparton", "Greater Dandenong", "Frankston", "Knox", "Geelong")
#pages <- cat("eyewatch", stations)

### Not in focus. HUME has some 21K followers, seems fishy
# not in email: "Monash", "Hume", "Kingston", "Latrobe", "Boroondara", "Yarra Ranges", "Bass Coast", "Warrnambool", "Casey", "Mildura", "Swan Hill", "Mornington Peninsula", "Darebin", "Moreland", "Bendigo", "Horsham", "Moorabool", "Baw Baw", "Hobsons Bay", "Benalla", "Northern Grampians"  __ anadditional 21 stations not mentioned. 33 in total

## EDA
load(file = "data/eyewatch_posts_clean.rda")
eyewatch_posts_clean
visdat::vis_dat(eyewatch_posts_clean)
sub <- eyewatch_posts_clean[c("created_date", "wday", "likes_count", "comments_count", "shares_count")]
GGally::ggpairs(data = sub)




