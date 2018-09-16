#pages <- "eyewatchBallarat"
#n_ppp = 42
#token <- "EAACEdEose0cBALYAsYI2VO5aPTKOeyd3bZAl2JR0k8T1sSUM40pb2bLuqDngVhZCuTRmUVhC7hVDO1haRZCumcXnvl39rMQA1hScRaDvZCLH2lY0GaTtZAxp0my2LWrELlQfbFpjKytz2226WWDej9ZCo2VZBwma2oeKgIuIIvvNVd0ZBlz1nP2XyxYZArN2ToFYIZC7kTbH512gZDZD" 
pull_fb_posts <- function(pages, n_ppp = 1000, token) {
  tic <- Sys.time()
  stopifnot(is.character(pages))
  require(Rfacebook)
  
  ### PULL
  pages <- gsub(" ", "", pages, fixed = TRUE) 
  pages <- tolower(pages)
  n_pages <- length(unique(pages))
  n_expected_posts <- n_pages * n_ppp
  
  posts_raw <- NULL
  for(i in 1:n_pages){
    delta <- getPage(pages[i], token, n = n_ppp, api = "2.8")
    delta <- cbind(delta, "page" = pages[i])
    posts_raw <- rbind(posts_raw, delta)
  } 
  posts_raw <- as.data.frame(posts_raw)
  
  ### RETURN
  stopifnot(ncol(posts_raw) == 12)
  filename <- paste0("posts_raw_", gsub("-", "_", Sys.Date()))
  file <- paste0("data/", filename,".rda")
  eval(parse(text = paste0(filename, " <- posts_raw")))
  save(list = filename, file = file)
  
  if (nrow(posts_raw) != n_expected_posts) 
    message(paste0("FYI: Not all pages had ", n_ppp, " posts.") )
            

  pull_rows <- nrow(posts_raw)
  toc <- Sys.time()
  runtime <- toc - tic 
  print(paste0(pull_rows, " posts pulled from ", n_pages, " page(s).") ) 
  print(paste0("Function ran in:") )
  print(runtime)
  print(paste0("Raw data has been saved to  ", file, "  , the filepath 
                 is also returned by this function.") )
  
  return(file)
}
