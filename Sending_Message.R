library(twilio)

Sys.setenv(TWILIO_SID = "AC9462c008c173b4c3334e39504e72ad60")
Sys.setenv(TWILIO_TOKEN = "9eb19269058b3903180944bf961bec48")

# Then we're just going to store the numbers in some variables
my_phone_number <- "+919917821111"
twilios_phone_number <- "+18179854279"

# Now we can send away!
tw_send_message(from = twilios_phone_number, to = my_phone_number, 
                body = "Hello Sairam, Adeel here sending this message from R. 
                X Sensor is not working")

