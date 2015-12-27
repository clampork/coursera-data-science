# Load dependencies
library(shiny)
library(dplyr)
library(ggplot2)
library(scales)

# Define server logic for random distribution application
shinyServer(function(input, output) {

    # Source processed data
    source("data_processing.R")
    
    # Render plot
    output$plot <- renderPlot({
        df_subset <- df_cleaned %>% 
                         filter(type_of_course == input$course) %>%
                         filter(year >= input$year[1], year <= input$year[2])
        
        ggplot(data = df_subset, aes(x = year, y = proportion, fill = factor(sex))) +
            geom_bar(stat = "identity", position = "dodge") +
            geom_smooth(alpha = 0, color = "#b3b3b3", linetype = "dotted") +
            labs(x = "Year",
                 y = "Percentage (%)") +
            scale_x_continuous(limits = c(input$year[1] - 0.5, input$year[2] + 0.5),
                               breaks = seq(input$year[1], input$year[2], 2)) +
            scale_fill_manual(name = "Gender",
                              values = c("#cb1249", "#12a5cb")) +
            theme_minimal() +
            theme(axis.title = element_text(color = "#b3b3b3"),
                  axis.text = element_text(color = "#b3b3b3"),
                  axis.ticks = element_line(color = "#b3b3b3"),
                  legend.text = element_text(color = "#b3b3b3"),
                  legend.title = element_text(color = "#b3b3b3"),
                  panel.grid = element_blank()
                  )
    }, bg = "transparent")
})