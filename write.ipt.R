# R Branton, M Kennedy : Feb 2016
# write DwC formatted ipt records as combination of collection metadata and records

z<-wz
#z<-lz.final

ipt<-data.frame(
  metadata,
  eventDate=z$date,
  year=substr(z$date,1,4),
  month=substr(z$date,6,7),
  day=substr(z$date,9,10),
  CatalogNumber=paste(z$year,z$station,z$date,z$sample,z$spnumber, sep="_"),
  OccurrenceID=paste(metadata$DatasetID,z$year,z$station,z$date,z$sample,z$spnumber, sep="_"),
  EventID=paste(z$year,z$station,z$date, sep="_"),
  FieldNumber=paste(z$date,z$station,z$sample, sep=""),
  verbatimDepth=z$depth,
  MinimumDepthInMeters=min(as.numeric(z$depth),na.rm=T),
  MaximumDepthInMeters=max(as.numeric(z$depth),na.rm=T),
  verbatimlocation=z$VerbatimLocation,
  locality=z$Locality,
  locaionID=z$station,
  locationAccordingTo=z$georeferenceSources,
  locationRemarks=z$georeferenceremarks,
  DecimalLatitude=z$latitude,
  DecimalLongitude=z$longitude, 
  occurrenceStatus=ifelse(z$count==0,'absent','present'),
  scientificName=z$ScientificName_accepted,
  ScientificNameID=z$AphiaID_accepted,
  ScientificNameAuthorship=z$Authority_accepted,
  identificationQualifier=z$Taxon_remarks,
  OrganismQuantity=z$count,
  taxonRank=taxonRank(),
  kingdom=z$Kingdom,
  phylum=z$Phylum,
  class=z$Class,
  order=z$Order,
  family=z$Family,
  genus=z$Genus,
  subgenus=z$Subgenus,
  SpecificEpithet=z$Species,
  InfraSpecificEpithet=z$Subspecies,
  taxonRemarks=z$Taxon_remarks,
  stringsAsFactors = F
  )

# only write 'ipt.csv' if the  occurenceID and CatalogNumber are unique

cat( ifelse(dim(ipt)[1]!=length(unique(ipt$CatalogNumber)),'**Warning** CatalogNumber not unique!','CatalogNumber is unique.'),'\n')
cat( ifelse(dim(ipt)[1]!=length(unique(ipt$OccurrenceID)),'**Warning** OccurrenceID not unique!','OccurrenceID is unique.'),'\n')

if(dim(ipt)[1]==length(unique(ipt$CatalogNumber))&dim(ipt)[1]==length(unique(ipt$OccurrenceID))){
  cat('**Success** ipt.csv file is being created.\n')
  write.csv(ipt,'ipt.csv',na='')
  zip('ipt.zip',c('ipt.csv'))
}else{
  cat('**Failure** ipt.csv file is being deleted!!')
  system('rm ipt.csv')
}
