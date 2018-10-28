library(methods)
library(bitops)
#install.packages("RCurl")
library(RCurl)
library(plyr)

# args: foiId sensorSystem e.g. SCWM68C63A809492 apri-sensor-bme280 or SCWM68C63A809492 apri-sensor-pmsa003
args <- commandArgs(trailingOnly = TRUE)
print(args)
print(args[1])
print(args[2])

foiId<-args[1]  #"SCWM68C63A809492"
sensorSystem<-args[2]  # e.g. apri-sensor-bme280 or apri-sensor-pmsa003
foiIn<-paste(sensorSystem,"_",foiId,sep='')
#foiInBme280<-paste("apri-sensor-bme280_",foiId,sep='')

endDate<-as.POSIXct(format(Sys.time(), "%Y%m%d%H"), format="%Y%m%d%H")
persistDate<-endDate  # persist on hour as result from previous 60 minutes
startDate<-endDate-3600
endDate<-endDate-1  # HH:59:59
#startDateStr<-format(startDate,"%Y-%m-%dT%H:%M:%S%z")
#endDateStr<-format(endDate,"%Y-%m-%dT%H:%M:%S%z")
startDateStr<-paste(format(startDate,"%Y-%m-%dT%H:%M:%S",tz='UTC'),'.000Z',sep='')
endDateStr<-paste(format(endDate,"%Y-%m-%dT%H:%M:%S",tz='UTC'),'.000Z',sep='')
persistDateStr<-paste(format(persistDate,"%Y-%m-%dT%H:%M:%S",tz='UTC'),'.000Z',sep='')

urlSensor<-paste("https://openiod.org/SCAPE604/openiod?SERVICE=WPS&REQUEST=Execute&identifier=transform_observation&action=getobservation"
,"&sensorsystem=",sensorSystem  #"apri-sensor-pmsa003"
, "&date_start=",startDateStr,"&date_end=",endDateStr
, "&foi=",foiIn
, "&offering=offering_0439_initial&format=csv",sep="");
dfIn <- read.csv(urlSensor, header = FALSE, sep = ";", quote = "\"")
#sensorType<-pmsA003$V3
#sensorvalue<-pmsA003$V6

means<-aggregate(data=dfIn,V6~V3, FUN=mean)

observation<-''
for (i in c(1:nrow(means))) {
  observation<-paste(observation,means$V3[i],':',round(means$V6[i],2),sep='')
  if(i<nrow(means)) observation<-paste(observation,',',sep='')
}

#foiOut<-paste(foiInPmsa003,'H',sep='')
foiOut<-paste(foiId,'H',sep='')
urlOut<-'https://openiod.org/SCAPE604/openiod?SERVICE=WPS&REQUEST=Execute&identifier=transform_observation&action=insertom&offering=offering_0439_initial&commit=true';
urlOut <- paste(urlOut,'&sensorsystem=',sensorSystem,'&foi=',foiOut,'&observation=',observation,'&measurementTime=',persistDateStr,sep='');
urlOut

myfile <- getURL(urlOut, ssl.verifyhost=FALSE, ssl.verifypeer=FALSE)
myfile

## BME280
#urlSensor<-paste("https://openiod.org/SCAPE604/openiod?SERVICE=WPS&REQUEST=Execute&identifier=transform_observation&action=getobservation"
#                 ,"&sensorsystem=apri-sensor-bme280"
#                 , "&date_start=",startDateStr,"&date_end=",endDateStr
#                 , "&foi=",foiInBme280
#                 , "&offering=offering_0439_initial&format=csv",sep="");
#bme280 <- read.csv(urlSensor, header = FALSE, sep = ";", quote = "\"")
##sensorType<-pmsA003$V3
##sensorvalue<-pmsA003$V6

#means<-aggregate(data=bme280,V6~V3, FUN=mean)

#observation<-''
#for (i in c(1:nrow(means))) {
#  observation<-paste(observation,means$V3[i],':',round(means$V6[i],2),sep='')
#  if(i<nrow(means)) observation<-paste(observation,',',sep='')
#}

#foiOut<-paste(foiInBme280,'H',sep='')
#foiOut<-paste(foiId,'H',sep='')
#urlOut<-'https://openiod.org/SCAPE604/openiod?SERVICE=WPS&REQUEST=Execute&identifier=transform_observation&action=insertom&sensorsystem=apri-sensor-bme280&offering=offering_0439_initial&commit=true';
#urlOut <- paste(urlOut,'&foi=',foiOut,'&observation=',observation,'&measurementTime=',persistDateStr,sep='');
#urlOut

#myfile <- getURL(urlOut, ssl.verifyhost=FALSE, ssl.verifypeer=FALSE)
#myfile



#quit(save = "no",status = 0)
