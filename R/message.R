library(twilio)

# load environmental vars
tw_sid <- Sys.getenv("TWILIO_SID")
tw_tok <- Sys.getenv("TWILIO_TOKEN")
tw_phone_number <- Sys.getenv("TWILIO_PHONE_NUMBER")
deploy_date <- "2021-10-23"

# capture numbers which follow the convention
# PHONE_NUMBER_{initials}
env_vars <- names(Sys.getenv())
num_ids  <- env_vars[grep("PHONE_NUMBER_", env_vars)]
nums     <- unlist(lapply(num_ids, Sys.getenv))

# bible verses mentioning "love" or "compassion"
s <- read.csv(here::here("R/s.csv"))

# counter: number of days since deploy
i <- as.numeric(Sys.Date() - as.Date(deploy_date))

# randomly sample counter if it's out of range of the data
if(i > nrow(s)){
  i = sample(1:nrow(s), 1)
}

# configure auth
Sys.setenv(TWILIO_SID   = tw_sid)
Sys.setenv(TWILIO_TOKEN = tw_tok)

# send message
for(j in seq_along(nums)){
  tw_send_message(from = tw_phone_number, 
                  to   = nums[j],
                  body = paste("\U0001f4d6", s$s[i]))
  
  cat("Sent row number", i)
}
