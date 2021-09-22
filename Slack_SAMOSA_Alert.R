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

########## Reading the list of sensors that are put for the colocation
Colocated_Sensors =read.csv("/home/ubuntu/Git/Sensor_Alert/Data/25_Colocated_Sensors_22Sep21.csv")
####  Selecting the SAMOSA sensors
SAMOSA_pas = pas%>% pas_filter(!grepl("B",label),grepl("SAMOSA",label))
#head(Colocated_Sensors)

#Send notification to slack channel
time <- Sys.time()
## Changing the time zone to UTC
time <- with_tz(time,tz="Asia/Kolkata")
## Creating 5 minutes lag for the test (If any sensor is inactive for more than an hour we send an alert)
time_check = time-minutes(5)
## Finding any inactive sensors in the colocated sensors 
Inactive_sensors = SAMOSA_pas %>%mutate(Sensor_name=label)%>% filter(label %in% Colocated_Sensors$Sensor_name) %>% 
filter(time_check>lastSeenDate) %>% left_join(Colocated_Sensors,by="Sensor_name") %>%
select(Sensor_name,lastSeenDate,Dongles)
#head(Inactive_sensors)
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
