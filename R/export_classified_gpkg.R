#' Export classified building types to a GPKG file
#'
#' @param data #resultant file from the "classify_osm_buildings" function
#' @param filename    #name of the output GPKG file



export_classified_gpkg <- function(data, filename) {
  library(sf)
  library(dplyr)

  #write to GPKG
  st_write(data, dsn = filename, layer = "buildings", driver = "GPKG", delete_dsn = TRUE)

}

