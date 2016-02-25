# R Branton, M Kennedy : Feb 2016
# write DwC formatted ipt records as combination of collection metadata and records

z<-lz.final
  
ipt<-data.frame(
  metadata,
  eventDate=z$date,
  CatalogNumber=paste(z$year,z$station,z$date,z$sample,z$taxa, sep="_"),
  OccurrenceID<-paste(metadata$DatasetID,z$year,z$station,z$date,z$sample,z$taxa, sep="_"),
  EventID<-paste(z$year,z$station,z$date, sep="_"),
  FieldNumber<-paste(z$date,z$station,z$sample, sep=""),
  VerbatimDepth=z$depth,
  DecimalLatitude=z$latitude,
  DecimalLongitude=z$longitude,
  scientificName=z$ScientificName_accepted,
  ScientificNameAuthorship=z$Authority_accepted,
  OrganismQuantity=z$count,
  kingdom=z$Kingdom,
  phylum=z$Phylum,
  class=z$Class,
  order=z$Order,
  family=z$Family,
  genus=z$Genus,
  subgenus=z$Subgenus,
  SpecificEpithet=z$Species,
  InfraSpecificEpithet=z$Subspecies,
  taxonRemarks=z$Taxon.remarks,
  stringsAsFactors = F
  )

write.csv(ipt,'ipt.csv',na='')