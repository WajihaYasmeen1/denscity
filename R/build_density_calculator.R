


# Function to calculate building density
#'
#'
#' @param city_name     # name of the city of interest
#' @param admin_level   #level of administrative boundaries (recommended 8 as it is at the district level)
#' @param bbox          #bbox of the coty if available
#'
#' @returns      # A GeoDataFrame with building density information
#' @export
#'
#' @examples
#' city_name <- "Wuerzburg"
#' admin_level <- 8
#' bbox <- NULL
#'
#' building density_result <- calculate_building_density(city_name, admin_level, bbox)





calculate_building_density <- function(city_name, admin_level, bbox = NULL) {
  #loading required libraries
  library(osmdata)
  library(dplyr)
  library(ggplot2)
  library(sf)

  # Getting the bounding box of the city
  if (is.null(bbox)) {
    bbox <- osmdata::getbb(city_name, format_out = "polygon")[[1]]
  }

  #Retrieving administrative boundary data for the given admin level
  boundary <- osmdata::opq(bbox) %>%
    osmdata::add_osm_feature(key = "admin_level", value = as.character(admin_level)) %>%
    osmdata::osmdata_sf()

  #Selecting multipolygon data from the boundary
  boundary_polygons <- boundary$osm_multipolygons

  #Cleaning district names (remove digits, periods, and trim whitespace)
  boundary_polygons$name <- gsub('[[:digit:]]+', '', boundary_polygons$name)
  boundary_polygons$name <- gsub("[.]", '', boundary_polygons$name)
  boundary_polygons$name <- trimws(boundary_polygons$name)

  #calculating area of each district
  boundary_polygons$polygon_area <- as.numeric(sf::st_area(boundary_polygons))

  #Retrieving OSM building data
  buildings <- osmdata::opq(bbox) %>%
    osmdata::add_osm_feature(key = "building") %>%
    osmdata::osmdata_sf()

  #Selecting the building polygons
  building_polygons <- buildings$osm_polygons

  #Calculating the area of each building
  building_polygons$area <- as.numeric(sf::st_area(building_polygons))

  #Calculating centroids for buildings
  building_centroids <- sf::st_centroid(building_polygons)

  #Filter buildings that are within the city boundary polygons
  clipped_buildings <- sf::st_join(building_centroids, boundary_polygons, join = sf::st_within)

  #Aggregating building areas by district using osm_id
  density_calculation <- aggregate(clipped_buildings$area,
                                   by = list(osm_id = clipped_buildings$osm_id.y),
                                   FUN = sum)

  #Renaming columns for clarity
  colnames(density_calculation) <- c("osm_id", "building_area")

  #Merge building areas with district polygons
  boundary_polygons <- dplyr::left_join(boundary_polygons, density_calculation, by = "osm_id")

  #Calulating building density for each district (in percentage)
  boundary_polygons <- boundary_polygons %>%
    dplyr::mutate(build_density = (building_area / polygon_area) * 100)

  #Returning the results
  return(boundary_polygons)

}
