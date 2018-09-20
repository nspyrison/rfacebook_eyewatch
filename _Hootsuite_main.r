# Hootsuite feasibility
# NS 16-09-2018

library(tidyverse)
library(lubridate)

#C:\Users\spyri\Documents\R\rfacebook_eyewatch\data\facebook_postreactions_ns_2018-07-01_to_2018-09-19_created_on_20180920T0140Z
?read_csv
dat <- read_csv("./data/facebook_post_performance_2018-09-06_to_2018-09-12_created_on_20180912T0550Z_facebook_post_performance.csv"
)

### Jul1-Sept19:
dat <- read_csv("./data/facebook_postreactions_ns_2018-07-01_to_2018-09-19_created_on_20180920T0140Z/facebook_postreactions_ns_2018-07-01_to_2018-09-19_created_on_20180920T0140Z_facebook_posts.csv"
)
View(dat)

dat <- as.tibble(dat)
summary(dat$`Date (GMT)`)

# Removed: Tags, Campaign, Organic.Impressions, Organic.Reach, Other.Actions,
## Photo.Views, Reactions..Other

# 12 csn stations for Aug 2018, longer than 13 min under Analytics. 16-09-2018.


### Reports:
# Stations:
## Ballarat, Brimbank, Cardinia, Frankston, Geelong, Greater Dandenong,
## Greater Shepparton, Knox, Latrobe, Melton, Whittlesea, Wyndham.

# New report set up and exporting, weekly, monthly, schedule set.
## Cannot set external users as schedule reciepiants.
  