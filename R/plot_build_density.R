#' Title
#'
#' @param gdf           #resultant file from the "calculate_building_density" function
#' @param attribute     #name of the attribute to be plotted, build_density in this case
#' @param city_name     #name of the city
#'
#' @returns      # Choropleth map of building density
#' @export
#'
#' @import ggplot2
#' @import viridis
#'
#' @examples
#' #' city_name <- "Wuerzburg"
#' #' density_column <- "build_density"
#' #gdf <- calculate_building_density(city_name, admin_level = 8, bbox = NULL)
#'
#'



plot_building_density <- function(build_density_GDF, city_name = "", density_column) {

  # Check if the density column exists
  if (!density_column %in% colnames(build_density_GDF)) {
    stop(paste("Column", density_column, "not found in the data!"))
  }

  #plot  building density
  ggplot(data = building_density_result) +
    geom_sf(aes_string(fill = density_column), color = "white") +
    scale_fill_viridis_c(option = "plasma", na.value = "grey90", name = "Building Density (%)") +
    labs(
      title = paste("Building Density in", city_name),
      caption = "Data: OpenStreetMap"
    ) +
    theme_minimal() +
    theme(legend.position = "right")
}
