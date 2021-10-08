head(data_all)
rlang::last_error()


a <- data_all %>% filter(country == "China")
a %>% select(ends_with("x")) # select the data end up with "x"

