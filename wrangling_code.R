# upload the data
library(tidyverse)
path <- getwd()  # get the current working directory
data_co2_emis <- read_csv(paste0(path, "/co2_emissions_tonnes_per_person.csv"), col_names = T) # read_csv makes the first column as col.name, but col_name can make it 
data_emp_data <- read_csv(paste0(path, "/oil_consumption_per_cap.csv"), col_names = T)

# data_co2_emis_2 <- data_co2_emis[(nrow(data_co2_emis) - 64 :
                                    # nrow(data_co2_emis))]
# withdraw the data of recent year starting from 1964
data_co2_emis_2 <- data_co2_emis[(nrow(data_co2_emis) - 27) : 220] 
# take care: nrow is not the last

# add the country column
data_co2_emis_2 <- add_column(data_co2_emis_2, data_co2_emis["country"])

# combine data_emp_data and data_co2_emis_2
data_all <- left_join(data_emp_data, data_co2_emis_2, by = "country")

# delete the rows with NA
data_all <- na.omit(data_all)
