#' Graphing routes players take
#'
#' @param segments Spltis of interest
#' @param selected_splits Vector of splits of interest.
#' @inheritParams theme_sm
#'
#' @export

route_graph <- function(base_size = base_size,
                        selected_splits = c("kraid",
                                            "ice beam",
                                            "gravity suit",
                                            "draygon",
                                            "ridley",
                                            "varia suit",
                                            "space jump")) {
  from_to_df %>%
    filter(from %in% selected_splits,
           to %in% selected_splits) %>%
    as_tbl_graph() %>%
    ggraph(layout = "linear") +
    geom_edge_arc(arrow = arrow(),
                  aes(alpha = runs),
                  colour = sm_col_h$dominant_colour) +
    geom_edge_fan(colour = sm_col_h$secondary_colour, alpha = 0.2) +
    geom_node_text(
      aes(label = name),
      colour = sm_col_h$label,
      family = "courier",
      size = 4,
      angle = 45
    ) +
    labs(
      title = "Recorded but incomplete player routes and strats",
      subtitle = "Players choose which events to record",
      x = "Order of event determined by ggraph",
      y = ""
    ) +
    theme_sm(base_size = base_size) +
    theme(axis.text.x = element_blank(),
          axis.text.y = element_blank())
}
