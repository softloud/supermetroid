#' Top five plot
#'
#' @param base_size `theme_minimal` argument
#'
#' @export

top_five_vis <- function(base_size = 10) {
  # source: speedrun.com (SNES) 2021-30-05
  top_five <-
    tribble(
      ~game_short, ~game, ~released, ~runs, ~active_players, ~total_players,
      "sm","Super Metroid", 1994, 11943, 98, 1733,
      "smw","Super Mario World", 1990, 10501, 89, 2125,
      "smb","Super Mario Bros.", 1987, 9371, 86, 2392,
      "lz","The Legend of Zelda", 1991, 8758, 59, 2358,
      "smb3","Super Mario Bros. 3", 1989, 4803, 69, 1128
    ) %>%
    arrange(active_players)

  levels(top_five$game) <- top_five$game

  top_plt_dat <-
    top_five %>%
    mutate(
      game = str_c(game, " (", released, ")"),
      game = str_wrap(game, 10)
    ) %>%
    select(-released, -game_short) %>%
    pivot_longer(
      cols = -game,
      names_to = "counted_thing",
      values_to = "count"
    ) %>%
    mutate(
      counted_thing = as.factor(counted_thing),
      counted_thing =
        fct_relevel(counted_thing, "active_players", "total_players", "runs"),
      counted_thing =
        str_replace(counted_thing, "_", " ") %>% str_to_sentence()
    )

  levels(top_plt_dat$game) <- top_plt_dat %>%
    filter(counted_thing == "Active players") %>% pull(game)

  top_plt_dat  %>%
    ggplot() +
    geom_segment(
      aes(x = 0, xend = count + 0.01*count, y = game, yend=game),
      colour=sm_cols$ice_blue,
      size=base_size*1.3
    ) +
    geom_segment(
      aes(x = 0, xend = count, y = game, yend=game),
      colour=sm_cols$persian_indigo,
      size=base_size*1.2
    ) +
    theme_sm(base_size = base_size) +
    geom_text(
      aes(x = 0.75 * count, y = game, label = count),
      family="courier",
      size = base_size/2,
      colour = sm_cols$ice_blue
    ) +
    facet_wrap(
      counted_thing ~ ., scale="free_x"
    ) +
    #  coord_flip() +
    labs(
      title =
        "Super Metroid has the largest active SNES speed runner community" %>%
        str_wrap(40),
      subtitle = "Top 5 SNES (Super Nintendo Entertainment System) games:
      Active players, total players, and number of runs" %>%
        str_wrap(40),
      x = "",
      y = "",
      caption="speedrun.com (2023-06-01)"
    ) +
    theme(axis.text.x = element_blank())
}

#' Super Metroid vs top games on speedrun.com
#'
#'
#' @export

top_games_vis <- function(base_size = 10) {

# top three of each category as of 2023-06-01

# todo: check vis against site
tribble(
  ~game, ~released, ~counted_thing, ~count,
  "Super Metroid", 1994, "runs", 11943,
  "Subway Surfers", 2012, "runs", 89421,
  "Super Mario 64", 1996, "runs", 40467,
  "Minecraft: Java Edition", 2011, "runs", 31632,
  "Super Metroid", 1994, "active_players", 98,
  "Roblox: DOORS", 2022, "active_players", 814,
  "Minecraft: Java Edition", 2011, "active_players", 714,
  "ROBLOX: Tower Defense Simulator", 2019, "active_players", 672,
  "Super Metroid", 1994, "total_players", 1733,
  "Subway Surfers", 2012, "total_players", 49174,
  "Minecraft: Java Edition", 2011, "total_players", 14116,
  "Roblox: DOORS", 2022, "total_players", 9613
) %>%
  mutate(
    game = str_c(game, " (", released, ")"),
    game = str_wrap(game, 10),
    counted_thing = as.factor(counted_thing),
    counted_thing =
      fct_relevel(counted_thing, "active_players", "total_players", "runs"),
    counted_thing =
      str_replace(counted_thing, "_", " ") %>% str_to_sentence(),
    counted_thing = str_wrap(counted_thing, 10)
  ) %>%
  ggplot() +
  geom_segment(
    aes(x = 0, xend = count + 0.01*count, y = game, yend=game),
    colour=sm_cols$ice_blue,
    size=22
  ) +
  geom_segment(
    aes(x = 0, xend = count, y = game, yend=game),
    colour=sm_cols$persian_indigo,
    size=20
  ) +
  theme_sm(base_size = base_size) +
  geom_text(
    aes(x = 0.75 * count, y = game, label = count),
    family="courier",
    size = 8,
    colour = sm_cols$ice_blue
  ) +
  facet_wrap(
    counted_thing ~ ., scale="free"
  ) +
  labs(
    title =
      "Super Metroid compared to top speed runner games" %>%
      str_wrap(40),
    subtitle = "Super Metroid compared to top 3 games in categories:
      Active players, total players, and number of runs" %>%
      str_wrap(40),
    x = "",
    y = "",
    caption="speedrun.com (2023-06-01)"
  ) +
  theme(axis.text.x = element_blank())
}
