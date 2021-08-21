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



SAMOSA_pas = pas%>% pas_filter(!grepl("B",label),grepl("SAMOSA",label))

#Send notification to slack channel
time <- Sys.time()
## Changing the time zone to UTC
time <- with_tz(time,tz="Asia/Kolkata")
## Creating one hour lag for the test (If any sensor is inactive for more than an hour we send an alert)
time_check = time-hours(1)
## Finding any inactive sensors
Inactive_sensors = SAMOSA_pas %>% filter(time_check>lastSeenDate) %>% select(label,lastSeenDate)

dim(Inactive_sensors)[1]

## Adding the R environment file. This file contains the API used for analysis
readRenviron("/home/ubuntu/Git/API.Renviron")

slackr_setup(channel = "pa_sensor_alert",
             bot_user_oauth_token =  Sys.getenv('bot_user_oauth_token'),
             incoming_webhook_url = Sys.getenv('incoming_webhook_url'))

if (dim(Inactive_sensors)[1] > 0){
    
    slackr("Time of Query",time)
    ## Sending the Slack alert if the sensors is inactive at any moment
    slackr("Name of Inactive sensors at the moment", pander::pandoc.table(nrow(Inactive_sensors)))
    slackr("Name of Inactive sensors at the moment", pander::pandoc.table(Inactive_sensors))
}
