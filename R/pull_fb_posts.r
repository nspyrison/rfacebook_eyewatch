pull_fb_posts <- function(pages) {
  pages <- gsub(" ", "", pages, fixed = TRUE) %>% tolower()
  n_pages <- length(unique(pages))
  
  posts_raw <- NULL
  start_time <- Sys.time()
  for(i in 1:n_pages){
    delta <- getPage(pages[i], token, n=200, feed = TRUE) %>% 
      as_tibble() %>% cbind("page" = pages[i])
    posts_raw <- rbind(posts_raw, delta)
  } 
  end_time <- Sys.time()
  pull_time <- end_time - start_time 
  pull_rows <- nrow(posts_raw)
  file <- paste0("data/eyewatch_posts_raw_", Sys.Date(),".rda")
  save(posts_raw, file = file)
  
  print(pull_rows, " posts pulled from ", n_pages, 
        " pages. Data pulled in ", pull_time)
  print("Data has been saved to ", file, ". The path is also returned by this function.")
  
  return(file)
}