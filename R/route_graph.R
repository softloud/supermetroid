#' Graphing routes players take
#'
#' @param segments Spltis of interest
#' @param selected_splits Vector of splits of interest.
#' @inheritParams theme_sm
#'
#' @export

route_graph <- function(font_size = 15,
                        selected_splits = c("kraid",
                                            "ice beam",
                                            "gravity suit",
                                            "draygon",
                                            "ridley",
                                            "varia suit",
                                            "space jump")) {
  supermetroid::from_to_df %>%
    dplyr::filter(from %in% selected_splits,
                  to %in% selected_splits) %>%
    tidygraph::as_tbl_graph() %>%
    ggraph::ggraph( layout = "linear") +
    ggraph::geom_node_text(
      ggplot2::aes(label = name),
      colour = "white",
      family = "courier",
      size = font_size / 4,
      angle = 30,
      alpha = 0.5
    ) +
    ggraph::geom_edge_arc(
      arrow = ggplot2::arrow(),
      ggplot2::aes(alpha = runs),
      colour = supermetroid::sm_col_h$dominant_colour
    ) +
    # ggraph::geom_edge_fan(colour = sm_col_h$secondary_colour, alpha = 0.2) +
    ggplot2::labs(
      title =  stringr::str_wrap(
        "Missingness and order variation in recorded player strats",
                          40),
      subtitle = "Players choose which events to record",
      x = "Order of event determined by ggraph",
      y = "",
      caption="splits.io via jeremander/spitsio"
    ) +
    supermetroid::theme_sm(base_size = font_size) +
    ggplot2::theme(axis.text.x = ggplot2::element_blank(),
                   axis.text.y = ggplot2::element_blank(),
                   legend.position = "top",
                   panel.grid.major.y = ggplot2::element_blank(),
                   panel.grid.minor.y = ggplot2::element_blank()
                   )
}
