# This is the server logic of a Shiny web application. You can run the
# application by clicking 'Run App' above.
source("global.R")


server <- function(input, output, session) {
  ais_data <- eventReactive(input$go, {
    req(input$mmsi)
    df <- get_ais_by_mmsi(input$mmsi)
    df
  })
  
  predictions <- reactive({
    df <- ais_data()
    if (!input$show_pred || nrow(df) < 2) return(NULL)
    # Simple forecast: use last speed/course to project 1 minute ahead
    # Here goes your function to calculate predictions
  })
  
  output$map <- renderLeaflet({
    df <- ais_data()
    req(df)
    m <- leaflet(df) %>% addTiles()
    m <- m %>% addPolylines(~longitude, ~latitude, color = "blue", weight = 2)
    m <- m %>% addCircleMarkers(~longitude, ~latitude,
                                radius = ~pmin(pmax(speed / 2, 2), 8),
                                color = "navy", stroke = FALSE, fillOpacity = 0.6,
                                popup = ~paste0("Time: ", msg_timestamp, "<br>Speed: ", speed))
    pred <- predictions()
    if (!is.null(pred)) {
     # Here your prediction goes
    }
    m
  })
}