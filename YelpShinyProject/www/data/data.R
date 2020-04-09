library(stringr)
library(htmltools)

# Loading various datasets

commonWordCloud <- read_csv("./www/data/business03.csv")
top10states <- read_csv("./www/data/business05.csv")
top10cities <- read_csv("./www/data/business06.csv")
tableData <- read_csv("./www/data/tabledata.csv")


# location data for the Map
location_business <- commonWordCloud %>%
       # filter for the city
       filter(city == city) %>%   
       # Creates 3 level based on rating
      mutate( rating_level = ifelse(stars == 4 | stars == 5 ,"High", ifelse(stars == 3, "Medium", "Low")))
map.data <- data.frame("city" = c("Chandler","Charlotte","Cleveland","Henderson","Las Vegas", "Mesa","Phoenix","Pittsburgh","Scottsdale","Tempe"), "latitude" = c(33.26,35.22,41.49,36.03,36.16,33.41,33.44,40.44,33.49,33.42), "longitude" = c(-111.85, -80.84,-81.69,-114.98,-115.13,-111.83,-112.07,-79.99,-111.92,-111.94))
pal <- colorFactor(c("#993222", "#0047AB","#007E56"), domain = c("Low", "Medium","High"))  

