# Sensor Alert & Performance (SAP) for PurpleAir IoT sensors

An open source code that helps to create a Sensor Alert & Performance (SAP) system for the low cost IoT purple air sensors (https://www2.purpleair.com/). PurpleAir makes inexpensive air pollution sensors to track PM2.5 concentrations. PM2.5 means "Particulate Matter 2.5 Micron," which is small particles that enters our human body while breathing from vairous sources.

#### What is Inside the SAP?  

1. https://github.com/adeel1997/Sensor_Alert/blob/main/Sensor_Alert_Performance.Rmd - A R-markdown (HTML output file format) that shows an overview of all low costs sensors, their perfromance metrics, exploratory analysis via sactter & box plots across states , districts and also to locate them on the map with key feature to identify inactive sensors. 
2. https://github.com/adeel1997/Sensor_Alert/blob/main/Message_Alert.R - Sending SMS via Twilio application to notify particular inactive sensor unit(s) based on last active time & report to the concerned hosts in near real-time.
3. https://github.com/adeel1997/Sensor_Alert/blob/main/Slack_Alert.R - Sending messages via Slack application to notify particular inactive sensor unit(s) based on last active time & report high PM2.5 levels (> 90) to the concerned hosts in near real-time as part of alert system.

### SAP system

The SAP systems give us an overview of the low-cost(Purple Air) sensors networks across India & specifically over Indo-Gangetic Plain to know the AQ-Particluate matter 2.5 (PM2.5). The system shows all the low-cost sensors deployed in India, their perfromance metrics and timer series analysis. The most important feature of SAP is to know which sensors are inactive in last 24 hours. The tool also helps us to know the spatial & temporal varaition of PM2.5 across states & districts, thereby increae the low cost air pollution sensors network.

### Dependencies
#### Please install the following packages
AirSensor -  https://github.com/MazamaScience/AirSensor ,   MazamaSpatialUtils - https://github.com/MazamaScience/MazamaSpatialUtils, 
lubridate -  https://github.com/tidyverse/lubridate ,      dplyr     - https://github.com/tidyverse/dplyr ,
Metrics   -  https://github.com/mfrasco/Metrics ,          tidyverse - https://github.com/tidyverse/ ,
caret     -  https://github.com/topepo/caret ,             DT        - https://github.com/rstudio/DT ,
tidygeocoder - https://github.com/nateritter/TinyGeocoder , knitr     - https://github.com/yihui/knitr ,
leaflet   -  https://github.com/rstudio/leaflet ,           plotly    - https://github.com/ropensci/plotly


### Frequently Asked Questions

