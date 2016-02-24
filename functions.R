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
