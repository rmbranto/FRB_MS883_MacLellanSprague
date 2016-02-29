# R Branton Feb 2016
# normalize (i.e melt) McLelland spreadsheet tables

#install.packages("XLConnect")
library(XLConnect)
#install.packages("reshape2")
library('reshape2')

get.data.lz<-function(
  wb,
  sheet.name,
  transpose=TRUE,
  exclude.totals=TRUE,
  num.ids=4,
  var.name='spnumber',
  ...){

cat(sheet.name,'\n')
  
# read specified sheet from workbook 
z<-readWorksheet(
  wb,
  sheet=sheet.name,
  header=F)

if(transpose){  
# transpose input data table, so taxa appear as columns
  z<-data.frame(
    t(z),                  
    stringsAsFactors=F
  )
  
# get column names from row 1
  colnames(z)<-
    as.vector(z[1,])
  z<-z[-1,]
}

if(exclude.totals){
# exclude last row and last coulmn       
  z<-z[                     
    -1*dim(z)[1],
    -1*dim(z)[2]               
    ]
}
  
# create long form table (i.e normalize) : "station" "sample" "taxa" "observation"  
  lz<-melt(                 
    z,
    id.vars=c(1:num.ids),
    measures.vars=((num.ids+1):(dim(z)[2]-1)), 
    variable.name=var.name,
    value.name='value',
    na.rm=T)

lz$value<-as.numeric(lz$value)
      
# add sheet.name to lz
  data.frame(
    sheet=rep(sheet.name,dim(lz)[1]),
    lz,
    stringsAsFactors=F)
}

get.sta.lz<-function(
  wb,
  sheet.name,
  transpose=TRUE,
  date.format='%d-%m-%Y',
  ...
){

# get and process station metadata
cat(sheet.name,'\n') 
  
# read specified sheet from workbook 
  z<-readWorksheet(
    wb,
    sheet=sheet.name,
    header=F)
  
# transpose input data table, so taxa appear as columns
if(transpose){
  z<-data.frame(t(z),stringsAsFactors=F)
  # get column names from row 1
  colnames(z)<-as.vector(z[1,])
  # exclude first row   
  z<-z[-1,]
}  
z$date<-as.Date(z$date,format=date.format)
data.frame(z[,-1],row.names=NULL,stringsAsFactors=F)
}

taxonRank<-function(z=wz){
  ifelse(!is.na(z$Species),'species',
         ifelse(!is.na(z$Genus),'genus',
                ifelse(!is.na(z$Family),'family',
                       ifelse(!is.na(z$Class),'class',
                              ifelse(!is.na(z$Phylum),'phylum',
                                     ifelse(!is.na(z$Kingdom),'kingdom','unknown'))))))
  
}

extents<-function(z=ipt){
  cat('temporal extent=',range(z$eventDate),'\n')
  cat('spatial extent= longitude=',range(z$DecimalLongitude ),'\n')
  cat('spatial extent= latitude=',range(z$DecimalLatitude),'\n')
  cat('depth range =',range(as.numeric(z$verbatimDepth),na.rm=T),'\n')
  cat('taxanomic extent: kingdom =',names(table(z$kingdom)),'\n')
  cat('taxanomic extent= phylum=',names(table(z$phylum)),'\n')
  cat('taxanomic extent= class=',names(table(z$class)),'\n')
  cat('taxanomic extent= order=',names(table(z$order)),'\n')
  cat('taxanomic extent= genus=',names(table(z$genus)),'\n')
  cat('taxanomic extent= species=',names(table(z$species)),'\n')
}

# table(taxonRank(unique(wz[,c('Kingdom','Phylum','Class','Order','Family','Genus','Species')])))
