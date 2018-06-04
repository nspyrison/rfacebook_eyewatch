pull_fb_reactions <- function(file, token) {
  stopifnot(is.character(file))
  stopifnot(file.exists(file))
  require(Rfacebook)
  
  ### PULL REACTIONS
  #might need to make this go in order, and use exact object name, rather than dynamic.
  load(file = file)
  filename = substr(file, 6, nchar(file) - 4) #SPECIFIC TO 'data/' % '.rda'
  
  posts_obj <- eval(parse(text = filename))
  posts_obj <- as.data.frame(posts_obj)
  
  #WORK HERE !!!!!!
  getReactions(post = posts_obj$id[i], token=fb_oauth)
  
  
  
  ### RETURN
  filename <- paste0("posts_clean_", gsub("-", "_", Sys.Date()))
  file <- paste0("data/", filename,".rda")
  eval(parse(text = paste0(filename, " <- posts_clean")))
  save(list = filename, file = file)
  
  print(paste0("Clean data has been saved to  ", file, ".  The filepath is also returned by this function."))
  stopifnot(ncol(posts_clean) == 18)
  return(file)
}

