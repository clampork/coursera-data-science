# Load dependencies
library(shiny)
library(shinythemes)

# Source processed data
source("data_processing.R")

shinyUI(fluidPage(
    # Set theme CSS
    theme = "bootstrap.css",
    
    # Header div
    div(br(),
        h1("First degree courses in Singapore"),
        h6("An interactive look at the popularity of different part-time and
           full-time first degree courses amongst Singaporean graduates over
           time."),
        br()),
    
    # Define sidebar
    sidebarLayout(
        div(class = "sidebar",
        sidebarPanel(
            
            helpText("Select a date range and a course to see how course
                     popularity has evolved over the years as a proportion of 
                     total graduates. The smoothed conditional mean trendline 
                     gives an indication of rising or falling course 
                     popularity. You can find more documentation on the data ",
                     a("here", href = "https://data.gov.sg/dataset/graduates-from-university-first-degree-courses-by-type-of-course"),
                     ", and the full dataset ",
                     a("here", href = "https://data.gov.sg/dataset/edcc4d35-08e0-4ebd-b3bb-ac3a6a10c103/resource/eb8b932c-503c-41e7-b513-114cffbe2338/download/Graduates-From-University-First-Degree-Courses.csv"),
                     "."),
            
            br(),
            
            sliderInput("year", 
                        "Year",
                        min = min(df_raw$year), 
                        max = max(df_raw$year), 
                        value = c(min(df_raw$year), max(df_raw$year)),
                        step = 1,
                        sep = ""),
            
            selectInput("course",
                        "Course",
                        sort(as.character(unique(df_raw$type_of_course))))
        )),
        
        # Define main panel
        mainPanel(
            plotOutput("plot")
        )
    )
))