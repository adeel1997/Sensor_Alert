## Loading relevant packages
library(slackr)
library(AirSensor)
library(MazamaSpatialUtils)
library(lubridate)
library(dplyr)

## Loading Spatial data 
## More details on Air Sensor Git hub page if it's not setup already
initializeMazamaSpatialUtils("/home/ubuntu/Git/Sensor_Alert/Spatial_data")

## Settng the Country Code API link and look back days 
pas <- pas_createNew(countryCodes = "IN",
                     baseUrl = 'https://www.purpleair.com/json?all=true',lookbackDays = 30,
                     includePWFSL = F)
## Changing the time zone to Asia/Kolkata
pas$lastSeenDate <- with_tz(pas$lastSeenDate,tz="Asia/Kolkata")



SAMOSA_pas = pas%>% pas_filter(!grepl("B",label),grepl("SAMOSA",label),
                                (!grepl ("SAMOSA_0001",label)),(!grepl ("SAMOSA_0002",label)),(!grepl ("SAMOSA_0005",label)),(!grepl ("SAMOSA_0006",label)),(!grepl ("SAMOSA_0007",label)), (!grepl ("SAMOSA_0008",label)),(!grepl ("SAMOSA_0009",label)), 
                               (!grepl ("SAMOSA_0012",label)),(!grepl ("SAMOSA_0014",label)),(!grepl ("SAMOSA_0019",label)),(!grepl ("SAMOSA_0026",label)),(!grepl ("SAMOSA_0027",label)),(!grepl ("SAMOSA_0033",label)),(!grepl ("SAMOSA_0036",label)),
                               (!grepl ("SAMOSA_0040",label)),(!grepl ("SAMOSA_0041",label)),(!grepl ("SAMOSA_0042",label)),(!grepl ("SAMOSA_0043",label)),(!grepl ("SAMOSA_0044",label)),(!grepl ("SAMOSA_0045",label)),(!grepl ("SAMOSA_0046",label)),(!grepl ("SAMOSA_0047",label)),(!grepl ("SAMOSA_0048",label)),
                               (!grepl ("SAMOSA_0120",label)),(!grepl ("SAMOSA_0121",label)),(!grepl ("SAMOSA_0125",label)),(!grepl ("SAMOSA_0126",label)),(!grepl ("SAMOSA_0127",label)),(!grepl ("SAMOSA_0128",label)),(!grepl ("SAMOSA_0131",label)),(!grepl ("SAMOSA_0132",label)),(!grepl ("SAMOSA_0133",label)),
                               (!grepl ("SAMOSA_0134",label)),(!grepl ("SAMOSA_0135",label)),(!grepl ("SAMOSA_0136",label)),(!grepl ("SAMOSA_0137",label)),(!grepl ("SAMOSA_0139",label)),(!grepl ("SAMOSA_0140",label)),(!grepl ("SAMOSA_0142",label)),(!grepl ("SAMOSA_0143",label)),(!grepl ("SAMOSA_0144",label)),
                               (!grepl ("SAMOSA_0145",label)),(!grepl ("SAMOSA_0146",label)),(!grepl ("SAMOSA_0147",label)),(!grepl ("SAMOSA_0148",label)),(!grepl ("SAMOSA_0149",label)),(!grepl ("SAMOSA_0122",label)), (!grepl ("SAMOSA_0010",label)), (!grepl ("SAMOSA_0025",label)),
                               (!grepl ("SAMOSA_0053",label)), (!grepl ("SAMOSA_0058",label)), (!grepl ("SAMOSA_0163",label)), (!grepl ("SAMOSA_0160",label)), (!grepl ("SAMOSA_0141",label)), (!grepl ("SAMOSA_0164",label)), (!grepl ("SAMOSA_0165",label)), (!grepl ("SAMOSA_0166",label)),
                               (!grepl ("SAMOSA_0169",label)),(!grepl ("SAMOSA_170",label)))
Wifi = read.csv("/home/ubuntu/Git/Sensor_Alert/Data/WIFI_SAMOSA.csv",col.names=c("label","Dongle"))


#Send notification to slack channel
time <- Sys.time()
## Changing the time zone to UTC
time <- with_tz(time,tz="Asia/Kolkata")
## Creating one hour lag for the test (If any sensor is inactive for more than an hour we send an alert)
time_check = time-hours(1)
## Finding any inactive sensors
Inactive_sensors = SAMOSA_pas %>% filter(time_check>lastSeenDate) %>% select(label,lastSeenDate)%>%
left_join(Wifi,by="label")

dim(Inactive_sensors)[1]

## Adding the R environment file. This file contains the API used for analysis
readRenviron("/home/ubuntu/Git/API.Renviron")

slackr_setup(channel = "pa_sensor_alert",
             bot_user_oauth_token =  Sys.getenv('bot_user_oauth_token'),
             incoming_webhook_url = Sys.getenv('incoming_webhook_url'))

if (dim(Inactive_sensors)[1] > 0){
    
    slackr("Time of Query",time)
    slackr("Total Inactive sensors", dim(Inactive_sensors)[1])
    ## Sending the Slack alert if the sensors is inactive at any moment
    slackr("Name of Inactive sensors at the moment", pander::pandoc.table(Inactive_sensors))
}
