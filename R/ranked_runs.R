#' Visualise each run by rank
#'
#' Takes sio_df. Need to join rankings to get y-axis ordering.
#'
#' @param selected_segment If NULL plot produces plot with no highlighted
#' @param base_size For sm_theme theme_minimal.
#' @param max_time max time shown in plot in minutes
#' segment. If an [common_splits] split is specificied, highlight that.
#'
#' @export

ranked_runs <- function(selected_split = NULL,
                        max_time = 1000,
                        font_size = 40) {
  splits_dat <-
    supermetroid::splits_df %>%
    dplyr::filter(realtime_end_ms != 0) %>%
    dplyr::mutate(t_m = realtime_end_ms / 1000 / 60) %>%
    dplyr::group_by(player_id) %>%
    dplyr::arrange(src_rank) %>%
    dplyr::select(src_rank, t_m, everything()) %>%
    dplyr::ungroup() %>%
    dplyr::distinct()

  # get values for y axis
  ranked_runs <-
    splits_dat %>%
    dplyr::select(run_id, t_m) %>%
    dplyr::filter(!is.na(run_id)) %>%
    dplyr::group_by(run_id) %>%
    dplyr::filter(t_m == max(t_m)) %>%
    dplyr::filter(t_m > 50) %>%
    dplyr::ungroup() %>%
    dplyr::arrange(desc(t_m)) %>%
    # look, technically we should account for player as well
    dplyr::mutate(
      run_rank = 1:dplyr::n()
    ) %>%
   dplyr::rename(total_run_time = t_m)

  # create pltdat
  plt_dat <-
    splits_dat %>%
    dplyr::filter(t_m <= max_time) %>%
    dplyr::inner_join(ranked_runs, by = "run_id") %>%
    dplyr::ungroup() %>%
    dplyr::arrange(run_rank, realtime_end_ms) %>%
    dplyr::select(contains("rank"), contains("run"), everything())

  plt_base <-
    plt_dat %>%
    ggplot2::ggplot(ggplot2::aes(x = t_m, y = run_rank, group = run_id)) +
    supermetroid::theme_sm(font_size = font_size) +
    ggplot2::labs(title = "Time of split in each run",
                  x = "Time (mins)",
                  y = "Run") +
    ggplot2::theme(
      axis.text.y = ggplot2::element_blank(),
      panel.grid = ggplot2::element_blank()
    )

  plt <-
    plt_base +
    ggplot2::geom_line(colour = supermetroid::sm_col_h$secondary_colour,
                       alpha = 0.1) +
    ggplot2::geom_point(colour = supermetroid::sm_col_h$secondary_colour,
                        alpha = 0.2)

  if (is.null(selected_split))
    return(plt)
  else {
    return(
      plt +
        ggplot2::geom_point(
          colour = supermetroid::sm_col_h$highlight,
          data = plt_dat %>% dplyr::filter(game_event == selected_split),
          size = 3,
          alpha = 0.8
        ) +
        ggplot2::geom_point(
          colour = supermetroid::sm_col_h$anatomecha,
          data = plt_dat %>% dplyr::filter(game_event == selected_split,
                                           player_name == "anatomecha"),
          size = 9,
          alpha = 0.9
        )  +
        ggplot2::labs(
          subtitle = sprintf("Split: %s", selected_split) %>%
            stringr::str_wrap(40),
          caption = "anatomecha is the pale blue dot"
        )
    )
  }

}
