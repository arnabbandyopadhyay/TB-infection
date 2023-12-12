shinyServer(function(input, output, session) {
  
  output$plot1 <- renderPlotly({
    if (input$Group == "Country"){
      
      col<-'c_newinc'
      
      gdp_dat<-sdg[sdg$indicator.id=='NY.GDP.PCAP.PP.KD',]

      md<-merge(TB_burd[,c('country','g_whoregion','year','e_inc_100k','e_inc_100k_lo','e_inc_100k_hi')],
                gdp_dat, by=c('country','year'), all.x=TRUE)
      fig1 <- plot_ly(md[md$country==input$select_country,], x = ~year, y = ~e_inc_100k_lo,legendgroup = "G1", type = 'scatter', mode = 'lines',
                      name = '',line = list(color = 'rgb(255, 255, 255)'),showlegend = F)
      ay <- list(tickfont = list(color = "red"),overlaying = "y",side = "right",title = "<b>GDP</b>")
      fig1 <- add_trace(fig1, x=~year, y=~e_inc_100k_hi,legendgroup = "G1",mode = 'lines', line = list(color = 'rgb(255, 255, 255)'),connectgaps = TRUE,fillcolor="rgba(173,216,230,0.5)", fill = 'tonexty' )
      fig1 <- add_trace(fig1, x=~year, y=~e_inc_100k,name='TB', legendgroup = "G1", mode = 'lines',line = list(color = 'rgb(0,0,255)'),showlegend = T,
                        hoverinfo='text', text=~paste('</br>Year: ',year,'</br>Infections: ',round(e_inc_100k)))
      fig1 <- add_trace(fig1, x=~year, y=~value,yaxis = "y2", name='GDP',legendgroup = "G2", mode = 'lines',line = list(color = 'rgb(255,0,0)'),showlegend = T,
                        hoverinfo='text', text=~paste('</br>Year: ',year,'</br>GDP: ',round(value)))
      fig1 <- fig1 %>%layout(title = "<b>TB infections & GDP per year</b>", yaxis2 = ay,
                             xaxis = list(title="<b>Year</b> ",tickangle = 315),
                             yaxis = list(title="<b>TB infection</b>"))
      
      
      
      
      fig1
      
    }
    else{
      who_dat<-TB_burd[,c('year','country','g_whoregion','e_inc_100k','e_inc_100k_lo','e_inc_100k_hi')]
      gdp_dat<-sdg[sdg$indicator.id=='NY.GDP.PCAP.PP.KD',]
      
      md<-merge(who_dat,gdp_dat, by=c('country','year'), all.x=TRUE)
      md$value[is.na(md$value)]<-0
      
      md %>%
        group_by(g_whoregion, year) %>%
        summarise(e_inc_100k = sum(e_inc_100k),
                  e_inc_100k_lo = sum(e_inc_100k_lo),
                  e_inc_100k_hi = sum(e_inc_100k_hi),
                  value = sum(value)) ->who_dat
      
      toplot<-who_dat[who_dat$g_whoregion==input$group_id,-c(1)]
      
      fig1 <- plot_ly(toplot, x = ~year, y = ~e_inc_100k_lo,legendgroup = "G1", type = 'scatter', mode = 'lines',
                      name = '',line = list(color = 'rgb(255, 255, 255)'),showlegend = F)
      ay <- list(tickfont = list(color = "red"),overlaying = "y",side = "right",title = "<b>GDP</b>")
      fig1 <- add_trace(fig1, x=~year, y=~e_inc_100k_hi,legendgroup = "G1",mode = 'lines', line = list(color = 'rgb(255, 255, 255)'),connectgaps = TRUE,fillcolor="rgba(173,216,230,0.5)", fill = 'tonexty' )
      fig1 <- add_trace(fig1, x=~year, y=~e_inc_100k,name='TB', legendgroup = "G1", mode = 'lines',line = list(color = 'rgb(0,0,255)'),showlegend = T,
                        hoverinfo='text', text=~paste('</br>Year: ',year,'</br>Infections: ',round(e_inc_100k)))
      fig1 <- add_trace(fig1, x=~year, y=~value,yaxis = "y2", name='GDP',legendgroup = "G2", mode = 'lines',line = list(color = 'rgb(255,0,0)'),showlegend = T,
                        hoverinfo='text', text=~paste('</br>Year: ',year,'</br>GDP: ',round(value)))
      fig1 <- fig1 %>%layout(title = "<b>TB infections & GDP per year</b>", yaxis2 = ay,
                             xaxis = list(title="<b>Year</b> ",tickangle = 315),
                             yaxis = list(title="<b>TB infection</b>"))
      
    }
    
  })
  output$plot2 <- renderPlot({
    if (input$Group == "Country"){
      who_region<-unique(TB_burd[TB_burd$country%in%input$select_country,c('g_whoregion')])
      data<-TB_burd[TB_burd$g_whoregion%in%who_region,]
      data$year<-as.factor(data$year)
      fig<-ggplot(data, aes(x=year, y=e_inc_100k, fill=country)) +
        geom_bar(stat="identity", position=position_dodge())+
        scale_color_brewer(palette="Paired")+theme_prism()+labs(x = "Year",y='Incidences',title ="Incidences per 100000 population")+
        # scale_color_brewer(palette = 'Dark2')+
        theme(legend.position="bottom",
                      axis.text.x = element_text(angle = 45, vjust = 0.5, hjust=1),
              text = element_text(size=12))+
        guides(fill=guide_legend(nrow=5,byrow=TRUE))

      fig

    }
    else{
      
      data<-TB_burd[TB_burd$g_whoregion%in%input$group_id,]
      data$year<-as.factor(data$year)
      fig<-ggplot(data, aes(x=year, y=e_inc_100k, fill=country)) +
        geom_bar(stat="identity", position=position_dodge())+
        scale_color_brewer(palette="Paired")+theme_prism()+labs(x = "Year",y='Incidences',title ="Incidences per 100000 population")+
        # scale_color_brewer(palette = 'Dark2')+
        theme(legend.position="bottom",
              axis.text.x = element_text(angle = 45, vjust = 0.5, hjust=1))+
        guides(fill=guide_legend(nrow=5,byrow=TRUE))
      
      fig
      
    }

  })
  
  output$acf<-renderPlot({
    if (input$Group == "Country"){
      data<-TB_burd[TB_burd$country%in%input$select_country,c('year','e_inc_100k')]
      
      nd<-ts(data[,2],start = data$year[1],end=data$year[nrow(data)])
      acf(nd,main='')
    }
    else{
    who_dat<-TB_burd[,c('year','g_whoregion','e_inc_100k','e_inc_100k_lo','e_inc_100k_hi')]
      
      who_dat %>%
        group_by(g_whoregion, year) %>%
        summarise(e_inc_100k = sum(e_inc_100k),
                  e_inc_100k_lo = sum(e_inc_100k_lo),
                  e_inc_100k_hi = sum(e_inc_100k_hi)) ->who_dat
      
    data<-who_dat[who_dat$g_whoregion==input$group_id,c('year','e_inc_100k')]
      
      nd<-ts(data[,2],start = data$year[1],end=data$year[nrow(data)])
      acf(nd,main='')
    }
  })
  output$pacf<-renderPlot({
    if (input$Group == "Country"){
      data<-TB_burd[TB_burd$country%in%input$select_country,c('year','e_inc_100k')]
      
      nd<-ts(data[,2],start = data$year[1],end=data$year[nrow(data)])
      pacf(nd,main='')
    }
    else{
    who_dat<-TB_burd[,c('year','g_whoregion','e_inc_100k','e_inc_100k_lo','e_inc_100k_hi')]
      
      who_dat %>%
        group_by(g_whoregion, year) %>%
        summarise(e_inc_100k = sum(e_inc_100k),
                  e_inc_100k_lo = sum(e_inc_100k_lo),
                  e_inc_100k_hi = sum(e_inc_100k_hi)) ->who_dat
      
    data<-who_dat[who_dat$g_whoregion==input$group_id,c('year','e_inc_100k')]
      
      nd<-ts(data[,2],start = data$year[1],end=data$year[nrow(data)])
      pacf(nd,main='')
    }
  })
  
  output$plot3 <- renderPlot({
    if (input$Group == "Country"){
      data<-TB_burd[TB_burd$country%in%input$select_country,c('year','e_inc_100k')]
      fig<-forecast_plot(data,5)
      fig
      
    }
    else{
    who_dat<-TB_burd[,c('g_whoregion','year','e_inc_100k')]
      
      who_dat %>%
        group_by(g_whoregion, year) %>%
        summarise(e_inc_100k = sum(e_inc_100k)) ->who_dat
      
      data<-who_dat[who_dat$g_whoregion==input$group_id,c('year','e_inc_100k')]
      fig<-forecast_plot(data,5)
      fig
      
      
    }
    
  })
  
  output$plot4 <- renderPlot({
    if (input$Group == "Country"){
      data<-TB_not[TB_not$country%in%input$select_country,c('year','c_newinc')]
      fig<-forecast_plot(data,5)
      fig<-fig+labs(x = "Year",y='New Incidences')
      fig
                
    }
  })
  
  


  
}
)
