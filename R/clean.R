library(tidytext)
library(tidyverse)
library(wordcloud)
library(glue)

df <- read_csv(here::here("R/net.csv"))

# clean and select love and compassion verses
# df %>% 
#   filter(Book.Name != "Revelation") %>% 
#   mutate(msg = glue("{Book.Name} {Chapter}:{Verse} - {Text}")) %>% 
#   select(msg) %>% 
#   filter(str_detect(msg, "love|compassion|peace")) %>% 
#   write_csv("R/net_select.csv")

# sum of sentiment per verse, take 75th percentile of absolute
# sentiment as "positive verses". this weights towards wordier verses
df_text <- df %>% 
  janitor::clean_names() %>% 
  mutate(msg = glue("{book_name} {chapter}:{verse} - {text}"))

df_sentiment <- df_text %>%
  unnest_tokens(word, text) %>% 
  anti_join(stop_words) %>%
  inner_join(get_sentiments("bing")) %>% 
  mutate(sentiment = ifelse(sentiment == "positive", 1, -1)) %>% 
  group_by(verse_id) %>%
  summarise(sentiment = sum(sentiment)) 

cat(nrow(df_sentiment), "rows of pos and neg verses.\n")

df_pos <- df_sentiment %>% 
  filter(sentiment > 0)

cat(nrow(df_pos), "rows of pos verses.\n")

# quantiles of positive score
quantile(df_pos$sentiment, seq(0, 1, 0.1))

# pull every verse a score of 3 or more
verse_id_positive <- df_pos %>% 
  filter(sentiment >= 3) %>% 
  pull(verse_id)
  
# use verse ids to pull actual verses
df <- df_text %>% 
  filter(verse_id %in% verse_id_positive) %>% 
  select(msg)

# shuffle rows
df <- df[sample(nrow(df)), ]

write_csv(df, "R/net_select_sentiment.csv")
