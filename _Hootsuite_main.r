# Nicholas Spyrison 20-09-2018.
# load and triage Hootsuite output.

### 12 CSN stations:
## Ballarat, Brimbank, Cardinia, Frankston, Geelong, Greater Dandenong,
## Greater Shepparton, Knox, Latrobe, Melton, Whittlesea, Wyndham.

## New report: "Facebook_PostReactions_ns" 
## Can schedule exporting weekly and monthly, but on only to hootsuite emaills. 
## Data in hootsuite back to 18 Nov 2017.
## Nick has access to all 55 stations.

library(readr)

# posts between: 18-11-2017 to 19-09-2018 for the 12 CSN stations
## Hootsuite doesn't have data before 18 Nov 2017. Also have all 55 station data
readr::read_csv("./data/facebook_postreactions_ns_2017-11-18_to_2018-09-19_created_on_20180920T0920Z_facebook_posts.csv"
) %>% as_tibble() -> dat

#View(dat)
str(dat)