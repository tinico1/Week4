library(dplyr)

Cancer <- read.delim("Cancer.txt")
states <- data.frame(States = state.name, abb = state.abb)
states$pop <- state.x77[,1]


filtrar <- function(rg, sex, age) {
        
      CancerOut <- Cancer %>% filter(Age.Groups %in% age)

        if (sex != "All Sex") {
                CancerOut <- CancerOut[CancerOut$Sex == sex, ]   
        }
        if (rg != "All Races")  {
                CancerOut <- CancerOut[CancerOut$Race == rg, ]   
        }
        CancerSum <- CancerOut %>% select(States, States.Code, Count) %>% 
                group_by(States, States.Code)  %>% 
                summarise(total = sum(Count))
        
        CancerTot <-merge(CancerSum, states, by.x = "States", by.y = "States", all.y = TRUE)
        if (sum(is.na(CancerTot$total)) > 0) {
        CancerTot[is.na(CancerTot$total),]$total <- 0
        }
        
        CancerTot$RelCase <- (CancerTot$total / CancerTot$pop)
        CancerTot$hover <- with(CancerTot, paste(abb, '<br>', "Total Cases:", total))
        CancerTot
}

server <- function(input, output, sesion) {
        
        
       output$oid1 <- renderPrint({input$`Racial Groups`})
       output$oid2 <- renderPrint({input$Sex})
       output$oid3 <- renderPrint({input$Age})
       DtSet <- eventReactive(input$Act,
                              {filtrar(input$`Racial Groups`, input$Sex, input$Age) } )     
      

       output$map <- renderPlotly({       
               map_options <- list(
               scope = 'usa',
               projection = list(type = 'albers usa'),
               showlakes = TRUE,
               lakecolor = toRGB('white')
       )
       borders <- list(color = toRGB("red"))
       plot <- plot_ly(z = ~DtSet()$RelCase, 
                       text = ~DtSet()$hover, 
                       locations = ~DtSet()$abb, 
                       type = 'choropleth', 
                       locationmode = 'USA-states', 
                       color = ~DtSet()$RelCase, 
                       colors = 'Purples', 
                       marker = list(line = borders)) %>%
               layout(title = 'US Cancer Cases 2009-2014', 
                      geo = map_options)
       
       })
       output$BarP <- renderPlotly({plot_ly(DtSet(), x = ~abb, 
                                            y =  ~total,
                                            type = 'bar', 
                                            name = 'Total Cases') %>%
               layout(yaxis = list(title = 'Count'), barmode = 'group')})
       }
