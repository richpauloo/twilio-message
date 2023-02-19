library(tidytext)
library(tidyverse)
library(wordcloud)
library(glue)

df <- read_csv(here::here("R/net.csv"))

# sum of sentiment per verse, take 75th percentile of absolute
# sentiment as "positive verses". this weights towards wordier verses
rm_book <- c("Kings", "Revelation", "Samuel", "Ruth", "Judges", "Ezra",
             "Esther", "Song of Solomon")
df_text <- df %>%
  janitor::clean_names() %>% 
  filter(!book_name %in% rm_book) %>% 
  mutate(msg = glue("{book_name} {chapter}:{verse} - {text}"))

df_sentiment <- df_text %>%
  unnest_tokens(word, text) %>% 
  anti_join(stop_words) %>%
  inner_join(get_sentiments("bing")) %>% 
  mutate(sentiment = ifelse(sentiment == "positive", 1, -1)) %>% 
  group_by(verse_id) %>%
  summarise(sentiment = sum(sentiment)) 

cat(nrow(df_sentiment), "rows of pos and neg verses.\n")

# retain only positive overall sentiment verses
df_pos <- df_sentiment %>% filter(sentiment > 0)
cat(nrow(df_pos), "rows of pos verses.\n")

# quantiles of positive score
quantile(df_pos$sentiment, seq(0, 1, 0.1))

# pull every verse with a score of 2 or more
verse_id_positive <- df_pos %>% 
  filter(sentiment >= 2) %>% 
  pull(verse_id)

# extra regex to remove 
rm_extra <- c(
  "peace offering", "burnt offering", "annihilate", "Rebekah", "Rachel", 
  "Shechem", "Sihon", "less loved", "wife", "deceived me", "seven sons", 
  "Jonathan made", "Michal", "Jonathan once", "Hadadezer", "Hiram", 
  "prostitutes", "lovemaking", "bedroom chambers"
  ) %>% 
  paste(collapse = "|")
  
df <- df_text %>% 
  filter(
    verse_id %in% verse_id_positive,
    str_detect(msg, "love|compassion|peace")
  ) %>% 
  filter(!str_detect(msg, rm_extra)) %>% 
  select(msg)
cat(nrow(df), "rows of pos verses that mention love, compassion, peace.\n")

# shuffle rows
df <- df[sample(nrow(df)), ]

write_csv(df, "R/net_select_sentiment.csv")
