## Loading relevant packages
library(slackr) 
library(AirSensor)
library(MazamaSpatialUtils) 
library(lubridate)
library(dplyr)
library(twilio) 
library(tidygeocoder)

## Loading Spatial data : This requires to create a local folder named Spatial_Data with MazamaSpatialUtils files.
initializeMazamaSpatialUtils("Spatial_Data") 

## PurpleAir PAS with 30 days look back time & setting PWFSL as False:
pas <- pas_createNew(countryCodes = "IN",baseUrl = 'https://www.purpleair.com/json?all=true', 
                     lookbackDays = 30,includePWFSL = FALSE)

## Geolocating from the latitude and longitude using open street map
Geolocation <- reverse_geo(
    lat = pas$latitude,
    long = pas$longitude,
    method = "osm", # open street map
    full_results = T
)

## Adding more columns in the pas object
pas$City <- as.factor(Geolocation$city)
pas$District <- as.factor(Geolocation$state_district)
pas$State <- as.factor(Geolocation$state)
pas$Sensor_Name <- pas$label
## Converting the last seen Date to India timezone
pas$lastSeen <- strftime(with_tz(pas$lastSeenDate,tz="Asia/Kolkata"), 
                         format="%Y-%m-%d %H:%M",tz="Asia/Kolkata")

## Passing lastSeenDate as object
lastSeenDate <- pas$lastSeen

## Selecting lastSeenDate based Sensor unit and selecting limited columns with respect to states, Sensor_Names.

#Delhi
Inactive_Sensor_DL <- pas %>% filter(!grepl("B",label))%>%
filter(grepl("Delhi", State)) %>%
filter(lastSeen <Sys.Date()-1)%>% 
select(Sensor_Name,lastSeen,District,State) %>%
arrange(desc(lastSeen))

#UP
Inactive_Sensor_UP <- pas %>% filter(!grepl("B",label))%>%
filter(grepl("Uttar Pradesh", State)) %>%
filter(lastSeen <Sys.Date()-1)%>% 
select(Sensor_Name,lastSeen,District,State) %>%
arrange(desc(lastSeen))

#WB
Inactive_Sensor_WB <- pas %>% filter(!grepl("B",label))%>%
filter(grepl("West Bengal", State)) %>%
filter(lastSeen <Sys.Date()-1)%>% 
select(Sensor_Name,lastSeen,District,State) %>%
arrange(lastSeen)

#Punjab
Inactive_Sensor_PB <- pas %>% filter(!grepl("B",label))%>%
filter(grepl("Punjab", State)) %>%
filter(lastSeen <Sys.Date()-1)%>% 
select(Sensor_Name,lastSeen,District,State) %>%
arrange(lastSeen)

#Haryana
Inactive_Sensor_HAR <- pas %>% filter(!grepl("B",label))%>%
filter(grepl("Haryana", State)) %>%
filter(lastSeen <Sys.Date()-1)%>% 
select(Sensor_Name,lastSeen,District,State) %>%
arrange(lastSeen)

#Karnataka
Inactive_Sensor_KAR <- pas %>% filter(!grepl("B",label))%>%
filter(grepl("Karnataka", State)) %>%
filter(lastSeen <Sys.Date()-1)%>% 
select(Sensor_Name,lastSeen,District,State) %>%
arrange(lastSeen)

#chandigarh
Inactive_Sensor_CHAN <- pas %>% filter(!grepl("B",label))%>%
filter(grepl("Chandigarh", State)) %>%
filter(lastSeen <Sys.Date()-1)%>% 
select(Sensor_Name,lastSeen,District,State) %>%
arrange(lastSeen)

#add required state as & when necessary

##SMS
## Twilio SSID & Token : This requires to create Twilio account.
Sys.setenv(TWILIO_SID = "xxxxx")  
Sys.setenv(TWILIO_TOKEN = "xxxxx")

# Then we're just going to store the phone numbers in some variables
my_phone_number <- "+91xxxxxxxxx"
twilios_phone_number <- "+18179854279"

# Now we can send SMS away!
msg <- tw_send_message(
  from = twilios_phone_number,  to = my_phone_number, body = paste("Hi, The inactive Sensors as of " , lastSeenDate, "in Delhi are",  
  Inactive_Sensor_DL, "and in UP is/are", Inactive_Sensor_UP, "Do inform the host.", "Let us Breathe Clean Air- www.ceew.in" )
)

## Add multiple phone numbers & msg format using the above template for all states.
