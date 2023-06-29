#' Players take different routes
#'
#' Acts on [sio_df].
#'
#' @param ylim Set y min and max (shiny slider input).
#' @param selected_splits String vector for %in% filter.
#'
#' @import ggplot2
#' @import dplyr
#' @import tidyverse
#'
#' @export

cum_t_route_vis <- function(
    ylim = range(supermetroid::splits_df$realtime_end_ms) / 1000 / 60,
    font_size = 20
    ) {

  supermetroid::splits_df %>%
    dplyr::filter(game_event %in% common_splits$game_event) %>%
    dplyr::mutate(t_h = realtime_end_ms / 1000 / 60) %>%
    ggplot(aes(x = game_event, y = t_h, group = run_id)) +
    geom_line(colour = sm_col_h$dominant_colour, alpha = 0.2) +
    geom_point(colour = sm_col_h$dominant_colour, alpha = 0.2) +
    theme_sm(font_size = font_size) +
    labs(
      title = "Players take different routes",
      subtitle = "Real time completion of each game event would be
      always increasing if all players took the same route as anatomecha" %>%
        stringr::str_wrap(60),
      x = "Game event (loot, boss, etc.)" %>% str_wrap(12),
      y = "Real time completion (minutes)" %>% str_wrap(20),
      caption = "splits.io"
    ) +
    theme(axis.text.x = element_text(angle = 90)) +
    ylim(ylim)

}

