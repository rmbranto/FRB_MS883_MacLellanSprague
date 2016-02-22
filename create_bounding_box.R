# RMBranton Feb 2016 
# use stations to create bounding box

library(shapefiles)

# read station.csv and determine spatial extent
citation<-'Delphine C. Maclellan and J .B. Sprague, 1966,  Bottom fauna of Saint John Harbour and estuary as surveyed in 1959 and 1961. Fisheries Research Board Of Canada Manuscript Report Series (Biological), No. 883.'
stations<-read.csv('stations.csv',as.is=T)
xlim<-range(stations$longitude)
ylim<-range(stations$latitude)

# generate bounding box as shapefile

my.buf<-.01
dd<-data.frame(
  Id=rep(1,5),
  X=c(xlim[1]-my.buf,xlim[1]-my.buf,xlim[2]+my.buf,xlim[2]+my.buf,xlim[1]-my.buf),
  Y=c(ylim[1]-my.buf,ylim[2]+my.buf,ylim[2]+my.buf,ylim[1]-my.buf,ylim[1]-my.buf),
  stringsAsFactors=F)

ddTable<-data.frame(Id=1,comment=citation,stringsAsFactors=F)
ddShapefile <- convert.to.shapefile(dd, ddTable, 'Id', 5)
write.shapefile(ddShapefile, 'bBox', arcgis=T)
zip('bBox.zip',c('bBox.shp','bBox.shx','bBox.dbf'))

