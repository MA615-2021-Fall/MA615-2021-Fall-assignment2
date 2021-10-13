library(ggplot2)
library(tidyverse)
library(tidyr)
source("wrangling_code.R")


multiplot <- function(..., plotlist=NULL, file, cols=1, layout=NULL) {
  library(grid)
  # Multiple plot function
  #
  # ggplot objects can be passed in ..., or to plotlist (as a list of ggplot objects)
  # - cols:   Number of columns in layout
  # - layout: A matrix specifying the layout. If present, 'cols' is ignored.
  #
  # If the layout is something like matrix(c(1,2,3,3), nrow=2, byrow=TRUE),
  # then plot 1 will go in the upper left, 2 will go in the upper right, and
  # 3 will go all the way across the bottom.
  #
  # Make a list from the ... arguments and plotlist
  plots <- c(list(...), plotlist)
  
  numPlots = length(plots)
  
  # If layout is NULL, then use 'cols' to determine layout
  if (is.null(layout)) {
    # Make the panel
    # ncol: Number of columns of plots
    # nrow: Number of rows needed, calculated from # of cols
    layout <- matrix(seq(1, cols * ceiling(numPlots/cols)),
                     ncol = cols, nrow = ceiling(numPlots/cols))
  }
  
  if (numPlots==1) {
    print(plots[[1]])
    
  } else {
    # Set up the page
    grid.newpage()
    pushViewport(viewport(layout = grid.layout(nrow(layout), ncol(layout))))
    
    # Make each plot, in the correct location
    for (i in 1:numPlots) {
      # Get the i,j matrix positions of the regions that contain this subplot
      matchidx <- as.data.frame(which(layout == i, arr.ind = TRUE))
      
      print(plots[[i]], vp = viewport(layout.pos.row = matchidx$row,
                                      layout.pos.col = matchidx$col))
    }
  }
}

visualize_country <- function(c1, c2){
  # This function do the comparison betweeen countries about their co2 emission per person and 
  # the oil consumption in countries per person
  # I may need to do some try and error to make the program robust
  # try(if(!data_all[str(c1)] | !data_all[str(c2)]) stop("at least one country data is missing or type error"))
  
  a <- try(data_all %>% filter(country == c1 | country == c2))
  if (class(a)[1] == "try-error"){
    print("at least one country data is missing or type error")
    stop()
  }
  # pick up the data of co2 emission and oil consumption separatly,
  
  a_oil <- a %>% select(ends_with("country") | ends_with("x"))
  # rename the col_name by deleting ".x" like from "1965.x" to "1965", 
  # and move these cols into rows to be the time series
  
  a_oil <- a_oil %>% 
    rename_with( ~ gsub(".x", "", .x, fixed = T)) %>% 
    pivot_longer(c(`1964`:`2017`), names_to = "year", values_to =  "Oil_Consumption") 
  a_oil <- a_oil %>% rename(country_oil = country)
  
  a_co2 <- a %>% select(ends_with("country") | ends_with("y"))
  
  # rename the col_name by deleting ".y" like from "1965.y" to "1965", 
  # and move these cols into rows to be the time series
  
  a_co2 <- a_co2 %>% rename_with( ~ gsub(".y", "", .x, fixed = T))
     
  a_co2 <- a_co2 %>% pivot_longer(c(`1964`:`2017`), names_to = "year", values_to =  "CO2_emission")
  a_co2 <- a_co2 %>% rename(country_co2 = country)
  
  # combine a_oil and a_co2
  a_combine <- a_oil %>% mutate(a_co2$CO2_emission)
  x_label <- seq(min(a_co2$year),max(a_co2$year), 10)
  #now we draw the figures of them separately.
  p1 <- ggplot() + 
    geom_point(data = a_oil, aes(x = year, y = Oil_Consumption, color = country_oil), shape = 23) +
    geom_point(data = a_co2, aes(x = year, y = CO2_emission, color = country_co2)) + 
    scale_x_discrete(breaks = x_label)
  # use scale_x_discrete, so that the x axis looks better without squeezing together
  # TO DO: I want to make the legend separated by different data
  # TO DO: I want to use a second y axis to explain my point but don't know how
  # use sec.axis = sec_axis( trans = , name = ""), 
  # more detail looking at https://www.r-graph-gallery.com/line-chart-dual-Y-axis-ggplot2.html
  
  
  p2 <- ggplot(a_combine) +
    geom_point(data = a_combine, aes(x = Oil_Consumption, y = a_co2$CO2_emission, color = country_oil)) +
    geom_smooth(data = a_combine, aes(x = Oil_Consumption, y = a_co2$CO2_emission, color = country_oil),
                formula = y ~ x, method = "lm")
  
  # plot 2 figures in one plot page
  multiplot(p1, p2, cols = 1)
}

### test part, here we use China and India to make an example
visualize_country("China", "India")



# test1 <- data_all %>% filter(country == "China" | country == "India")
# test1_1 <- test1 %>% select(ends_with("country") | ends_with("x"))
# test1_2 <- test1 %>% select(ends_with("country") | ends_with("y"))
# 
# 
# # test1_country1 <- test1_country1 %>% t()
# test1_country2 <- test1_1 %>% filter(country == "China" | country == "India")
# test1_country2 <- test1_country2 %>% 
#   rename_with( ~ gsub(".x", "", .x, fixed = T)) %>% 
#   pivot_longer(c(`1964`:`2017`), names_to = "year", values_to =  "oil-consumption")   # add year col
# 
# test1_country3 <- test1_2 %>% filter(country == "China" | country == "India")
# test1_country3 <- test1_country3 %>% rename_with( ~ gsub("y", "", .x, fixed = T))    # add year col
# test1_country3 <- test1_country3 %>% pivot_longer(c(`1964`:`2017`), names_to = "year", values_to =  "oil-consumption")
# # gsub('[[:punct:]]', '', .x
# # test1_country1 <- test1_1 %>% filter(country == "China" | country == "India") %>% t() %>% as.numeric()
# # test1_country1 <- test1_country1[-1]
# 
# 
# ggplot(test1_country2, aes(x = year, y = population, color = country)) + geom_point()
# 
# a <- data_all %>% filter(country == "China") # filter out the rows with specific feature.
# a %>% select(ends_with("x")) # select the col of data end up with "x"

