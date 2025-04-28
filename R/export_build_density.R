#' Export classified building types to a GPKG file
#'
#' @param data    #resultant file from the "calculate_building_density" function
#' @param filename    #name of the output GPKG file
#'
#'
#'
export_build_density <- function(data, filename) {
  library(sf)
  library(dplyr)

  #write to GPKG
  st_write(data, dsn = filename, layer = "building_density", driver = "GPKG", delete_dsn = TRUE)

}
