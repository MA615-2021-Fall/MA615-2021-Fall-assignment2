head(data_all)
rlang::last_error()

source("wrangling_code.R")


visualize_country <- function(c1, c2){
  # This function do the comparison betweeen countries about their co2 emission per person and 
  # the oil consumption in countries per person
  # I may need to do some try and error to make the program robust
  # try(if(!data_all[str(c1)] || !data_all[str(c2)]) stop("at least one country data is missing or type error"))
  
  a <- try(data_all %>% filter(country == str(c1) || country == str(c2)))
  if (class(a)[1] == "try-error"){
    print("at least one country data is missing or type error")
  }
  a_co2 <- a %>% select(ends_with("x"))
}

a <- data_all %>% filter(country == "China")
a %>% select(ends_with("x")) # select the data end up with "x"

