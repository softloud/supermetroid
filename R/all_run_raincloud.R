#' Raincloud plot of speedrun.com run times
#'
#' @param run_df Dataframe of column of run times `t_s` in seconds
#' @param xmin Set limits of x axis (for shiny slider input)
#' @param xmax Set max of x axis (shiny slider)
#' @param base_size For theme_minimal
#' @param source Caption provenance
#'
#' @export

all_run_raincloud <- function(run_df = src_run_df,
                              xmin = min(src_run_df$t_s),
                              xmax = max(src_run_df$t_s),
                              base_size = 15,
                              source = "speedrun.com") {
  run_df %>%
    # convert milliseconds to hours, for now
    dplyr::mutate(t_m = t_s / 60 / 60) %>%

    # exclude runs > 3 hours

    ggplot2::ggplot(ggplot2::aes(y = t_m)) +

    # plot layers

    # density
    ggdist::stat_halfeye(
      # custom bandwidth?
      adjust = 0.5,
      # move geom to the right (before flip)
      # above after flip
      justification = -.2,
      .width = 0,
      alpha = 0.5,
      point_colour = NA,
      fill = sm_cols$orange
    ) +

    # boxplot
    ggplot2::geom_boxplot(
      width = .2,
      ## remove outliers
      outlier.color = NA,
      alpha = 0.5,
      colour = sm_cols$orange,
      fill = sm_cols$orange
    ) +

    # dots
    ggdist::stat_dots(
      # orientation to the left
      side = "left",
      # # adjust grouping (binning of observations)
      # binwidth=0.25, # seems better to let it choose
      # move geom to the left
      justification = 1.2,
      alpha = 0.5,
      colour = sm_cols$orange,
      fill = sm_cols$orange
    ) +

    # set theme
    theme_sm(base_size = base_size) +

    ggplot2::labs(
      title = "Super Metroid 100% speed run times" %>%
        stringr::str_wrap(40),
      subtitle = "Duration of speedrun distribution",
      y = "time (hrs)",
      x = '',
      caption = source
    ) +

    # zoom for shiny
    ggplot2::ylim(xmin, xmax) +

  # rotate
    ggplot2::coord_flip() +

    # final tweaks
    ggplot2::theme(axis.text.y = ggplot2::element_blank())

}
