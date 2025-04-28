# denscity

denscity is an R package that automates the process of calculating, exporting, and visualizing building density and building functional types based on OpenStreetMap (OSM) building polygons.

## Features
1. Retrieve OSM Data: Automatically download city boundaries and building data from OpenStreetMap.

2. Calculate Building Density: Compute building area density as a percentage of land area for administrative units.

3. Classify Building Types: Categorize buildings by their functional use based on OSM building=* tags.

4. Visualize Building Density and Building Types: Create clean and quick Choropleth maps of building density as well as visualizes building functional types across districts.

5. Export Results: Save GPKG of outputs for further use.

## Installation

denscity is not yet on CRAN. You can install it from GitHub:

Install devtools if you don't have it
``` 

install.packages("devtools")

library(devtools)
install_github("WajihaYasmeen1/denscity")
```

## Usage

### For Building Density
```
library(denscity)


city_name <- "Wuerzburg"
admin_level <- 8 
bbox <- NULL

#Calculate building density for Würzburg at admin_level 8
building_density_result <- calculate_building_density(city_name, admin_level, bbox)

# Visualize the density map
density_column <- "build_density"
city_name <- "Wuerzburg"
> plot_building_density(building_density_result,  city_name = "",density_column)

# Export the results
export_build_density(building_density_result, filename = 'wue_building_density.gpkg')
```
<img width="520" alt="build_density" src="https://github.com/user-attachments/assets/abf8701a-f74e-4497-80a2-91cce672804f" />




### For Building Type Classification
```
library(denscity)

#Classify building types for Würzburg
city_name <- "Wuerzburg"
classified_buildings <- classify_osm_buildings(city_name, bbox = NULL)

# Export the results
export_classified_gpkg(classified_buildings, filename = 'wurzburg_classified_buildings.gpkg')

# Visualize the building types
city_name <- "Wurzburg"
attribute <- "building_type"
plot_building_types(classified_buildings, attribute, city_name)


```

<img width="437" alt="build_classify" src="https://github.com/user-attachments/assets/4bf523dc-7b62-402e-b2da-60aa4416966f" />

*Note: Before assigning the admin_level, make sure to check [here](https://wiki.openstreetmap.org/wiki/Tag:boundary%3Dadministrative) if the selected boundry level exists for your region of interest.*

## References
[Choropleth Maps](https://r-graph-gallery.com/choropleth-map.html)

[Building Density using R](https://towardsdatascience.com/calculating-building-density-in-r-with-osm-data-e9d85c701e19/)

