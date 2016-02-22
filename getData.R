# RMBranton Feb 2016 
# process Maclellan_Sprague(1966) data

library(XLConnect)
library('reshape2')
library(plyr)

get.lz<-function(sheet.name){

# read specified sheet from workbook 
z<-readWorksheet(
  wb,
  sheet=sheet.name,
  header=F)

# transpose input data table, so taxa appear as columns
z<-data.frame(
  t(z),                  
  stringsAsFactors=F
  )

# get column names from row 1
colnames(z)<-
  as.vector(z[1,])

# exclude first and last rows and last coulmn       
nrows<-dim(z)[1]
ncols<-dim(z)[2]
z<-z[                     
  c(-1,-1*nrows),
  -1*ncols                
  ]

# create long form table: "station" "sample" "taxa" "observation"  
lz<-melt(                 
  z,
  id.vars=c(1:2),
  measures.vars=(3:(dim(z)[2]-1)), 
  variable.name='taxa',
  value.name='observation',na.rm=T)

# add sheet.name to lz
data.frame(
  sheet=rep(sheet.name,dim(lz)[1]),
  lz,
  stringsAsFactors=F)
}

get.dates<-function(sheet.name){
  
  # read specified sheet from workbook 
  z<-readWorksheet(
    wb,
    sheet=sheet.name,
    header=F)
  
  # transpose input data table, so taxa appear as columns
  z<-data.frame(
    t(z),                  
    stringsAsFactors=F
  )
  
  # get column names from row 1
  colnames(z)<-
    as.vector(z[1,])
  
  # exclude first row   
  z<-z[-1,]
  
  # change 
  z$date<-as.Date(z$date,format='%d-%m-%Y')
  
  data.frame(year=substr(z$date,1,4),z,stringsAsFactors=F)
}

wb<-loadWorkbook(
  "occurrences.xlsx"
)

lz.counts<-NULL

for (sheet.name in getSheets(wb)[2:5]){
  cat(paste('processing:',sheet.name),'\n')
  lz.counts<-rbind(lz.counts,get.lz(sheet.name))  
}

lz.counts<-rename(lz.counts,c('sheet'='year','observation'='count'))
lz.counts$year[lz.counts$year=='Table I'|lz.counts$year=='Table III']<-'1959'
lz.counts$year[lz.counts$year=='Table II'|lz.counts$year=='Table IV']<-'1961'

lz.wgts<-NULL

for (sheet.name in getSheets(wb)[6:9]){
  cat(paste('processing:',sheet.name),'\n')
  lz.wgts<-rbind(lz.wgts,get.lz(sheet.name))  
}

lz.wgts<-rename(lz.wgts,c('sheet'='year','observation'='wgt'))
lz.wgts$year[lz.wgts$year=='Table V'|lz.wgts$year=='Table VII']<-'1959'
lz.wgts$year[lz.wgts$year=='Table VI'|lz.wgts$year=='Table VIII']<-'1961'

lz.shells<-NULL

for (sheet.name in getSheets(wb)[10]){
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
wb.taxa<-loadWorkbook("matched_taxa.xlsx")
taxa<-readWorksheet(wb.taxa,sheet=1,header=T)

lz.final<-merge(
  x=lz.final,
  y=taxa[,c('taxa','Original.Names','ScientificName_accepted')],
  by='taxa',
  all.x=T)

lz.final<-lz.final[,c(2,3,5,10,11,4,6,1,12,13,7:9)]

write.csv(lz.final,'occurrences.csv')


