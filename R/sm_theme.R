#' Super Metroid visual theme elements
#'
#' @export

# https://coolors.co/image-picker


sm_cols <- list(
  teal = "#426969",
  black = "#00000A",
  night = "#101010",
  oxford_blue = "#001738",
  persian_indigo = "#2A007F",
  resolution_blue = "#17268C",
  ice_blue = "#A5FFFF",
  blue = "#17268C",
  wine = "#6D3842",
  cream = "#E0DEAC",
  red = "#C13D41",
  text_green = "#35EB34",
  orange = "#FB9435"
)

#' Inspect colours in the theme
#'
#' @export


sm_cols_look <- function(base_size=20) {
  tibble(
    colour = names(sm_cols),
    hash = as.character(sm_cols),
    theta = 1
  ) %>%
    ggplot(aes(y = colour, x = theta)) +
    # sm_theme() +
    geom_segment(
      x = 0,
      xend = 1,
      aes(colour = colour, yend = colour),
      size = 10
    ) +
    scale_color_manual(values = sm_cols) +
    theme_minimal(
      base_family = "courier",base_size=base_size) +
    theme(
      axis.text = element_text(
        colour="grey"
      ),
      plot.background = element_rect(fill="black"),
      legend.position = "none",
      panel.grid = element_blank(),
      panel.background = element_rect(
        colour="black",
        fill="black"
      )) +
    labs(x = "", y = "", title="sm_col")
}

#' Add Super Metroid theme to ggplot
#'
#' @param base_size for theme_minimal
#' @param leaderboard_api string for api "splits.io" or "speedrunner.com"
#'
#' Stuff to do
#'
#'
#' Possibly add source as an argument
#'
#' @export

theme_sm <- function(base_size = 15# , hmm how to add captino
                     # leaderboard_api
                     ) {
  ggplot2::theme_minimal(
    base_size = base_size,
    base_family = "courier"
  ) +
    ggplot2::theme(
      # background
      plot.background=ggplot2::element_rect(fill=sm_cols$night),
      panel.background = ggplot2::element_rect(
        colour=sm_cols$night,
        fill=sm_cols$black
      ),
      panel.grid = ggplot2::element_line(colour=sm_cols$oxford_blue,
                                         linetype="dotted"),

      # axis text
      axis.title =
        ggplot2::element_text(
          colour = sm_cols$text_green
        ),
      axis.text.x =
        ggplot2::element_text(colour = sm_cols$text_green),
      axis.text.y = ggplot2::element_text(colour = sm_cols$text_green),
      axis.ticks = ggplot2::element_blank(),
      plot.title = ggplot2::element_text(colour=sm_cols$cream),
      plot.subtitle = ggplot2::element_text(colour=sm_cols$cream),
      plot.caption = ggplot2::element_text(colour=sm_cols$cream),
      legend.text = ggplot2::element_text(colour=sm_cols$orange),
      legend.title = ggplot2::element_text(colour=sm_cols$orange),
      strip.text = ggplot2::element_text(colour=sm_cols$orange)
    )
}

