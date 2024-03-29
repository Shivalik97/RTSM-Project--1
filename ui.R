library(plyr)
library(shiny)
library(shinydashboard)
library(dplyr)
library(tidyr)
library(DT)
library(data.table)
library(rworldmap)
library(plotly)
packageVersion('plotly')
library(ggplot2)
library(shinyWidgets)
library(pairsD3)

#this is the user interface side of the dashboard
shinyUI(
  dashboardPage(
    
    #the dashboard header can contain elements including notifications, messages and status bars
    #these items can support links
    
    dashboardHeader(title = " Shivalik Singh RTSM Project - 1", titleWidth = 800),
    
    #the sidebar allows for menus and submenus to organize plots and data

    dashboardSidebar(
      sidebarMenu(
        menuItem("Introduction", tabName = "intro", icon=icon("clipboard")),
        menuItem("Explore World Happiness Index", tabName = "explore",
                 menuSubItem("World Happiness Data - 2015", tabName = "data2015"),
                 menuSubItem("World Happiness Data - 2016", tabName = "data2016"),
                 menuSubItem("World Happiness Data - 2017", tabName = "data2017")),
        menuItem("Mapping the Data", tabName = "map"),
        menuItem("Histogram", tabName = "hist", icon = icon("chart-bar")),
        menuItem("Scatter Plot", tabName = "scatter", icon = icon("chart-line")),
        menuItem("Pairs Scatter Plot", tabName = "samplepairsplot", icon = icon("th")),
        menuItem("Try your data", tabName = "up"))
    ),
    
    #there are a series of default statuses and colors included in the package
    #it is also possible to include CSS files for style within the overall folder
    #or to embed HTML and CSS code in the output area
    #the tags below allow for the official colors of UNCG to be displayed
    dashboardBody(
      tags$head(
        tags$style(HTML("
            .skin-blue .main-header .logo {
            background-color: #ffdd1b;
          }
            .skin-blue .main-header .navbar {
             background-color: #ffdd1b;
          }
          .content-wrapper {
            background-color: #bec2c1 !important;
          }
          .main-sidebar {
            background-color: #21879c !important;
          }
        "))
      ),
      
      #each tabItem is associated with a same sidebard menu name
      #when sidebar is clicked the appropriate tabItem is displayed in the dashboard body
      
      tabItems(
        tabItem("intro",
                fluidRow(infoBoxOutput("about", width = 9)),
                fluidRow(infoBoxOutput("source", width = 9)),
                column(width = 8,
                       fluidRow(valueBoxOutput("mean", width = 8)),
                       fluidRow(valueBoxOutput("median", width = 8)),
                       fluidRow(valueBoxOutput("sd", width = 8)),
                       fluidRow(valueBoxOutput("max", width = 8))),
                column(width = 4,
                       (radioButtons(inputId = "datachoice",
                                     label = "Choose a dataset",
                                     choices = c("Happiness_2015", "Happiness_2016", "Happiness_2017"))),
                       (radioButtons(inputId = "column",
                                     label = "Choose a column",
                                     choices = c("Happiness.Rank", "Happiness.Score", "Economy..GDP.per.Capita.", "Family", "Health..Life.Expectancy.", 
                                                 "Freedom", "Trust..Government.Corruption.", "Generosity", "Dystopia.Residual"))))),
        
        #dropdown menus can be embedded in the sidebard to further categorize output, additionally tabPanels can

        tabItem("explore"),
        tabItem("data2015", column(width = 12, DT::dataTableOutput("mydatatable1"),style = "height:500px; overflow-y:scroll;overflow-x: scroll;")),
        tabItem("data2016", column(width = 12, DT::dataTableOutput("mydatatable2"),style = "height:500px; overflow-y:scroll;overflow-x: scroll;")),
        tabItem("data2017", column(width = 12, DT::dataTableOutput("mydatatable3"),style = "height:500px; overflow-y:scroll;overflow-x: scroll;")),
        tabItem("map",
                fluidRow(
                  tabBox(
                    title = "Mapping the Data",
                    id = "tabset1", height = "600px", width = 10,
                    tabPanel("2015 Happiness Data", plotOutput("plotmap1")),
                    tabPanel("2016 Happiness Data", plotOutput("plotmap2")),
                    tabPanel("2017 Happiness Data", plotOutput("plotmap3")),
                    selectInput("cat", "Select a category:",
                                list("cat" = c("Region", "Happiness.Rank", "Happiness.Score", "Economy..GDP.per.Capita.", "Family", "Health..Life.Expectancy.", 
                                               "Freedom", "Trust..Government.Corruption.", "Generosity", "Dystopia.Residual")),
                                selected = "Happiness.Rank")))),
        
        #inputs are displayed for plots in both the code above and below, these inputs are passed to the server
    
        tabItem(tabName = "hist",
                fluidRow(
                  column(width = 9,
                         plotlyOutput("hist", height = 450)),
                  column(width = 3,
                         (box(title = "Select a Dataset", radioButtons(inputId = "histdatachoice", label = "Choices",
                                                                       choices = c("Happiness_2015", "Happiness_2016", "Happiness_2017")), width = NULL,
                              background = "yellow",solidHeader = T)),
                         (box(title = "Select a variable", 
                              selectInput("histaxischoice", "Choices:", list("histaxischoice" = c("Economy..GDP.per.Capita.", "Family", "Health..Life.Expectancy.", 
                                                                                                  "Freedom", "Trust..Government.Corruption.", "Generosity", "Dystopia.Residual"))),
                              width = NULL,
                              background = "yellow", solidHeader = T)),
                         sliderInput("bins",
                                     "Number of bins:",
                                     min = 1,
                                     max = 50,
                                     value = 30)))),
        
        #more examples of reactive data and plots is included in the scatter and boxplots below, boxes can be used
 
        tabItem(tabName = "scatter",
                fluidRow(
                  column(width = 9,
                         (box(title = "Scatter Plot", plotlyOutput("scatter", height = 500), width = NULL,
                              status = "primary", solidHeader = T, collapsible = T))),
                  column(width = 3,
                         (box(title = "Select a Dataset", radioButtons(inputId = "scatterdatachoice", label = "Choices",
                                                                       choices = c("Happiness_2015", "Happiness_2016", "Happiness_2017")), width = NULL,
                              background = "orange",solidHeader = T)),
                         (box(title = "Select a variable for the x axis", 
                              selectInput("xaxiss", "Choices", list("xaxiss" = c("Happiness.Rank",
                                                                                 "Happiness.Score", "Economy..GDP.per.Capita.", "Family", "Health..Life.Expectancy.", 
                                                                                 "Freedom", "Trust..Government.Corruption.", "Generosity", "Dystopia.Residual")),
                                          selected = "Happiness.Rank"),
                              width = NULL,
                              background = "orange", solidHeader = T)),
                         (box(title = "Select a variable for the y axis", 
                              selectInput("yaxiss", "Choices:", list("yaxiss" = c("Happiness.Rank",
                                                                                  "Happiness.Score", "Economy..GDP.per.Capita.", "Family", "Health..Life.Expectancy.", 
                                                                                  "Freedom", "Trust..Government.Corruption.", "Generosity", "Dystopia.Residual")),
                                          selected = "Happiness.Score"),
                              width = NULL,
                              background = "orange", solidHeader = T))))),
        
        #output for the pairsD3 package using a reactive function for the data set choice, variables are
        #indicated on the server side
        tabItem(tabName = "samplepairsplot",
                fluidRow(
                  column(width=9,
                         (box(title = "Pairs Plot", pairsD3Output("pairs", height = 650), width = NULL,
                              status = "primary", solidHeader = T, collapsible = T))),
                  column(width = 3,
                         (box(title = "Select a Dataset", radioButtons(inputId = "pairsdatachoice", label = "Choices",
                                                                       choices = c("Happiness_2015", "Happiness_2016", "Happiness_2017")), width = NULL,
                              background = "orange",solidHeader = T))))),
        
        #final tab for uploading files displayed in dashboard body
        tabItem("up",
                fluidRow(
                  box(
                    width = 12, status = "info",
                    title = "Upload Your Own File", uiOutput("tb"),
                    fileInput("file", "Upload the file"), helpText("max. file size is 5MB"),
                    checkboxInput("header", label="Header", value=FALSE),
                    checkboxInput("stringAsFactors", "stringAsFactors", FALSE),
                    radioButtons(inputId = 'sep', label = 'Separator', choices = c(Comma=',',
                                                                                   Semicolon=';',Tab='\t', Space=''), selected = ','))))
      ))))