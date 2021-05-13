# Sensor Alert & Performance (SAP) for PurpleAir IoT sensors

An open source code that helps to create a Sensor Alert & Performance (SAP) system for the low cost IoT purple air sensors (https://www2.purpleair.com/). PurpleAir makes inexpensive air pollution sensors to track PM2.5 concentrations. PM2.5 means "Particulate Matter 2.5 Micron," which is small particles that enters our human body while breathing from vairous sources.

#### What is Inside the SAP? 
1. <filename> - A webpage to overview all low costs sensors, their perfromance metrics, exploratory analysis via sactter & box plots across states , districts and also locate them on the map. 
2. <filename> - Sending SMS via Twilio application to notify particular inactive sensor unit(s) based on last active time & report to the concerned hosts in near real-time.
3. <filename> - Sending messages via Slack application to notify particular inactive sensor unit(s) based on last active time & report high PM2.5 levels to the concerned hosts in near real-time as part of alert system.

### SAP system



### Dependencies
## Please upload the following packages
library(AirSensor)          ; https://github.com/MazamaScience/AirSensor
library(MazamaSpatialUtils) ; https://github.com/MazamaScience/MazamaSpatialUtils
library(lubridate)          ; https://github.com/tidyverse/lubridate
library(dplyr)              ; https://github.com/tidyverse/dplyr
library(Metrics)            ; https://github.com/mfrasco/Metrics
library(caret)              ; https://github.com/topepo/caret
library(tidyverse)          ; https://github.com/tidyverse/
library(leaflet)            ; https://github.com/rstudio/leaflet
library(DT)                 ; https://github.com/rstudio/DT
library(tidygeocoder)       ; https://github.com/nateritter/TinyGeocoder
library(plotly)             ; https://github.com/ropensci/plotly
library(knitr)              ; https://github.com/yihui/knitr
library(crosstalk)          ; https://github.com/rstudio/crosstalk



### Frequently Asked Questions

