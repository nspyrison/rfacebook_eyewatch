pull_fb_posts <- function(pages, n_ppp = 1000, token) {
  stopifnot(is.character(pages))
  require(Rfacebook)
  
  ### PULL
  pages <- gsub(" ", "", pages, fixed = TRUE) 
  pages <- tolower(pages)
  n_pages <- length(unique(pages))
  n_expected_posts <- n_pages * n_ppp
  
  posts_raw <- NULL
  start_time <- Sys.time()
  for(i in 1:n_pages){
    delta <- getPage(pages[i], token, n = n_ppp, feed = TRUE)
    delta <- cbind(delta, "page" = pages[i])
    posts_raw <- rbind(posts_raw, delta)
  } 
  end_time <- Sys.time()
  posts_raw <- as.data.frame(posts_raw)
  
  ### RETURN
  filename <- paste0("posts_raw_", gsub("-", "_", Sys.Date()))
  file <- paste0("data/", filename,".rda")
  eval(parse(text = paste0(filename, " <- posts_raw")))
  save(list = filename, file = file)
  
  if (nrow(posts_raw) != n_expected_posts) 
    message(paste0("FYI: Not all pages had ", n_ppp, " posts."))
  pull_time <- end_time - start_time 
  pull_rows <- nrow(posts_raw)
  message(paste0("\n", pull_rows, " posts pulled from ", n_pages, 
        " page(s). Data pulled in ", round(pull_time, 2), "seconds"))
  message(paste0("\nRaw data has been saved to  ", file, "  , the filepath is also returned by this function."))
  
  stopifnot(ncol(posts_raw) == 12)
  return(file)
}
