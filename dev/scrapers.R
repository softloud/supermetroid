library(tidyverse)
library(rvest)

# purple

sm_url <- "https://www.speedrun.com/supermetroid?h=100&x=xd1mpewd"
iframe_url <- "https://www.google.com/recaptcha/api2/aframe"

sm_page <- read_html(sm_url)

# dev

iframe_html <- read_html(iframe_url)
html_structure(iframe_html)

iframe_html %>% html_element("body") %>% html_element("nonce")

iframe_html %>% html_attr("cdata")

# total run times - wiki

wiki_url <- "https://wiki.supermetroid.run/100%25"

wiki_total <- read_html(wiki_url)

html_structure()

#
library(jsonlite)
library(janitor)

# import data
# where did I get these data?
game_runs <-
  fromJSON("data-raw/splits-io-game-runs.json") %>% pluck(1) %>% clean_names()


runs <-
  fromJSON("data-raw/splits-io-runs.json") %>% pluck(1) %>% clean_names()
runners <-
  fromJSON("data-raw/splits-io-runners.json") %>% pluck(1) %>% clean_names()
category <-
  fromJSON("data-raw/splits-io-category.json") %>% pluck(1) %>% clean_names()

# raw runs
runs_raw <-
  runs %>%
    select(
           run_id = id, # unique splits.io id for the run
           run_duration = realtime_duration_ms, # how can there be two runners for one realtime_duration?
           segments, # associated segments for the run
           runners
           ) %>%
  mutate(runner = map(runners, pluck, "id"),
         runner = as.character(runner)) %>%
  left_join(runners %>% select(runner_name = display_name, runner = id))

runs_segments <- runs_raw %>% unnest(segments)

# how big?
dim(runs_raw)

# 25 runs
n_distinct(runs_raw$run_id)

# verify there is one run per runner, as far as we can
runs_segments %>%
  select(runners, run_duration, run_id) %>%
  mutate(
    n_runners = map_int(runners, nrow),
    runner = map(runners, pluck, "id"),
    runner = as.character(runner)
  ) %>%
  count(runner, run_id) %>% count(runner) %>% arrange(desc(n))

# what is in this?
runs_raw %>%
  mutate(
    hours = run_duration/1000/60/60,
    minutes = (hours - floor(hours)) * 60,
    hours = floor(hours),
    minutes = floor(minutes)
  ) %>% select(-runners,-segments,-runner, -run_duration) %>%
  arrange(hours, minutes)

#
runs_segments %>%
  mutate(
    display_name = tolower(display_name),
    display_name = map_chr(display_name, str_trim)
  ) %>%
  group_by(display_name) %>%
  summarise(
    runners = n_distinct(runner)
  ) %>%
  arrange(display_name)


fuzzy_labels <-
  runs_segments %>%
  mutate(
    display_name = tolower(display_name),
    target = map_lgl(
      display_name,
      ~any(str_detect(target_segments, .x))
    )
  ) %>%
  select(target, everything())

target_segments <-
c("Morphing Ball",
"Bomb",
"Charge Beam",
"Spazer",
"Kraid",
"Varia",
"Boots",
"Speed Booster",
"Wave Beam",
"Grappl",
"Ice Beam",
"Phantoon",
"Gravity Suit",
"Draygon",
"Space Jump",
"Spring Ball",
"Plasma Beam",
"Screw Attack",
"Ridley",
"X-Ray",
"Golden Four"
  ) %>% tolower()

library(fuzzyjoin)
fuzzy_dat <-
  runs_segments %>%
  # select(display_name) %>%
  mutate(
    display_original = display_name,
    display_name = tolower(display_name),
         display_name = str_remove(display_name, "defeat:"),
    display_name = str_remove_all(display_name,
                                  "\\(.*?\\)"
                                  # "\\(\\d+\\)|\\(\\d+/\\d+\\)|\\([\\w+|\\s]\\)"
                                  ),
    display_name = str_trim(display_name)
    ) %>%
  stringdist_left_join(
  tibble(display_name = target_segments),
  by = "display_name"
) %>% arrange(display_name.x)


fuzzy_labels <-
fuzzy_dat %>%
  rename(
    segment = display_name.x,
    label = display_name.y
  ) %>%
  mutate(
    label = case_when(
      display_original == "space" ~ NA,
      segment == "x-ray scope" ~ "x-ray",
      segment == "wave" ~ "wave beam",
      segment == "varia suit" ~ "varia",
      display_original %in% c("Ridley (Energy)", "Ridley E") ~ NA,
      segment == "phantoon dead" ~ "phantoon",
      str_detect(segment, "morp") ~ "morphing ball",
      segment == "ice" ~ "ice beam",
      segment == "speed" ~ "speed booster",
      segment == "spazer beam" ~ "spazer",
      segment == "screw" ~ "screw attack",
      segment == "plasma" ~ "plasma beam",
      segment %in% c("boots", "hjb") ~ "boots",
      (str_detect(segment, "hi") & str_detect(segment,"jump")) ~ "boots",
      segment == "bombs" ~ "bomb",
      segment == "charge" ~ "charge beam",
      segment %in% c("grapple beam", "grappling",
                     "grappring beam", "grappling beam") ~ "grappl",
      segment %in% c("golden 4", "g4") ~ "golden four",
      segment %in% c("gravit", "gravity") ~ "gravity suit",
      TRUE ~ label
    )
  )

# %>% # filter(str_starts(segment, "z")) %>% # View()
  # count(label) %>% arrange(desc(n)) %>% View()
fuzzy_labels %>%
  filter(!is.na(label), run_id != "a3gh") %>%
  ggplot(aes(x = realtime_end_ms, y = run_id)) +
  facet_grid(runner ~ ., scales="free") +
  geom_point(aes(
    colour = label
  )) +
  theme_minimal() +
  labs(
    title = "Matched segments for each run",
    subtitle = "Run id on left axis, grouped by runner on the right"
  )

fuzzly_labels %>%
  select(run_id, realtime_end_ms, label, display_original) %>%
  filter(str_detect(display_original, "ace"))


