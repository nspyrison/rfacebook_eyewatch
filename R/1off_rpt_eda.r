readr::read_csv("./data/facebookengagement_1off_ns_2018-01-01_to_2018-10-17_created_on_20181018T0503Z/facebookengagement_1off_ns_2018-01-01_to_2018-10-17_created_on_20181018T0503Z_account_metrics.csv"
) %>% as_tibble() -> dat_in_account_metrics

readr::read_csv("./data/facebookengagement_1off_ns_2018-01-01_to_2018-10-17_created_on_20181018T0503Z/facebookengagement_1off_ns_2018-01-01_to_2018-10-17_created_on_20181018T0503Z_facebook_inbound_messages.csv"
) %>% as_tibble() -> dat_in_facebook_inbound_messages

readr::read_csv("./data/facebookengagement_1off_ns_2018-01-01_to_2018-10-17_created_on_20181018T0503Z/facebookengagement_1off_ns_2018-01-01_to_2018-10-17_created_on_20181018T0503Z_facebook_posts.csv"
) %>% as_tibble() -> dat_in_facebook_posts

AcntMet <- dat_in_account_metrics
InMesg  <- dat_in_facebook_inbound_messages
fbPost  <- dat_in_facebook_posts


head(sort(table(tab$`Message Author`)), 10)
tab <- as_tibble(table(InMesg$`Message Author`))
str(tab)

head(tab[order(-tab$n),],100)

mtcars[order(mpg, -cyl),] 


hist(tab$n)
