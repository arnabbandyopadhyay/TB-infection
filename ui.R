

source('load.R')
shinyUI(pageWithSidebar(
  # headerPanel(ui_title,
  #             windowTitle = 'COVID Simulator'),
  headerPanel("TB across country"),
  sidebarPanel(width=3,
               shinyjs::useShinyjs(),
               selectInput(inputId = "Group", 
                           label = "Group",
                           choices = c('Country','WHO Region'),
                           selectize = ),
                           
               conditionalPanel(
                 condition = "input.Group=='Country'",selectInput(inputId = "select_country",label = "Select Country", choices =unique(TB_burd$country))),

               conditionalPanel(
                 condition = "input.Group=='WHO Region'",
                 selectInput(inputId = "group_id",label = "WHO Region",choices =unique(TB_burd$g_whoregion))
               ),

  ),
  mainPanel(
    # fluidRow(splitLayout(cellWidths = c("35%", "65%"),withSpinner(plotOutput('plot_cnt_matrix',width = "400px", height = "350px")),
    #                      withSpinner(plotlyOutput('total',width = "750px", height = "400px"))
    # )),
    fluidPage(
      img(src="animation.gif", align = "left",height='500px',width='1000px')),
    plotlyOutput("plot1"),
    plotOutput("plot2",width = "1000px", height = "400px"),
    fluidRow(splitLayout(cellWidths = c("50%", "50%"),plotOutput('acf',width = "400px", height = "350px"),
                         plotOutput('pacf',width = "400px", height = "350px")
    )),
    plotOutput("plot3"),
    plotOutput("plot4"),
    plotOutput("plot5")
  )
)
)


