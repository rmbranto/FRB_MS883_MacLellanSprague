# RMBranton Feb 2016 
# process Maclellan_Sprague(1966) data

#install.packages("XLConnect")
library(XLConnect)
#install.packages("plyr")
library(plyr)

source('functions2.r')

get.wz<-function(
  worksheet,
  data.sheets=c(1:8,10),
  data.transpose=TRUE,
  data.exclude.totals=TRUE,
  data.num.ids=4,
  data.var.name='spnumber',
  sta.sheets=c(12,13),
  sta.transpose=TRUE,
  sta.date.format='%d-%m-%Y'){

wb<-loadWorkbook(worksheet)

# get sation data
cat('\n getting stations data from tables ...\n')

lz.sta<-NULL
for (sheet.name in getSheets(wb)[sta.sheets]){
  lz.sta<-rbind(lz.sta,get.sta.lz(wb,sheet.name,sta.transpose,sta.date.format))  
}

# merge station data with location metadata

lz.sta<-
  merge(
    x=lz.sta,
    y=readWorksheet(wb,sheet='Locations',header=T)[,c(2,3,4,5,12,15,16,17)],
    by='station')

# get sample data
cat('\n getting samples data from tables ...\n')

lz.data<-NULL
for (sheet.name in getSheets(wb)[data.sheets]){
  lz.data<-rbind(lz.data,get.data.lz(wb,sheet.name,data.transpose,data.exclude.totals,data.num.ids,data.var.name))  
}

# merge station data with sample data

wz<-merge(
  x=lz.sta,
  y=dcast(lz.data,year+station+sample+spnumber~observation,fun.aggregate=sum),
  by=c('year','station','sample')
  )

# get taxa list and merge with sampling data

taxa<-readWorksheet(wb,sheet='WoRMS_Matched',header=T)
taxa$spnumber<-gsub('*','',taxa$spnumber,fixed=T)
wz<-merge(x=wz,y=taxa,by='spnumber')

source('metadata.r')
wz<-merge(x=metadata,y=wz)

#lz.final$WoRMSLink<-
#  paste("http://www.marinespecies.org/aphia.php?p=taxdetails&id=",
#        lz.final$AphiaID_accepted,
#        sep='')

source('write.ipt.R')
extents()
}

