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
    supermetroid::sio_df %>%
    dplyr::left_join(anatomecha_splits, by = "supermetroid_label") %>%
    dplyr::mutate(split_anatomecha = forcats::as_factor(split_anatomecha),
           t_h = realtime_end_ms / 1000 / 60 / 60) %>%
    dplyr::filter(t_h < 3) %>%
    dplyr::arrange()

  plt <-
    plt_dat %>%
    ggplot2::ggplot(ggplot2::aes(x = t_h, y = run_id)) +
    geom_line(colour = supermetroid::sm_col_h$dominant_colour, alpha = 0.2) +
    geom_point(colour = supermetroid::sm_col_h$secondary_colour, alpha = 0.3) +
    supermetroid::theme_sm(base_size = base_size) +
    ggplot2::labs(title = "Time of split in each run",
         x = "Time (hrs)",
         y = "Run") +
    ggplot2::theme(axis.text.y = element_blank(),
          panel.grid = element_blank()
          )

  if (is.null(selected_split))
    return(plt)
  else {
    return(
      plt +
        ggplot2::geom_point(
          colour = sm_col_h$highlight,
          data = plt_dat %>% dplyr::filter(split == selected_split),
          size = 2,
          alpha = 0.5
        ) +
        ggplot2::geom_point(
          colour = sm_col_h$anatomecha,
          data = plt_dat %>% dplyr::filter(split == selected_split,
                                    player_name == "anatomecha"),
          size = 3
        )  +
        ggplot2::labs(
          subtitle = sprintf("Split: %s", selected_split),
          caption = "anatomecha is the pale blue dot"
        )
    )
  }

}
