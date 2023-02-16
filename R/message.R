library(twilio)

# load environmental vars
tw_sid <- Sys.getenv("TWILIO_SID")
tw_tok <- Sys.getenv("TWILIO_TOKEN")
tw_phone_number <- Sys.getenv("TWILIO_PHONE_NUMBER")
deploy_date <- "2023-02-12"

# capture numbers which follow the convention
# PHONE_NUMBER_{initials} - R couldn't find these env vars
env_vars <- names(Sys.getenv())
num_ids  <- env_vars[grep("PHONE_NUMBER_", env_vars)]
nums     <- unlist(lapply(num_ids, Sys.getenv))
cat(length(nums), "phone numbers found.\n")

# hacky approach that works
# num_mom <- Sys.getenv("PHONE_NUMBER_MOM")
# num_jp  <- Sys.getenv("PHONE_NUMBER_JP")
# nums <- c(num_mom, num_jp)

# bible verses mentioning "love" or "compassion"
df <- read.csv(here::here("R/net_select.csv"))

# counter: number of days since deploy
i <- as.numeric(Sys.Date() - as.Date(deploy_date))

# randomly sample counter if it's out of range of the data
if(i > nrow(df)){
  i = sample(1:nrow(df), 1)
}

# configure auth
Sys.setenv(TWILIO_SID   = tw_sid)
Sys.setenv(TWILIO_TOKEN = tw_tok)

# send message
for(j in seq_along(nums)){
  cat("Preparing to send row number", i, "...")
  tw_send_message(from = tw_phone_number, 
                  to   = nums[j],
                  body = paste("\U0001f4d6", df$msg[i]))
  
  cat("sent.\n.")
}
