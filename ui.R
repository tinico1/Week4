library(shiny)
library(plotly)


# Define UI for dataset viewer application
shinyUI(pageWithSidebar(
        
        # Application title.
        headerPanel("Filter"),
        
        
        # Sidebar with controls to select a filters of information
        sidebarPanel(
                h6("Select the filters and press Actualice"),
                selectInput("Racial Groups", "Choose:", 
                            choices = c("All Races", "White", 
                                        "Black or African American", 
                                        "Other Races and Unknown combined",
                                        "Asian or Pacific Islander", 
                                        "American Indian or Alaska Native"
                                        )),
                
                selectInput("Sex", "Choose:", 
                            choices = c("All Sex", 
                                        "Female", 
                                        "Male")),
                
                checkboxGroupInput("Age", "Choose:", 
                            choices = list( 
                                        "< 1 year" , 
                                        "1-4 years" , 
                                        "5-9 years" , 
                                        "10-14 years", 
                                        "15-19 years",
                                        "20-24 years",
                                        "25-29 years", 
                                        "30-34 years", 
                                        "35-39 years",
                                        "40-44 years", 
                                        "45-49 years",
                                        "50-54 years",
                                        "55-59 years", 
                                        "60-64 years",
                                        "65-69 years", 
                                        "70-74 years", 
                                        "75-79 years",
                                        "80-84 years", 
                                        "85+ years" ), selected = "< 1 year"),
                actionButton("Act", "Actualice")
        ),
        
        # Actual filters,
        
        mainPanel(
                h4("Filters"),
                verbatimTextOutput("oid1"),
                verbatimTextOutput("oid2"),
                verbatimTextOutput("oid3"),
                plotlyOutput("map"),
                plotlyOutput("BarP")

        )
))