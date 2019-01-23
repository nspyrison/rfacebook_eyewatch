# Nicholas Spyrison. started 12/01/2019.

source("./2_R/clean_hs_fb_posts.r") #doesn't seem to load function...
source("./2_R/sample_hs_fb_posts.r")


clean_hs_fb_posts("./1_raw_data/facebook_post_performance_2017-11-18_to_2018-03-31_created_on_20190112T0507Z_facebook_post_performance.csv")
clean_hs_fb_posts("./1_raw_data/facebook_post_performance_2018-04-01_to_2018-06-30_created_on_20190112T0510Z_facebook_post_performance.csv")
clean_hs_fb_posts("./1_raw_data/facebook_post_performance_2018-07-01_to_2018-09-30_created_on_20190112T0513Z_facebook_post_performance.csv")
clean_hs_fb_posts("./1_raw_data/facebook_post_performance_2018-10-01_to_2018-12-31_created_on_20190112T0522Z_facebook_post_performance.csv")

load("./3_staged_data/facebook_post_performance_2017-11-18_to_2018-03-31_created_on_20190112T0507Z_facebook_post_performance_cleaned.rda")
load("./3_staged_data/facebook_post_performance_2018-04-01_to_2018-06-30_created_on_20190112T0510Z_facebook_post_performance_cleaned.rda")
load("./3_staged_data/facebook_post_performance_2018-07-01_to_2018-09-30_created_on_20190112T0513Z_facebook_post_performance_cleaned.rda")
load("./3_staged_data/facebook_post_performance_2018-10-01_to_2018-12-31_created_on_20190112T0522Z_facebook_post_performance_cleaned.rda")

bound_data <-
  rbind(`facebook_post_performance_2017-11-18_to_2018-03-31_created_on_20190112T0507Z_facebook_post_performance_cleaned`,
        `facebook_post_performance_2018-04-01_to_2018-06-30_created_on_20190112T0510Z_facebook_post_performance_cleaned`,
        `facebook_post_performance_2018-07-01_to_2018-09-30_created_on_20190112T0513Z_facebook_post_performance_cleaned`,
        `facebook_post_performance_2018-10-01_to_2018-12-31_created_on_20190112T0522Z_facebook_post_performance_cleaned`)
str(bound_data)

csv_filename <- paste0("./3_staged_data/bound_data_",Sys.Date(),".csv")
rda_filename <- paste0("./3_staged_data/bound_data_",Sys.Date(),".rda")
write.csv(bound_data, file = csv_filename, row.names = FALSE)
save(bound_data, file = rda_filename)

load("./3_staged_data/bound_data_2019-01-23.rda")
