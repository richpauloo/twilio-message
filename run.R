#library(twilio)
#library(here)
#
#d <- sessionInfo()
#n <- names(d$otherPkgs)
#writeLines(n, "session_info.txt")

library(twilio)

d <- sessionInfo()
n <- names(d$otherPkgs)
writeLines(n, "session_info.txt")

# bible verses mentioning "love" or "compassion"
s <- read.csv("s.csv")

# counter: number of days since 
i <- as.numeric(Sys.Date() - as.Date(Sys.getenv("DEPLOY_DATE")))

# randomly sample counter if it's out of range of the data
if(i > nrow(s)){
  i = sample(1:nrow(s), 1)
}

# load environmental vars
tw_sid <- Sys.getenv("TWILIO_SID")
tw_tok <- Sys.getenv("TWILIO_AUTH_TOKEN")
tw_phone_number  <- Sys.getenv("TWILIO_PHONE_NUMBER")
tw_target_number <- Sys.getenv("TARGET_PHONE_NUMBER")

# configure auth
Sys.setenv(TWILIO_SID   = tw_sid)
Sys.setenv(TWILIO_TOKEN = tw_tok)

# send message
tw_send_message(from = tw_phone_number, 
                to   = tw_target_number,
                body = paste("\U0001f4d6", s$s[i]))

write.csv(s, "s.csv")