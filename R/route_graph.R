#' Graphing routes players take
#'
#' @param segments Spltis of interest
#' @param selected_splits Vector of splits of interest.
#' @inheritParams theme_sm
#'
#' @export

route_graph <-
  function(font_size = 15,
           selected_splits = supermetroid::common_splits$game_event) {

    plt_base <-
    supermetroid::from_to_df %>%
      dplyr::mutate(runs = as.double(runs)) %>%
      dplyr::filter(from %in% selected_splits,
                    to %in% selected_splits) %>%
      ungroup() %>%
      tidygraph::as_tbl_graph() %>%
      ggraph::ggraph(layout = "linear") +
      ggplot2::labs(
        title =  stringr::str_wrap("Missingness and order variation
                                   in recorded player strats",
                                   50),
        subtitle = "Players choose which events to record",
        x = "Order of event determined by ggraph,
      height of arc proportional to distance between the nodes" %>%
          stringr::str_wrap(60),
        y = "",
        caption = "splits.io via jeremander/spitsio"
      ) +
      supermetroid::theme_sm(font_size = font_size) +
      ggplot2::theme(
        axis.text.x = ggplot2::element_blank(),
        axis.text.y = ggplot2::element_blank(),
        legend.position = "top",
        panel.grid.major.y = ggplot2::element_blank(),
        panel.grid.minor.y = ggplot2::element_blank()
      )

    plt_base +
      ggraph::geom_node_text(
        ggplot2::aes(label = name),
        colour = "white",
        family = "courier",
        size = font_size / 4,
        angle = 30,
        alpha = 0.5
      ) +
      ggraph::geom_edge_arc(
        aes(edge_alpha = runs),
        arrow = ggplot2::arrow(),
        colour = supermetroid::sm_col_h$dominant_colour
      )
  }
