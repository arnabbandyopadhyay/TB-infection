library('RCurl')

library('shiny')
library('shinycssloaders')
library('shinyWidgets')
library('plotly')
library('forecast')
library('stringi')
library('tibble')
library('dplyr')
#library(gganimate)
library('gifski')
library('ggprism')
library('timetk')

wd<-getwd()


# who_urls<-c("https://extranet.who.int/tme/generateCSV.asp?ds=estimates",
# "https://extranet.who.int/tme/generateCSV.asp?ds=estimates_age_sex",
# "https://extranet.who.int/tme/generateCSV.asp?ds=notifications")
# 
# file_names<-c('TB_burden_countries_estimates.csv','TB_burden_age_sex.csv','TB_notification.csv')
# 
# get_url<-function(x){
# k<-url.exists(who_urls[x],.header=FALSE)
# if (k==TRUE){
# download.file(who_urls[x],file_names[x],method = "wget")
# }
# }
# 
# 
# sapply(1:length(who_urls), get_url)
# 

load('data/gtb/snapshot_2023-07-21/tb.rda')
load('data/gtb/other/sdg.rda')
load('data/gtb/other/sdgdef.rda')
TB_burd<-read.csv(list.files('./','TB_burden_countries_*'),sep=',')
TB_burd$g_whoregion <- stri_replace_all_regex(TB_burd$g_whoregion,
                                              pattern=c('AFR', 'AMR', 'EMR','EUR','SEA','WPR'),
                                              replacement=c('Africa', 'Americas', 'Eastern Mediterranian',
                                                            'Europe','South-East Asia','Western Pacific'),
                                              vectorize=FALSE)
                                              
TB_not<-read.csv(list.files('./','TB_notifica*'),sep=',')


# mapdata <- map_data("world") ##ggplot2
# tb_dat<-TB_burd[,c('year','country','e_inc_100k')]
# colnames(tb_dat)[2]<-'region'
# mapdata <- left_join(tb_dat,mapdata, by=c("region"))
# 
# mapdata<-mapdata %>% filter(!is.na(mapdata$e_inc_100k))
# 
# yrs<-unique(mapdata$year)
# 
# 
# for (i in 1:length(yrs)){
#   mapdata1<-mapdata[mapdata$year%in%yrs[i],]
#   map1<-ggplot(mapdata1, aes( x = long, y = lat,group=group)) +
#     geom_polygon(aes(fill = e_inc_100k), color = "black")
# 
#   map2 <- map1 +
#     # scale_colour_gradient(limits=c(0,200),breaks = round(seq(0,200,length.out = 4),1))+
#     # guides(colour = guide_colorbar(draw.ulim = FALSE,draw.llim = FALSE))+
#     scale_fill_gradient(name = "TB infection", low = "green", high =  "red",na.value = "white")+
#     ggtitle(paste0(yrs[i])) +
#     theme(plot.title = element_text(hjust = 1, vjust = -10))
#     theme(axis.text.x = element_blank(),
#           axis.text.y = element_blank(),
#           axis.ticks = element_blank(),
#           axis.title.y=element_blank(),
#           axis.title.x=element_blank(),
#           rect = element_blank())
# ggsave(path='www',filename = paste0('image_',yrs[i],".png"), plot=map2,width=8,height=4,units="in",scale=1)
# }
# 
# img<-list.files('www/','*.png')
# setwd('www')
# gifski(img, gif_file = "animation.gif", width = 1200, height = 600, delay = 0.5)
# setwd(wd)






# who_dat<-TB_burd[,c('g_whoregion','year','e_inc_100k')]
# 
# who_dat %>%
#   group_by(g_whoregion, year) %>%
#   summarise(e_inc_100k = sum(e_inc_100k)) ->who_dat
# 
# data<-who_dat[who_dat$g_whoregion=='Eastern Mediterranian',c('year','e_inc_100k')]
# 
# nd<-ts(data[,2],start = data$year[1],end=data$year[nrow(data)])
# 


# 

forecast_plot<-function(data, points){
  nd<-ts(unlist(data[,2],use.names = FALSE),start = data$year[1],end=data$year[nrow(data)])
  fit=auto.arima(nd,approximation=T, trace=FALSE, allowdrift=F)
  forecast = forecast(fit, h=points, level=95)
  AR_fit <- nd - residuals(fit)
  # points(AR_fit, type = "l", col = 2, lty = 2)
  pd_fit<-data.frame(Y=as.matrix(AR_fit), index=time(AR_fit))
  
  fc_df <- forecast |> 
    as_tibble() |> 
    mutate(index = seq(2023,(2023+points-1)))
  
  nd |> 
    tk_tbl() |> 
    bind_rows(fc_df) |> 
    ggplot(aes(index, value)) +
    geom_line() +
    geom_point(shape = 21) +
    geom_ribbon(aes(ymin = `Lo 95`, ymax = `Hi 95`), fill = "seagreen",alpha=0.3) +
    geom_point(aes(y = `Point Forecast`), colour = "blue") +labs(x = "Year",y='Incidences')+
    geom_point(data=pd_fit, aes(y = `Y`), colour = "blue") +labs(x = "Year",y='Incidences')+
    labs(title = "Forecast (95%) next 5 years")+theme_prism()+
    theme(plot.title = element_text(hjust = 0.5))->fig
  
  return(fig)
  
}




