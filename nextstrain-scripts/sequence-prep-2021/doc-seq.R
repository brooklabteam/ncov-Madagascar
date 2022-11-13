rm(list=ls())

library(ggplot2)
library(seqinr)
library(sf)
library(plyr)
library(dplyr)

homewd = "/Users/carabrook/Developer/ncov/"

#load the subsampled metadata
dat <- read.delim(file = paste0(homewd, "sequence-prep/subsampled_metadata_gisaid.tsv"), header = T)
head(dat) #3703 sequences in total
nrow(dat[dat$region=="Africa" & dat$country!="Madagascar",]) #1000
nrow(dat[dat$region=="Europe",]) #1000
nrow(dat[dat$region!="Europe" & dat$region!="Africa",]) #911
nrow(dat[dat$country=="Madagascar",]) #792. Excellent! They are all there
unique(dat$region[dat$country=="Madagascar"]) #Africa. Good.
dat$location[dat$country=="Madagascar"]

dat$date <- as.Date(dat$date)

#check min and max
min(dat$date) #"2019-12-30"
max(dat$date) # "2021-07-18"
min(dat$date[dat$country=="Madagascar"]) #"2020-03-20"
max(dat$date[dat$country=="Madagascar"]) #"2021-07-18"

#now overwrite the madagascar location data with better data
#and for the other localities, just source these as country-level info
dat.det <- read.delim(file = paste0(homewd, "sequence-prep/full_meta_madagascar.tsv"), header = T)
head(dat.det)

dat.det <- dplyr::select(dat.det, accession_id, province, division, location)
names(dat.det)[names(dat.det)=="accession_id"] <- "gisaid_epi_isl"

dat <- dplyr::select(dat, -(division), -(location))

dat <- merge(dat, dat.det, by = "gisaid_epi_isl", all.x = T, sort = F)
head(dat)
sort(unique(dat$country[is.na(dat$location)])) #all countries except Mada
sort(unique(dat$country[is.na(dat$division)])) 


#replace with country-info
dat$location[is.na(dat$location)] <- dat$country[is.na(dat$location)] 
dat$division[is.na(dat$division)] <- dat$country[is.na(dat$division)] 
dat$division[dat$division=="Madagascar" & dat$location=="Toamasina-I"] <- "Atsinanana"
dat$division[dat$division=="Madagascar" & dat$location=="Antananarivo-Renivohitra"] <- "Analamanga"
dat$division[dat$division=="Aloatra-Mangoro"] <- "Alaotra-Mangoro"
dat$division[dat$division=="Fenoarivo"] <- "Analamanga"
dat$division[dat$division=="Amoron’i-Mania"] <- "Amoron'i-Mania"


#and compare location names with your lat-long data
district.dat <- read.delim(file = paste0(homewd, "defaults/lat_longs.tsv"), header = F, stringsAsFactors = F)
head(district.dat)
#there will be lots of lat long from other regions
#but you should make sure all the madagascar locations correspond to 
#lat/long locations

setdiff(dat$location, district.dat$V2[district.dat$V1=="location"])#0. perfect
setdiff(dat$division, district.dat$V2[district.dat$V1=="division"])#0. perfect

unique(dat$location) #perfect! all represented

#and save new version of the data to the data folder to run the build
write.table(dat, file = paste0(homewd, "data/subsampled_metadata_gisaid_edit.tsv"), quote=FALSE, sep='\t', row.names = F)
