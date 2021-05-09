library(twilio)

## Add the API key 
TWILIO_SID = Sys.getenv("TWILIO_SID")
TWILIO_TOKEN = Sys.getenv("TWILIO_TOKEN")
Sys.setenv(TWILIO_SID = TWILIO_SID)
Sys.setenv(TWILIO_TOKEN = TWILIO_TOKEN)

# Then we're just going to store the numbers in some variables
my_phone_number <- "+919917821111"
twilios_phone_number <- "+18179854279"

# Now we can send away!
tw_send_message(from = twilios_phone_number, to = my_phone_number, 
                body = "Hello Sairam, Adeel here sending this message from R. 
                X Sensor is not working")

