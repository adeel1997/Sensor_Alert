library(rmarkdown);library(knitr);library(aws.s3)

## Adding the R environment file. This file contains the API used for analysis
readRenviron("/home/ubuntu/Git/API.Renviron")

render('/home/ubuntu/Git/Sensor_Alert/Sensor_Alert_Performance.Rmd')

## Add your AWS account details 
Sys.setenv("AWS_ACCESS_KEY_ID" = Sys.getenv('AWS_ACCESS_KEY_ID'),
"AWS_SECRET_ACCESS_KEY" = Sys.getenv('AWS_SECRET_ACCESS_KEY'),
"AWS_DEFAULT_REGION" = "us-east-1")

## Putting the resulting HTML into the S3 bucket
put_object(file="/home/ubuntu/Git/Sensor_Alert/Sensor_Alert_Performance.html",bucket="sensoralert",
          object="Sensor_Alert.html",acl="public-read")
