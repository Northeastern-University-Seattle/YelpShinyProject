# This is a Shiny web application for Yelp Data Analysis
# Author: Group 003

# Main File, DON'T TOUCH//

#Loading dependent packages  ----
require(shiny)
require(shinyjs)
rqrd_Pkg = c('shiny','shinyjs','dplyr','tidyverse','shinythemes',
             'stringr', 'readr', 'leaflet', 'DT', 'ggplot2', 'wordcloud','tm')
for(p in rqrd_Pkg){
  if(!require(p,character.only = TRUE)) 
    install.packages(p);
  library(p,character.only = TRUE)
}

#source("global.R")
source("./ui.R")
source("./server.R")

# Run the application 
shinyApp(ui = ui, server = server)

