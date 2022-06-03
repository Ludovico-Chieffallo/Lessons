install.packages("tigris")
library(tigris)
library(sf)
library(colorist)
library(ggplot2)

# calculate metrics, choose a palette, make a series of maps
m_fisher <- metrics_pull(fisher_ud)
p_fisher <- palette_timeline(9, start_hue = -40)
map_fisher <- map_multiples(m_fisher, p_fisher, lambda_i = -5, 
                            labels = paste("April", 7:15))


# download, transform, and crop spatial data
streams <- linear_water("NY", "Rensselaer") %>%
  st_transform(crs = st_crs(fisher_ud)) %>%
  st_crop(st_bbox(fisher_ud))

ponds <- area_water("NY", "Rensselaer") %>%
  st_transform(crs = st_crs(fisher_ud)) %>%
  st_crop(st_bbox(fisher_ud))

roads <- roads("NY", "Rensselaer") %>%
  st_transform(crs = st_crs(fisher_ud)) %>%
  st_crop(st_bbox(fisher_ud))

# add supplementary spatial data to the series of maps
map_fisher + 
  geom_sf(data = streams, linetype = 6, color = "lightblue4", size = 0.25) +
  geom_sf(data = ponds, linetype = 6, color = "lightblue4", fill = "lightblue", 
          size = 0.25) +
  geom_sf(data = roads, size = 0.25, color = alpha("black", 0.5)) +
  geom_sf(data = st_as_sfc(st_bbox(fisher_ud)), fill = NA, color = "gray", 
          size = 0.25)

# calculate distribution metrics  
m_fisher_distill <- metrics_distill(fisher_ud)

# download building footprints
f_buildings <- file.path(tempdir(), "buildings.rds")
download.file(paste0("https://github.com/mstrimas/colorist/raw/master/",
                     "data-raw/buildings.rds"),
              f_buildings)
buildings <- readRDS(f_buildings)
unlink(f_buildings)

# make a map
map_fisher_distill <- map_single(m_fisher_distill, p_fisher, 
                                 lambda_i = -5, lambda_s = 10) +
  geom_sf(data = streams, linetype = 6, color = "lightblue4", size = 0.25) +
  geom_sf(data = ponds, linetype = 6, color = "lightblue4", fill = "lightblue", 
          size = 0.25) +
  geom_sf(data = roads, size = 0.25, color = alpha("black", 0.5)) +
  geom_sf(data = buildings, size = 0.25, color = alpha("black", 0.5)) +
  geom_sf(data = st_as_sfc(st_bbox(fisher_ud)), fill = NA, color = "black", 
          size = 0.25)

# show the map
print(map_fisher_distill)

# create a legend using default settings
legend_timeline(p_fisher)

# change labels of legend
l_fisher <- legend_timeline(p_fisher, 
                            time_labels = c("Apr 7", "Apr 15"),
                            # intensity label
                            label_i = "Peak use", 
                            # layer label
                            label_l = "Night of peak use",
                            # specificity labels
                            label_s = c("Ephemeral use", "Occasional use", "Consistent use")) 

# show legend
print(l_fisher)

# position legend to the left of the map
map_fisher_distill +
  coord_sf(xlim = c(-4300, 2150)) +
  annotation_custom(ggplotGrob(l_fisher), 
                    xmin = -4400, xmax = -2500, 
                    ymin = 5100266, ymax = 5104666) 
