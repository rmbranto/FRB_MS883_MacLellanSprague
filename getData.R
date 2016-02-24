# RMBranton Feb 2016 
# process Maclellan_Sprague(1966) data

#install.packages("XLConnect")
library(XLConnect)
#install.packages("plyr")
library(plyr)

source('functions.r')

wb<-loadWorkbook(
  "occurrences_MacLellanSprague_v2.xlsx"
)

lz.counts<-NULL

for (sheet.name in getSheets(wb)[3:6]){
  cat(paste('processing:',sheet.name),'\n')
  lz.counts<-rbind(lz.counts,get.lz(sheet.name))  
}

lz.counts<-rename(lz.counts,c('sheet'='year','observation'='count'))
lz.counts$year[lz.counts$year=='Table I'|lz.counts$year=='Table III']<-'1959'
lz.counts$year[lz.counts$year=='Table II'|lz.counts$year=='Table IV']<-'1961'

lz.wgts<-NULL

for (sheet.name in getSheets(wb)[7:10]){
  cat(paste('processing:',sheet.name),'\n')
  lz.wgts<-rbind(lz.wgts,get.lz(sheet.name))  
}

lz.wgts<-rename(lz.wgts,c('sheet'='year','observation'='wgt'))
lz.wgts$year[lz.wgts$year=='Table V'|lz.wgts$year=='Table VII']<-'1959'
lz.wgts$year[lz.wgts$year=='Table VI'|lz.wgts$year=='Table VIII']<-'1961'

lz.shells<-NULL

for (sheet.name in getSheets(wb)[12]){
  cat(paste('processing:',sheet.name),'\n')
  lz.shells<-rbind(lz.shells,get.lz(sheet.name))  
}

lz.shells<-rename(lz.shells,c('sheet'='year','observation'='shells'))
lz.shells$year<-'1961'

# create and sort dataframe of unique: year, station, sample, taxa
lz.all<-unique(rbind(lz.counts[,1:4],lz.wgts[,1:4],lz.shells[,1:4]))
lz.all<-lz.all[order(lz.all$year,lz.all$station,lz.all$sample,lz.all$taxa),]

# merge data and depth 
lz.all<-merge(
  x=lz.all,
  y=rbind(
    get.dates('Table XII'),
    get.dates('Table XIII')),
  by=c('year','station','sample'),
  all.x=T)

# merge with counts
lz.all<-merge(
    x=lz.all,
    y=lz.counts,
    by=c('year','station','sample','taxa'),
    all.x=T)

# merge with weights
lz.all<-merge(
  x=lz.all,
  y=lz.wgts,
  by=c('year','station','sample','taxa'),
  all.x=T)

# merge with shells
lz.all<-merge(
  x=lz.all,
  y=lz.shells,
  by=c('year','station','sample','taxa'),
  all.x=T)

lz.all$count[is.na(lz.all$count)]<-0
lz.all$wgt[is.na(lz.all$wgt)]<-0
lz.all$shells[is.na(lz.all$shells)]<-0

# merge with station locations
stations<-read.csv('stations.csv',as.is=T)
stations<-rename(stations,c('Name'='station'))

lz.final<-merge(
  x=lz.all,
  y=stations,
  by='station',
  all.x=T)

# merge with taxa list
wb.taxa<-loadWorkbook("occurrences_MacLellanSprague_v2.xlsx")
taxa<-readWorksheet(wb.taxa,sheet='WoRMS_Matched',header=T)

taxa<-rename(taxa,c('spnumber'='taxa'))
taxa$taxa<-gsub('*','',taxa$taxa,fixed=T)

lz.final<-merge(
  x=lz.final,
  y=taxa[,c('taxa','originalname','ScientificName_accepted','AphiaID_accepted')],
  by='taxa',
  all.x=T)

lz.final<-lz.final[,c(2,3,5,10,11,4,6,1,12:14,7:9)]

source('metadata.r')
lz.final<-merge(x=metadata,y=lz.final)

lz.final$WoRMSLink<-
  paste("http://www.marinespecies.org/aphia.php?p=taxdetails&id=",
        lz.final$AphiaID_accepted,
        sep='')

write.csv(lz.final,'occurrences.csv')
write.csv(lz.final,'occurrences_MaclellanSprague.csv')


