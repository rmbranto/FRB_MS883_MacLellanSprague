# R Branton, M Kennedy : Feb 2016
# write collection metadata 
write.csv(
  com<-data.frame(
    CollectionCode='FRB Manuscript report series (biological) No.883',
    Citation='Delphine C. Maclellan and J .B. Sprague, 1966,  Bottom fauna of Saint John Harbour and estuary as surveyed in 1959 and 1961. Fisheries Research Board Of Canada Manuscript Report Series (Biological), No. 883.',
    Type='Event',
    Modified='2016-02-24',
    institutionCode='Atlantic Biological Station',
    institutionID='EDMO 4161',
    DatasetID='FRB_MS883_MacLellanSprague',
    DatasetName='FRB: Bottom fauna of Saint John Harbour and estuary as surveyed in 1959 and 1961',
    Rights='http://data.gc.ca/eng/open-government-licence-canada',
    RightsHolder='Her Majesty the Queen in right of Canada, as represented by the Minister of Fisheries and Oceans',
    License='http://creativecommons.org/licenses/by/4.0/legalcode',
    language='En',
    AssociatedReferences='MacLelland, D.C. and J.B. Sprague. 1966. Bottom fauna of Saint John Harbour and estuary as surveyed in 1959 and 1961. Fish. Res. Bd. Canada, St. Andrews Biological Station. MS Rept. 883, 24 p.',
    RecordedBY='MacLelland, D.C. and J.B. Sprague',
    BasisOfRecord='HumanObservation',
    georeferencedBy='OBIS Canada data management team (Bob Branton)',
    georeferencedDate='2016-02-18',
    georeferenceSources='FRB report and GoogleEarth',
    georeferenceremarks='Coordinates assigned using Google earth referencing map figure in publication and station location description described in publication table',
    IdentifiedBy='FRB (Delphine C. Maclellan)',
    ContinentOcean='Atlantic',
    OrganismScope='individuals',
    IdentifiedBy='DFO-NAFC',
    OrganismQuantityType='preserved specimens',
    stringsAsFactors=F),
  'metadata.csv'
)
metadata<-read.csv('metadata.csv',header=T,as.is=T)
