library(shiny)
library(datasets)
library(dplyr)
library(SnowballC)
library(RColorBrewer)
library(ggplot2)
library(wordcloud)
library(tm)
library(shinydashboard)
library(stringr)
library(leaflet)
library(DT)
library(sf)

# call datasets 

source("./www/data/data.R")

# Define Server

shinyServer(function(session, input, output) {
  
  #   PAGE 1 
  #   PLOT 1.1 - Main WordCloud
  
  output$wordPlot1 <- renderPlot(width = "auto", height = "auto",  res = 72,
                                 { 
                                   categories <- unlist(strsplit(commonWordCloud$categories, ";"))
                                   remove_categories <- c("Restaurants", "Food", "Nightlife", "Bars", "New")
                                   clean_categories <- removeWords(categories, remove_categories)
                                   # word cloud is created with this set of categories
                                   wordcloud(clean_categories,
                                             min.freq = 80,
                                             random.order=FALSE,
                                             rot.per=0.35,
                                             colors=brewer.pal( 8,"Dark2"))
                                 })
  
  
  #   PAGE 2 - Drop down and 2 histograms
  #   PLOT 2.1 - Graphs for Cities
  
  observeEvent(input$question, {
    if (req(input$question == "Top 10 cities?")) {
      
      output$reviewsPlot <- renderPlot({
        ggplot(data=top10cities, aes(x=reorder(top10cities$city,top10cities$total_review), y=top10cities$total_review)) +
          geom_bar(stat="identity", fill="#0073b7")+
          geom_text(aes(label=top10cities$total_review), vjust=-0.3, size=3.5)+
          geom_line(color = "chocolate", lwd = 0.8) +
          xlab("Major cities")+
          ylab("Total Reviews")+
          theme_minimal() + theme(axis.text.y=element_blank()) 
          
      })
      output$starsPlot <- renderPlot({
        ggplot(data=top10cities, aes(x=reorder(top10cities$city,top10cities$Avg_stars), y=top10cities$Avg_stars)) +
          geom_bar(stat="identity", fill="#0073b7")+
          geom_text(aes(label=round(top10cities$Avg_stars)), vjust=-0.3, size=3.5)+
          xlab("Major cities")+
          ylab("Average Stars")+
          theme_minimal() 
      })
    }
    
  }) 
  
  #   PLOT 2.2 - Graphs for States
  
  observeEvent(input$question, {
    if(req(input$question == "Top 10 states?")){
      output$reviewsPlot <- renderPlot({
        ggplot(data=top10states, aes(x=reorder(top10states$state,top10states$total_review), y=top10states$total_review)) +
          geom_bar(stat="identity", fill="#0073b7")+
          geom_text(aes(label=top10states$total_review), vjust=-0.3, size=3.5)+
          xlab("Major States")+
          ylab("Total Reviews")+
          theme_minimal() + 
          theme(axis.text.x = element_text(color = "grey20", size = 10, face = "bold"),
                axis.title.x = element_text(color = "grey20", size = 8, face = "bold"),
                axis.text.y=element_blank())
        
      })
      output$starsPlot <- renderPlot({
        ggplot(data=top10states, aes(x=reorder(top10states$state,top10states$Avg_stars), y=top10states$Avg_stars)) +
          geom_bar(stat="identity", fill="#0073b7")+
          geom_text(aes(label=round(top10states$Avg_stars)), vjust=-0.3, size=3.5)+
          xlab("Major States")+
          ylab("Average Stars")+
          theme_minimal() + 
          theme(axis.text.x = element_text(color = "grey20", size = 11, face = "bold"),
                axis.text.y = element_text(color = "grey20", size = 8, face = "bold"),  
                axis.title.x = element_text(color = "grey20", size = 8, face = "bold"),
                axis.title.y = element_text(color = "grey20", size = 8, face = "bold"))
      })
    }
  })
  
  # PAGE 3
  # PLOT 3.1 - Dynamic word cloud
  
  observeEvent(input$cuisine3, { 
    output$wordPlot3 <- renderPlot(width = "auto", height = "auto",  res = 72,
                                   { 
                                     business22 <- commonWordCloud %>% filter(str_detect(categories, input$cuisine3))
                                     categories <- unlist(strsplit(business22$categories, ";"))
                                     remove_categories <- c("Restaurants", "Food", "Nightlife", "Bars", "New")
                                     clean_categories <- removeWords(categories, remove_categories)
                                     wordcloud(clean_categories, 
                                               min.freq = 10,
                                               random.order=FALSE, 
                                               rot.per=0.35,
                                               colors=brewer.pal( 8,"Dark2"))
                                   })
    
  })
  
  # PLOT 3.2 - Frequency plot for each cuisine

  output$freqPlot <- renderPlot({
    cuisine<-commonWordCloud %>% filter(str_detect(categories, input$cuisine3))
    counts <- table(cuisine$stars)
    barplot(counts, col = "#f39c12",
            xlab="Average Ratings")
  })
  
  # PAGE 4
  # Plot 4.1 - Dynamic MAP using Leaflet
     filtered <- reactive({
          map.data[map.data$city == input$city,]
        })
     #Creates color palette for rating levels
         
        output$map <- renderLeaflet({

           leaflet(location_business)  %>% 
            addProviderTiles("Esri.NatGeoWorldMap")  %>% 

            addCircleMarkers(~longitude, 
          ~latitude,
            radius = 3,
                 fillOpacity = 1, label   = ~name,
                 color = ~pal(rating_level)
          ) %>%
          addLegend("bottomright", pal = pal, values = ~rating_level,
                    title = "Restaurant Ratings",
                    #labFormat = labelFormat(prefix = "$"),
                    opacity = 1
          )
          
  })
        mymap_proxy <- leafletProxy("map")
        
        observe({
          fdata <- filtered()
          mymap_proxy %>%
          
            flyTo(lng = fdata$longitude, lat = fdata$latitude, zoom = 7)
        })
  
  
  # Plot 4.2 - Dynamic table 
    
  output$dataSet <- renderTable({
    tableData <- tableData[ -c(1) ]
    cityFilter <- subset(tableData, tableData$City == input$city)
  })
  
  
}) # End of code
