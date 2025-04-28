

#'
#'
#' @param gdf           #resultant file from the "classify_osm_buildings" function
#' @param attribute     #name of the attribute to be plotted, building_type in this case
#' @param city_name     #name of the city
#'
#' @returns #' A ggplot object with the building types plotted
#' @export
#'
#' @import ggplot2
#' @import viridis
#'
#' @examples
#' #' city_name <- "Wuerzburg"
#' #' density_column <- "build_density"
#' #gdf <- classify_osm_buildings("Wuerzburg", bbox = NULL)
#'
#'
#'
plot_building_types <- function(gdf, attribute, city_name) {

  # Check if the attribute exists
  if (!attribute %in% colnames(gdf)) {
    stop(paste("Attribute", attribute, "not found in the data!"))
  }

  # Load required libraries
  library(ggplot2)
  library(sf)
  library(ggspatial)
  library(viridis)
  library(prettymapr)


  #create a quick plot of classified building types

   ggplot() +
    ggspatial::annotation_map_tile(zoomin = 0, type = "cartolight") +
    ggplot2::geom_sf(data = gdf, aes_string(fill = attribute), color = NA, alpha = 0.8) +
    ggplot2::scale_fill_viridis_d(option = "plasma", name = "Building Type") +
    coord_sf() +
    ggplot2::theme_minimal() +
    ggplot2::theme(legend.position = "right") +
    ggplot2::labs(
      title = paste("Building Functional Types in", city_name),
      caption = "Data source: OpenStreetMap"
    )
}
