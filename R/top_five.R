#' Top games data
#'
#' Get and clean data for top games barplots
#'
#' @export

top_five_vis_dat <- function(){
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

}

#' Base plot function for
#'
#' @param df [src_top_df] subset.
#'
#' @export

top_plot <- function(df, text_scale=20) {
  df %>%
    ggplot(aes(x = game, y = count)) +
    theme_sm(font_size = text_scale) +
    geom_col(alpha=0.6) +
    geom_text(aes(label = text_label),
              y = 10,
              hjust = 0,
              colour = supermetroid::sm_col_h$highlight,
              family = "courier",
              size = text_scale/2) +
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

#' Top five plot
#'
#' @export

top_five_vis <- function(text_scale = 20) {
  # source: speedrun.com (SNES) 2021-06-29
  top_five_vis_dat() %>%
    filter(snes == "SNES") %>%
    top_plot(text_scale = text_scale) +
    facet_grid(. ~ measure, scales = "free")

}

#' Super Metroid vs top games on speedrun.com
#'
#'
#' @export

top_games_vis <- function(text_scale = 15) {

  top_five_vis_dat() %>%
    filter(snes != "SNES" | str_detect(game, "Metroid")) %>%
    top_plot(text_scale = text_scale) +
    facet_grid(. ~ measure, scales = "free")
}
