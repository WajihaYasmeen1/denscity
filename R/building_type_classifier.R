# Function to download and classify building types from OSM
#'
#'
#' @param city_name        #Name of the city you want to classify
#' @param bbox             #Bounding box of the city
#'
#' @returns  A sf object with classified building types
#'
#' @details This function uses the OpenStreetMap OSM API to retrieve the bounding box of the specified city,
#' retrieves the building tags, reclassify the building types,
#' and returns a sf object with additional column "building_type"
#'
#'
#' @export
#'
#' @examples
#'
#' city_name <- "Wuerzburg"
#'
#' classified_buildings <- classify_osm_buildings("Wuerzburg")
#'
classify_osm_buildings <- function(city_name, bbox = NULL) {

  # Load required libraries
  library(osmdata)
  library(dplyr)
  library(ggplot2)
  library(sf)
  library(ggspatial)
  library(tidyverse)
  library(viridis)
  library(prettymapr)



  #Get bounding box
  if (is.null(bbox)) {
    bbox <- osmdata::getbb(city_name)
  }

  #Query OSM buildings
  buildings <- osmdata::opq(bbox = bbox) %>%
    osmdata::add_osm_feature(key = "building") %>%
    osmdata::osmdata_sf()

  #Extract polygon geometry
  buildings_sf <- buildings$osm_polygons %>%
    dplyr::select(osm_id, name, building, geometry)

  # Clean up and classify
  buildings_classified <- buildings_sf %>%
    dplyr::mutate(building_type = dplyr::case_when(
      building %in% c("residential", "house", "apartments", "terrace") ~ "Residential",
      building %in% c("commercial", "retail", "shop", "supermarket") ~ "Commercial",
      building %in% c("industrial", "warehouse") ~ "Industrial",
      building %in% c("school", "university", "college") ~ "Educational",
      building %in% c("hospital", "clinic") ~ "Healthcare",
      building %in% c("church", "mosque", "temple") ~ "Religious",
      building %in% c("yes", NA, "") ~ "Unspecified",
      TRUE ~ "Other"
    ))



  return(buildings_classified)
}
