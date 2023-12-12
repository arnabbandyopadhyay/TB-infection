
library('forecast')
path<-getwd()
files<-list.files('./','*.rda')
for (i in 1:length(files)){
  
  data<-load(files[i])
  name<-strsplit(files[i],split='.',fixed=T)[[1]][1]
  write.csv(get(data),file=paste0(name,'.csv'))
}

gdp<-sdg[sdg$indicator.id%in%c('NY.GDP.PCAP.PP.KD'),]

who_dic<-read.csv('TB_data_dictionary_2023-12-08.csv',sep=',')
TB_burd<-read.csv('TB_burden_countries_2023-12-08.csv',sep=',')
TB_burd_age<-read.csv('TB_burden_age_sex_2023-12-08.csv',sep=',')
TB_notification<-read.csv('TB_notifications_2023-12-08.csv',sep=',')

country<-'Afghanistan'

data<-TB_burd[TB_burd$country%in%country,c('year','e_inc_100k')]

nd<-ts(data[,2],start = data$year[1],end=data$year[nrow(data)])

ts.plot(nd, xlab="year", ylab='Number')
abline(reg=lm(nd~time(nd)))
acf(nd)


AR <- arima(nd, order = c(1,1,1))
print(AR)

ts.plot(nd)
AR_fit <- nd - residuals(AR)
points(AR_fit, type = "l", col = 2, lty = 2)

predict(AR, n.ahead = 10)






ts.plot(nd, xlim = c(2000, 2050))
AR_fit <- nd - residuals(AR)
points(AR_fit, type = "l", col = 2, lty = 2)
AR_forecast <- predict(AR, n.ahead = 5)$pred
AR_forecast_se <- predict(AR, n.ahead = 5)$se
points(AR_forecast, type = "l", col = 2)
points(AR_forecast - 2*AR_forecast_se, type = "l", col = 2, lty = 2)
points(AR_forecast + 2*AR_forecast_se, type = "l", col = 2, lty = 2)

who_dat<-TB_burd[,c('year','g_whoregion','e_inc_100k','e_inc_100k_lo','e_inc_100k_hi')]

who_dat %>% 
  group_by(g_whoregion, year) %>% 
  summarise(e_inc_100k = sum(e_inc_100k),
            e_inc_100k_lo = sum(e_inc_100k_lo),
            e_inc_100k_hi = sum(e_inc_100k_hi)) ->new_dat











acf(nd)


MA_1 <- arima.sim(model = list(ma = 0.5), n = 200)
# Simulate AutoRegressive model with 0.8 slope
MA_2 <- arima.sim(model = list(ma = 0.9), n = 200)
# Simulate AutoRegressive model with -0.6 slope
MA_3 <- arima.sim(model = list(ma = -0.6), n = 200)
plot.ts(cbind(MA_1 , MA_2, MA_3 ), main="MA Model Simulated Data")
