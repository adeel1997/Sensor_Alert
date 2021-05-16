## Loading relevant packages
library(slackr)
library(AirSensor)
library(MazamaSpatialUtils)
library(lubridate)
library(dplyr)

## Loading Spatial data 
## More details on Air Sensor Git hub page if it's not setup already
initializeMazamaSpatialUtils("Spatial_Data")

## Settng the Country Code API link and look back days 
pas <- pas_createNew(countryCodes = "IN",
                     baseUrl = 'https://www.purpleair.com/json?all=true',lookbackDays = 30,
                     includePWFSL = F)
## Changing the time zone to Asia/Kolkata
pas$lastSeenDate <- with_tz(pas$lastSeenDate,tz="Asia/Kolkata")

## If Selecting ONLY  Sensors, include these wherever necessary
#pas <- pas%>% pas_filter(!grepl("B",label),grepl("NASA",label)|grepl("UTN",label))
#pas_data <- pas %>% pas_filter(!grepl("B",label),grepl("NASA",label)|grepl("UTN",label)|grepl("UT",label))
#%>% filter(!grepl("B",label),grepl("NASA",label)|grepl("UTN",label)|grepl("UT",label))
#filter(!grepl("B",label),grepl("NASA",label)|grepl("UTN",label)|grepl("UT",label))%>%

#Displays Inactive Sensors
Inactive_Sensor <- pas %>% filter(!grepl("B",label))%>%
filter(lastSeenDate <Sys.Date()-1)%>% 
select(label,lastSeenDate,stateCode) %>% 
arrange(desc(lastSeenDate))

#Displays sensors which have PM2.5 beyween 30-90 (India AQI) for last 24 hours
pm25_1day <- pas %>% filter(!grepl("B",label))%>%
filter(lastSeenDate < Sys.Date())%>%
filter(pm25_1day > 30 && pm25_1day < 90)%>%
select(label, lastSeenDate, stateCode, pm25_1day)%>%
arrange(desc(pm25_1day))

#Create a channel in Slack and Use the slack API for authentication 
## Setting the slack system more details on slackr git hub page
slackr_setup(channel = "pa_sensor_alert",
             bot_user_oauth_token = "xxx",
             incoming_webhook_url = "yyyyy")
             
#Send notification to slack channel
time <- Sys.time()
## Changing the time zone to UTC
time <- with_tz(time,tz="Asia/Kolkata")
slackr("Time of Query",time)
## You can use knitr or Pandoc to send neat tables. Install the package from the cron
#slackr("Sensor basic Info", knitr::kable(Inactive_Sensor, format = "markdown"))
slackr("Inactive Sensors basic Info", pander::pandoc.table(nrow(Inactive_Sensor)))
slackr("Inactive Sensors basic Info", pander::pandoc.table(Inactive_Sensor))
slackr("Inactive Sensors basic Info", pander::pandoc.table(pm25_1day))


