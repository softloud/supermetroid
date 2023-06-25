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

#' Super metroid colour heirarchy
#'
#' @export

sm_col_h <- list(
  dominant_colour = "#CCCCCC",
  secondary_colour = "#666666",
  anatomecha = "#738E9E",
  highlight = "#F2F2F2",
  label = "#F2F2F2"
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
#'
#' @export

theme_sm <- function(base_size = 15) {
  ggplot2::theme_minimal(
    base_size = base_size,
    base_family = "courier"
  ) +
    ggplot2::theme(
      # background
      plot.background=ggplot2::element_rect(fill=sm_cols$night),
      panel.background = ggplot2::element_rect(
        fill= sm_cols$black,
        colour = sm_cols$black
      ),
      panel.grid = ggplot2::element_line(colour="#4D4D4D",
                                         linetype="dotted"),

      # axis text
      axis.title = ggplot2::element_text(colour = "#D9D9D9"),
      axis.text.x = ggplot2::element_text(colour = "#BFBFBF"),
      axis.text.y = ggplot2::element_text(colour = "#BFBFBF"),
      # will need to colour axis ticks
      # axis.ticks = ggplot2::element_line(),
      plot.title = ggplot2::element_text(colour="#D9D9D9"),
      plot.subtitle = ggplot2::element_text(colour = "#BFBFBF"),
      plot.caption = ggplot2::element_text(colour = "#BFBFBF"),
      legend.text = ggplot2::element_text(colour ="#BFBFBF"),
      legend.title = ggplot2::element_text(colour = "#BFBFBF"),
      strip.text = ggplot2::element_text(colour="#BFBFBF")
    )
}

