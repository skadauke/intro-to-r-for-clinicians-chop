
print_time <- function(datetime, include_min = FALSE){
  stopifnot(require(lubridate))
  
  if(include_min){
    if(am(datetime)){
      time <- paste0(format(datetime, '%I:%M'), "am")
    } else {
      time <- paste0(format(datetime, '%I:%M'), "pm")
    }
  } else {
    if(am(datetime)){
      time <- paste0(hour(datetime), "am")
    } else {
      time <- paste0(hour(datetime)-12, "pm")
    }
  }
  # remove initial zero, if there
  time <- gsub(x = time, pattern ="^0", replacement = "")
  return(time)
}