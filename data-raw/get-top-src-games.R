library(tidyverse)
library(googlesheets4)

gs4_deauth()

src_top_raw <-
  read_sheet(
    "https://docs.google.com/spreadsheets/d/1DWvMmijlKI1TxHF6dtd2y8Mcv5GO6r4FIyOFYwf_iAg/edit?usp=sharing"
  )

src_top_df <-
  src_top_raw %>%
  janitor::clean_names() %>%
  mutate(game = str_c(game, "(", year, " ", platform, ")")) %>%
  select(-year,-platform) %>%
  pivot_longer(cols = -game) %>%
  filter(!is.na(value)) %>%
  rename(
    measure = name,
    count = value
  )

src_top_df

usethis::use_data(src_top_df, overwrite=TRUE)
