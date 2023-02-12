library(tidyverse)
library(glue)

df <- read.csv(here::here("R/net.csv"))

# clean and select love and compassion verses
df %>% 
  filter(Book.Name != "Revelation") %>% 
  mutate(msg = glue("{Book.Name} {Chapter}:{Verse} - {Text}")) %>% 
  select(msg) %>% 
  filter(str_detect(msg, "love|compassion|peace")) %>% 
  write_csv("R/net_select.csv")
