pos <- df %>% 
  mutate(sentiment = ifelse(sentiment == "positive", 1, -1)) %>% 
  group_by(verse_id) %>%
  summarise(sentiment = sum(sentiment)) %>% 
  arrange(desc(sentiment))

filter(df, verse_id %in% pos) %>% 
  select(msg) %>% 
  unique() %>% 
  pull(msg) %>% 
  paste(collapse = "\n\n") %>% 
  cat()

p <- df %>%
  inner_join(get_sentiments("bing")) %>% 
  count(verse_id, verse, sentiment) %>% 
  spread(sentiment, n, fill = 0) %>%
  mutate(sentiment = positive - negative,
         sentiment = sentiment/max(abs(sentiment)),
         dir       = ifelse(sentiment >= 0, "up","dn")) 

p <- p %>% 
  ggplot(aes(verse_id, sentiment, fill = dir)) +
  geom_col() +
  labs(title    = "Bible sentiment",
       subtitle = "Relative sentiment per verse",
       x = "Verse Number", 
       y = "Normalized sentiment") +
  coord_cartesian(ylim = c(-1,1)) +
  theme_minimal() +
  theme(legend.position='none')

plotly::ggplotly(p)

p %>% arrange(sentiment) %>% head()

bing_word_counts <- df %>%
  inner_join(get_sentiments("bing")) %>%
  # filter(word != "trump") %>% 
  count(word, sentiment, sort = TRUE) %>%
  ungroup()

bing_word_counts %>%
  group_by(sentiment) %>%
  top_n(10) %>%
  ungroup() %>%
  mutate(word = reorder(word, n)) %>%
  ggplot(aes(word, n, fill = sentiment)) +
  geom_col(show.legend = FALSE) +
  facet_wrap(~sentiment, scales = "free_y") +
  labs(y = "Contribution to sentiment",
       x = NULL) +
  coord_flip() +
  theme_minimal()

df %>%
  inner_join(get_sentiments("bing")) %>%
  # filter(word != "trump") %>% 
  count(word, sentiment, sort = TRUE) %>%
  acast(word ~ sentiment, value.var = "n", fill = 0) %>%
  comparison.cloud(colors = c("red", "lightblue"),
                   max.words = 100)
