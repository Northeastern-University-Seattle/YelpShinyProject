library(shiny)
library(shinythemes)
library(shinydashboard)
library(shinyjs)
library(leaflet)
library(DT)

# call datasets 

source("./www/data/data.R")

# Define UI 

ui <- dashboardPage(skin="red",
                    dashboardHeader(title = "Yelp Restaurants and Consumer Analysis", titleWidth=750),
                    dashboardSidebar(width=250,
                                     
# Sidebar Panel 
                                     sidebarMenu(
                                       menuItem("Introduction",icon=icon("home"),tabName="home"),
                                       menuItem("Histograms | Data",icon=icon("fas fa-chart-bar"),tabName="histogram"),
                                       menuItem("Word Cloud | Cuisine",icon=icon("fas fa-cloud"),tabName="wordCloud"),
                                       menuItem("Map | City",icon=icon("fas fa-map-marker-alt"),tabName="map"),
                                       menuItem("Team",icon=icon("fas fa-users"),tabName="team"), 
                                       tags$style(HTML('.main-header .logo {
                                                           font-family: "Georgia", Times, "Times New Roman", serif;
                                                           font-weight: bold;
                                                           font-size: 28px;
                                                           },
                                                        .main-header .sidebar-toggle {
                                                          font-family: "Georgia", Times, "Times New Roman", serif;
                                                                    font-weight: 900;
                                                                    margin-left: 0px;
                                                                    }
                                                           ')))
                    ),

# Main Body 
                    dashboardBody(
                      tabItems(
                        # TAB 1
                        tabItem(tabName="home",
                                fluidRow(
                                  column(width = 6, 
                                         box(
                                          "Yelp is an application that connects people with great local businesses.
                                           This project will help consumer look for a better restaurant and help restaurant owners improve their business.", width = NULL,
                                            tags$style('body {color:#4d4849; font-size:15px; 
                                                       font-family: "Georgia", Times, "Times New Roman", serif;}')
                                         ),
                                         
                                         box(
                                           title = "POPULAR CRAVINGS IN THE US", width = NULL, solidHeader = TRUE, background = "red",
                                           "The word cloud below displays all the words that the consumers have to say regarding the restaurants",
                                           plotOutput("wordPlot1")
                                         )
                                        
                                  ),
                                  
                                  column(width = 2,
                                         box(width = NULL,
                                            # tags$img(src= "logo.png", height = 150, width = 150)
                                            tags$a(
                                              href="https://www.yelp.com/", 
                                              target="_blank",
                                              tags$img(src="logo.png", 
                                                       title="Yelp Website", 
                                                       width="150",
                                                       height="150")
                                            )
                                         ),
                                         box(width = NULL,
                                             tags$img(src= "goal.png", height = 150, width = 150))
                                         
                                  ),
                                  
                                   column(width = 4,
                                     box(title = "Data",
                                     width = NULL,
                                       "Yelp dataset is very large with information on 116952 businesses and 6.6 million reviews. 
                                       We look at the restaurants in US focusing on the business and review information. It had lot of redundant data that was efficiently wrangled without bias.",
                                       )
                                     ,
                                     box(title = "Goal", width = NULL,
                                         "Visualizations are made to better understand the restaurants based on cities, states and cuisines. 
                                         Performance is judged by analysing the reviews and giving an actual sentiment score to help both customers and merchants understand the restaurant better by providing deep insights.")
                                   )
                                )
                        ),
                        
                        # TAB 2
                        tabItem(tabName="histogram",
                                fluidRow(
                                  column(width = 6,
                                         box(
                                           title = "YELP DATA IN USA", width = NULL, background = "blue",
                                           "Here there are two plots depicting the Reviews and Stars given by the consumer to a particular restaurant for the Top 10 cities and states in US",
                                           selectInput(
                                             width = "100%",
                                             inputId = "question",
                                             label = "Select from the options below:",
                                             choices = c(choose = "select sth", "Top 10 cities?", "Top 10 states?"),
                                             selected = NULL,
                                             multiple = FALSE
                                            )
                                         ),
                                         box(
                                           title = "Plot for Reviews", width = NULL, status = "primary", solidHeader = TRUE, 
                                           "Histogram of Review counts by consumer",
                                           plotOutput("reviewsPlot")
                                         )
                                     
                                  ),
                
                                  column(width = 6,
                                         box(
                                           title = "Plot for Stars", width = NULL, status = "primary", solidHeader = TRUE,
                                           "Histogram of Stars by consumer",
                                           plotOutput("starsPlot")
                                         )
                                        )
                                )
                        ),
                        
                        # TAB 3
                        tabItem(tabName="wordCloud",
                                fluidRow(
                                   column(width = 6,
                                  box(
                                    title = "CUISINE", width = NULL, solidHeader = TRUE, status = "warning",
                                    selectInput("cuisine3", "Select a cuisine:", choices = 
                                                  c("American", "Mexican","Italian","Japanese", "Chinese", "Thai",
                                                    "Mediterranean", "French", "Vietnamese","Greek","Indian",
                                                    "Korean", "Hawaiian", "African", "Spanish"
                                                  ))
                                      ),
                                         box(
                                           title = "Word Cloud", width = NULL, solidHeader = TRUE, status = "warning", "Displaying the top items for the cuisine selected",
                                           plotOutput("wordPlot3")
                                         )
                                  ),
                                  column(width = 6,
                                         box(
                                           title = "Plot for Average Ratings", width = NULL, status = "warning", solidHeader = TRUE,
                                           "Distribution of average ratings for the cuisine selected",
                                           plotOutput("freqPlot")
                                         )
                                      )
                                )
                        ),
                        
                        # TAB 4
                        
                        tabItem(tabName="map",
                                fluidRow(
                                  column(width = 8,
                                         box(
                                           title = "Map of the city selected", width = NULL, solidHeader = TRUE, status = "primary", 
                                           leafletOutput("map", height = 400)
                                           ),
                                         box(
                                           title = "Top 5 Restaurants of the city selected:", width = NULL, solidHeader = TRUE, status = "primary",
                                           tableOutput("dataSet")
                                         )
                                  ),
                                  column(width = 4,
                                         box(
                                           title = "Select City", width = NULL, solidHeader = TRUE, background = "blue",
                                           selectInput(
                                             inputId = "city",
                                             label = "Select your city from the list",
                                             choices = c(choose = "Choose city", "Las Vegas", "Phoenix", "Tempe", "Charlotte", "Pittsburgh", 
                                                                 "Henderson", "Mesa", "Cleveland", "Chandler", "Scottsdale"),
                                             selected = NULL,
                                             multiple = FALSE)
                                           )
                                        )
                                  )
                                  ),
                          
                        # TAB 5
                        
                        tabItem(tabName="team",
                                fluidRow(
                                  
                                column(width = 12,
                                       fluidRow(
                                         box(width = 8, solidHeader = TRUE, background = "blue",
                                             title = "OUR AWESOME TEAM"
                                             #Plot
                                         )
                                       ),
                                       fluidRow(
                                         box(width = 2, solidHeader = TRUE, status = "warning",
                                             title = "Aakash Kedia",
                                             tags$img(src= "Aakash.png", height = 150, width = 150)
                                             
                                         ),
                                         box(width = 2, solidHeader = TRUE, status = "warning",
                                             title = "Yufei Wang",
                                              tags$img(src= "Yufei.jpeg", height = 150, width = 150)
                                             
                                             #Plot
                                         ),
                                         box(width = 2, solidHeader = TRUE, status = "warning",
                                             title = "Vaibhavi Gaekwad",
                                             tags$img(src= "Vaibhavi.jpg", height = 150, width = 150)
                                             
                                             #Plot
                                         ),
                                         box(width = 2, solidHeader = TRUE, status = "warning",
                                             title = "Pranav Nair",
                                             tags$img(src= "Pranav.jpg", height = 150, width = 150)
                                         )
                                       ),
                                       fluidRow(
                                         
                                         # Aakash
                                         
                                         box(width = 2, solidHeader = TRUE, status = "warning",
                                             tags$img(src= "usefulLinks.jpg", height = 30, width = 70),
                                             tags$a(
                                               href="https://www.linkedin.com/in/aakash-seatac/", target="_blank", 
                                               tags$img(src="linkedIn.png", 
                                                        width="30",
                                                        height="30")
                                             ) ,  
                                             tags$a(
                                               href="https://github.com/akiboy96-newid", target="_blank", 
                                               tags$img(src="github.png", 
                                                        width="30",
                                                        height="30")
                                             )  
                                         ),
                                         
                                         # Yufei
                                         
                                         box(width = 2, solidHeader = TRUE, status = "warning",
                                             tags$img(src= "usefulLinks.jpg", height = 30, width = 70),
                                             tags$a(
                                               href="https://www.linkedin.com/in/yufei-wang-979b84127/", target="_blank",  
                                               tags$img(src="linkedIn.png", 
                                                        width="30",
                                                        height="30")
                                             ) ,  
                                             tags$a(
                                               href="https://github.com/yfwne01?tab=repositories", target="_blank", 
                                               tags$img(src="github.png", 
                                                        width="30",
                                                        height="30")
                                             )  
                                         ),
                                         
                                         # Vaibhavi 
                                         
                                         box(width = 2, solidHeader = TRUE, status = "warning",
                                             tags$img(src= "usefulLinks.jpg", height = 30, width = 70),
                                             tags$a(
                                               href="https://www.linkedin.com/in/vaibhavi-gaekwad", target="_blank",  
                                               tags$img(src="linkedIn.png", 
                                                        width="30",
                                                        height="30")
                                             ) ,  
                                             tags$a(
                                               href="https://github.com/vaibhavigaekwad007", target="_blank", 
                                               tags$img(src="github.png", 
                                                        width="30",
                                                        height="30")
                                             )   
                                         ),
                                         
                                        # Pranav 
                                        
                                         box(width = 2, solidHeader = TRUE, status = "warning",
                                             tags$img(src= "usefulLinks.jpg", height = 30, width = 70),
                                             tags$a(
                                               href="https://www.linkedin.com/in/pranav7nair/", target="_blank",  
                                               tags$img(src="linkedIn.png", 
                                                        width="30",
                                                        height="30")
                                             ) ,  
                                             tags$a(
                                               href="https://github.com/pranav7sunil", target="_blank", 
                                               tags$img(src="github.png", 
                                                        width="30",
                                                        height="30"))   
                                           )
                                         ) )
                                      )
                        
                                 ) # End of Tab 5
                    )    # End of tab items
                    
                )     # End of body    
                    
            
)  # End of structure

