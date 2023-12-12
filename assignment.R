path<-getwd()
files<-list.files('./','*.rda')
for (i in 1:length(files)){
  
  data<-load(files[i])
  name<-strsplit(files[i],split='.',fixed=T)[[1]][1]
  write.csv(get(data),file=paste0(name,'.csv'))
}
