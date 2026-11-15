library(tidyverse)
library(readr)


data_raw<- read_csv(file.choose())
data_raw

glimpse(data_raw)

final_traffic_analysis_13M_data<- data_raw %>% distinct() %>%
  mutate(
    
  
    
    county_fips = as.integer(county_fips),
    fine_grained_location = as.integer(fine_grained_location),
    lat = as.numeric(lat),
    lon =as.numeric(lon),
    search_conducted = as.integer(search_conducted),
    contraband_found = as.integer(contraband_found),
    is_arrested = as.integer(is_arrested)
    
  ) %>% filter(
    !is.na(county_name),
    !is.na(driver_gender),
    !is.na(driver_race),
    !is.na(violation),
    !is.na(stop_outcome),

 
  )%>% group_by(state,county_name,driver_gender,driver_race,violation,
                stop_outcome) %>%
  
  summarise(
    Total_Searches = sum(search_conducted,na.rm = TRUE),
    Total_contraband_found = sum(contraband_found, na.rm=TRUE),
    Total_Arrests = sum(is_arrested,na.rm=TRUE),
    Avg_Lat = mean(lat,na.rm=TRUE),
    Avg_lon = mean(lon,na.rm=TRUE),
    Total_Stops = n(),
    .groups = 'drop'
  ) %>% arrange(desc(Total_Stops))

final_traffic_analysis_13M_data

write.csv(final_traffic_analysis_13M_data,
          'Stamford_traffic_police_13M_data.csv',
          row.names = FALSE)  

getwd()                     
    
  