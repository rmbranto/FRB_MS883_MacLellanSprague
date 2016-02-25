# R Branton, M Kennedy : Feb 2016
# write collection metadata that is same across all records 

metadata<-data.frame(
  modified='2016-02-24',
  institutionCode='Atlantic Biological Station',
  institutionID='EDMO 4161',
  CollectionCode='FRB Manuscript report series (biological) No.883',
  RightsHolder='Her Majesty the Queen in right of Canada, as represented by the Minister of Fisheries and Oceans',
  License='http://creativecommons.org/licenses/by/4.0/legalcode',
  DatasetID='FRB_MS883_MacLellanSprague',
  DatasetName='FRB: Bottom fauna of Saint John Harbour and estuary as surveyed in 1959 and 1961',
  type='Event',
  language='En',
  AssociatedReferences='MacLelland, D.C. and J.B. Sprague. 1966. Bottom fauna of Saint John Harbour and estuary as surveyed in 1959 and 1961. Fish. Res. Bd. Canada, St. Andrews Biological Station. MS Rept. 883, 24 p.',
  RecordedBY='MacLelland, D.C. and J.B. Sprague',
  BasisOfRecord='HumanObservation',
  OrganismQuantityType='individuals',
  SamplingProtocol='Vessel held on station and benthic sample collected using a van Veen sampler (nominal sampling area of 0.1 sq. metres)',
  sampleSizeValue='0.1',
  sampleSizeUnit='square metre',
  Habitat='benthic',
  occurrenceStatus='present',
  country='Canada',
  stateProvince='New Brunswick',
  verbatimLocality='Saint John Harbour and estuary',
  geodeticDatum='WGS84',
  ContinentOcean='Atlantic',
  GeoreferenceProtocol='OBIS Canada Georeference Guidelines',
  georeferencedBy='Robert Branton (OBIS Canada)',
  georeferencedDate='2016-02-18',
  georeferenceSources='FRB report|GoogleEarth',
  georeferenceremarks='Coordinates assigned using Google earth referencing map figure in publication and station location description described in publication table',
  georeferenceVerificationStatus='verified by OBIS Canada data management team',
  IdentifiedBy='FRB (Delphine C. Maclellan)',
  stringsAsFactors = F)
    
write.csv(metadata,file='metadata,csv',na='')
