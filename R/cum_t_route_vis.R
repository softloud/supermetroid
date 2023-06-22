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
    ylim = range(sio_df$realtime_end_ms) / 1000 / 60,
    base_size = 10
    ) {

  sio_df %>%
    left_join(anatomecha_splits, by = "supermetroid_label") %>%
    filter(!is.na(supermetroid_label)) %>%
    mutate(split_anatomecha = as_factor(split_anatomecha),
           t_h = realtime_end_ms / 1000 / 60) %>%
    filter(!is.na(split_anatomecha)) %>%
    ggplot(aes(x = split_anatomecha, y = t_h, group = run_id)) +
    geom_line(colour = sm_cols$orange, alpha = 0.2) +
    geom_point(colour = sm_cols$orange, alpha = 0.2) +
    theme_sm(base_size = base_size) +
    labs(
      title = "Players take different routes",
      subtitle = "Real time completion of each game event would be
      always increasing if all players took the same route as anatomecha" %>% str_wrap(60),
      x = "Game event (loot, boss, etc.)" %>% str_wrap(12),
      y = "Real time completion (minutes)" %>% str_wrap(20),
      caption = "splits.io"
    ) +
    theme(axis.text.x = element_text(angle = 90)) +
    scale_x_discrete(labels = c("start",
                                anatomecha_splits$supermetroid_label)) +
    ylim(ylim)

}

