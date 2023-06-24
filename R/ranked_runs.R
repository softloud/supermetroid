#' Visualise each run by rank
#'
#' Takes sio_df. Need to join rankings to get y-axis ordering.
#'
#' @param selected_segment If NULL plot produces plot with no highlighted
#' @param base_size For sm_theme theme_minimal.
#' segment. If an [anatomecha_splits] split is specificied, highlight that.
#'
#' @export

ranked_runs <- function(selected_split = NULL,
                        base_size = 40) {
  plt_dat <-
    sio_df %>%
    left_join(anatomecha_splits, by = "supermetroid_label") %>%
    filter(!is.na(supermetroid_label)) %>%
    mutate(split_anatomecha = as_factor(split_anatomecha),
           t_h = realtime_end_ms / 1000 / 60 / 60) %>%
    filter(t_h < 3)

  plt <-
    plt_dat %>%
    ggplot(aes(x = t_h, y = run_id)) +
    geom_line(colour = sm_col_h$dominant_colour, alpha = 0.2) +
    geom_point(colour = sm_col_h$secondary_colour, alpha = 0.3) +
    theme_sm(base_size = base_size) +
    labs(title = "Time of split in each run",
         x = "Time (hrs)",
         y = "Run") +
    theme(axis.text.y = element_blank(),
          panel.grid = element_blank()
          )

  if (is.null(selected_split))
    return(plt)
  else {
    return(
      plt +
        geom_point(
          colour = sm_col_h$highlight,
          data = plt_dat %>% filter(split == selected_split),
          size = 2,
          alpha = 0.5
        ) +
        geom_point(
          colour = sm_col_h$anatomecha,
          data = plt_dat %>% filter(split == selected_split,
                                    player_name == "anatomecha"),
          size = 3
        )  +
        labs(
          subtitle = sprintf("Split: %s", selected_split),
          caption = "anatomecha is the pale blue dot"
        )
    )
  }

}
