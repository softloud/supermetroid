#' Raincloud plot of speedrun.com run times
#'
#' @param run_df Dataframe of column of run times in seconds.
#' @param xmin Set limits of x axis, for shiny slider input, in minutes.
#' @param xmax Set max of x axis, shiny slider, in minutes.
#' @param font_size For theme minimal
#' @param source Caption provenance
#'
#' @export

all_run_raincloud <- function(run_df = supermetroid::src_df,
                              lowest_rank =
                                max(supermetroid::src_df$rank),
                              highest_rank = 1,
                              font_size = 20,
                              source = "speedrun.com via srcomapi") {

  plot_dat <-
    run_df %>%
    # convert milliseconds to hours, for now
    dplyr::mutate(t_m = t_s / 60)

    # get x-axis limits of plot from ranks
  plot_xlim <-
    plot_dat %>%
    dplyr::filter(
      rank >= highest_rank,
      rank <= lowest_rank
    ) %>%
      dplyr::summarise(
        min = min(t_m),
        max = max(t_m)
      ) %>%
      as.list()



plot_dat %>%
    ggplot2::ggplot(
      ggplot2::aes(y = t_m),
      colour = supermetroid::sm_col_h$highlight,
      fill = supermetroid::sm_col_h$highlight
      ) +

    # plot layers

    # density
    ggdist::stat_halfeye(
      # custom bandwidth?
      adjust = 0.5,
      # move geom to the right (before flip)
      # above after flip
      justification = -.2,
      .width = 0,
      alpha = 0.4,
      point_colour = NA,
      colour = supermetroid::sm_col_h$highlight,
      fill = supermetroid::sm_col_h$highlight
    ) +

    # boxplot
    ggplot2::geom_boxplot(
      width = .2,
      ## remove outliers
      outlier.color = NA,
      alpha = 0.4
    ) +

    # dots
    ggdist::stat_dots(
      # orientation to the left
      side = "left",
      # # adjust grouping (binning of observations)
      # binwidth=0.25, # seems better to let it choose
      # move geom to the left
      justification = 1.2,
      alpha = 0.4
    ) +

    # set theme
    theme_sm(base_size = font_size) +

    ggplot2::labs(
      title = "Super Metroid 100% speed run times" %>%
        stringr::str_wrap(font_size * 2),
      subtitle = "Duration of speedrun distribution",
      y = "Time (minutes)",
      x = '',
      caption = ""
    ) +

    # zoom for shiny
    ggplot2::ylim(plot_xlim$min, plot_xlim$max) +

  # rotate
    ggplot2::coord_flip() +

    # final tweaks
    ggplot2::theme(
      axis.text.y = ggplot2::element_blank(),
      panel.grid.major.y = ggplot2::element_blank(),
      panel.grid.minor.y = ggplot2::element_blank()
      )

}
