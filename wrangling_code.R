# upload the data
library(tidyverse)
path <- "D:/Boston University/Courses/MA615-Data Scicence/homework/assignment2/"
data_co2_emis <- read_csv(paste0(path, "co2_emissions_tonnes_per_person.csv"), col_names = T) # read_csv makes the first column as col.name, but col_name can make it 
data_emp_data <- read_csv(paste0(path, "oil_consumption_per_cap.csv"), col_names = T)

# data_co2_emis_2 <- data_co2_emis[(nrow(data_co2_emis) - 64 :
                                    # nrow(data_co2_emis))]
data_co2_emis_2 <- data_co2_emis[(nrow(data_co2_emis) - 27) : 220] # nrow is not the last
data_co2_emis_2 <- add_column(data_co2_emis_2, data_co2_emis["country"])

data_all <- left_join(data_emp_data, data_co2_emis_2, by = "country")
