# Nicholas Spyrison. started 12/01/2019.

source("./2_R/clean_hs_fb_posts.r") #doesn't seem to load function...
source("./2_R/sample_hs_fb_posts.r")

f1 <- "./1_raw_data/facebook_post_performance_2017-11-18_to_2018-03-31_created_on_20190112T0507Z_facebook_post_performance.csv"
f2 <- "./1_raw_data/facebook_post_performance_2018-04-01_to_2018-06-30_created_on_20190112T0510Z_facebook_post_performance.csv"
f3 <- "./1_raw_data/facebook_post_performance_2018-07-01_to_2018-09-30_created_on_20190112T0513Z_facebook_post_performance.csv"
f4 <- "./1_raw_data/facebook_post_performance_2018-10-01_to_2018-12-31_created_on_20190112T0522Z_facebook_post_performance.csv"

clean_hs_fb_posts(f1)
clean_hs_fb_posts(f2)
clean_hs_fb_posts(f3)
clean_hs_fb_posts(f4)
