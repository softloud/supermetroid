#' World mop of players
#'
#' @export

sm_world <- function(df = src_df) {
  # create data for world coordinates using
  # map_data() function
  world_coordinates <- map_data("world")

 df %>%
   rename(player_location = location) %>%
    count(player_location) %>%
    inner_join(world_coordinates, by = c("player_location" = "region")) %>%
    ggplot() +
   geom_map(map = world_coordinates,
            aes(long, lat), fill="darkgrey") +
   geom_map(map = world_coordinates,
             aes(long, lat, map_id = player_location, fill = n)) +
    theme_sm() +
    labs(x = "",
         y = "",
         title = "Where are Super Metroid speed runners located?" %>%
           str_wrap(30)) +
    theme(axis.text.x = element_blank(),
          axis.text.y = element_blank(),
          legend.position = "bottom") +
    scale_fill_gradient("Number of players", high = sm_col_h$dominant_colour, low = sm_cols$wine)


  # plotly fails on this map, need to switch to leaflet
  # ggplotly(player_map)
}
