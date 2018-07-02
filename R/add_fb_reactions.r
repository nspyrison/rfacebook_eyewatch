#file= "data/posts_raw_2018_06_03.rda"
#token <- "EAACEdEose0cBALYAsYI2VO5aPTKOeyd3bZAl2JR0k8T1sSUM40pb2bLuqDngVhZCuTRmUVhC7hVDO1haRZCumcXnvl39rMQA1hScRaDvZCLH2lY0GaTtZAxp0my2LWrELlQfbFpjKytz2226WWDej9ZCo2VZBwma2oeKgIuIIvvNVd0ZBlz1nP2XyxYZArN2ToFYIZC7kTbH512gZDZD" 
add_fb_reactions <- function(file, token) {
  tic <- Sys.time()
  stopifnot(is.character(file))
  stopifnot(file.exists(file))
  stopifnot(grepl("posts_raw_", file)) # expects raw posts file.
  require(Rfacebook)
  require(dplyr)
  
  ### ETL
  load(file = file)
  filename <- substr(file, 6, nchar(file) - 4) #SPECIFIC TO 'data/' % '.rda'
  
  posts_raw <- eval(parse(text = filename))
  posts_raw <- as.data.frame(posts_raw)
  n_posts_in <- nrow(posts_raw)
  
  ### getPost(). [[1]] is post info, [[2]] is comment info
  n_posts <- nrow(posts_raw)
  comments_raw <- NULL
  postinfo_raw <- NULL
  for (i in 1:n_posts) {
    tryCatch({
      ith_post <- getPost(post = posts_raw$id[i], token = token)
      #postinfo_raw <- rbind(postinfo_raw, ith_post[[1]]) 
      #dup of the post info from getPage()
      comments_raw <- rbind(comments_raw, ith_post[[2]])
    }, error=function(e){cat("MISSING POST (no comments or reactions):",
                             conditionMessage(e), "\n")})
  }
  comments_raw <- as.data.fram(comments_raw)
  
  ### getReactions()
  reactions_raw <- NULL
  for (i in 1:n_posts) {
    tryCatch({
      ith_reaction <- getReactions(post = posts_raw$id[i], token = token)
      reactions_raw <- rbind(reactions_raw, ith_reaction)
    }, error=function(e){})
  }
  
  posts_raw <- as.data.frame(left_join(posts_raw, reactions_raw, by = "id",
                         suffix = c(".x", ".y") ) )
  
  ### RETURN
  stopifnot(ncol(comments_raw) == 7)
  n_comments <- nrow(comments_raw)
  n_posts_out <- nrow(posts_raw)
  cfilename <- gsub("posts", "comments", filename)
  cfile <- paste0("data/", cfilename,".rda")
  eval(parse(text = paste0(cfilename, " <- comments_raw")))
  save(list = cfilename, file = cfile)
  
  print(paste0(n_comments, " comments pulled from ", n_posts_out, " posts."))
  print(paste0("Raw comment data has been saved to  ", file, "."))
  
  n_posts_out <- nrow(posts_raw)
  stopifnot(n_posts_in == n_posts_out)
  stopifnot(ncol(posts_raw) == 18)
  
  filename <- gsub("posts", "postreactions", filename)
  file <- paste0("data/", filename,".rda")
  eval(parse(text = paste0(filename, " <- posts_raw")))
  save(list = filename, file = file)
  
  toc <- Sys.time()
  runtime <- toc - tic
  print(paste0("Function ran in: ") )
  print(runtime)
  print(paste0("Raw post and reaction data has been saved to  ", file, 
                ". The filepath is also returned by this function."))
  
  return(file)
}

