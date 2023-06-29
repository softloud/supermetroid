library(tidyverse)

plt_dat <-
  src_top_df %>%
  mutate(
    game = str_wrap(game, 20),
    measure = str_replace(measure, "_", " ") %>% str_to_sentence(),
    snes = if_else(str_detect(game, "SNES"), "SNES", "X-Platform"),
    text_label = case_when(
      str_detect(game, "Metroid") ~ count,
      str_detect(game, "Mario") ~ count,
      str_detect(game, "Subway") ~ count,
      str_detect(game, "Zelda") ~ count,
      str_detect(game, "Legacy") ~ count
    ),
    measure = if_else(str_detect(measure, "Active"),
                      paste0(measure, " (upload < 30 days)"),
                      measure
                      ) ,
    measure = str_wrap(measure, 20)
  )


top_plot <- function(df) {
  df %>%
    ggplot(aes(x = game, y = count)) +
    theme_sm(20) +
    geom_col(alpha=0.6) +
    geom_text(aes(label = text_label),
              y = 10,
              hjust = 0,
              colour = supermetroid::sm_col_h$highlight,
              family = "courier",
              size = 20/2) +
    coord_flip() +
    theme(axis.text.x = element_text(angle = 90),
          panel.grid.major.y = element_blank(),
          panel.grid.minor.y = element_blank()) +
    labs(x = "",
         y = "",
         title =
           "Super Metroid compared to other speed running communities" %>%
           str_wrap(35),
         subtitle = "speedrun.com")

}

plt_dat %>%
  filter(snes == "SNES") %>%
  top_plot() +
  facet_grid(. ~ measure, scales = "free")

plt_dat %>%
  filter(snes != "SNES" | str_detect(game, "Metroid")) %>%
  top_plot() +
  facet_grid(. ~ measure, scales = "free")
