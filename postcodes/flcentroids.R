# CODES FOR IDENTIFYING AND MAPPING POSTCODE CENTROIDS IN FINLAND

# install from CRAN
# install.packages("geofi")
# install.packages("sf")
# install.packages("dplyr")
# install.packages("ggplot2")
# install.packages("foreign")
# install.packages("tidyverse")
# install.packages("broom")
# install.packages("ggspatial")

library(geofi)
library(sf)
library(dplyr)
library(ggplot2)
library(foreign)
library(tidyverse)
library(broom)
library(ggspatial)

setwd("C:/Users/sba4/OneDrive - University of St Andrews/PhD Paper 2/Stata-do")

# Locating centroids

zip <- get_zipcodes(year = 2020)
zip_centroids <- st_centroid(zip)
zip_coord <- st_coordinates(zip_centroids)

posti <- zip_centroids %>%
  select(namn, posti_alue, geom)

ziplabels <- posti %>%
  select(namn, posti_alue)

# Generate orig-dest data

postcode <- ziplabels %>%
  mutate(long = unlist(map(ziplabels$geom,1)),
         lat = unlist(map(ziplabels$geom,2))) %>%
  select(posti_alue, long, lat)
pc <- data.frame(postcode) %>% select(posti_alue, long, lat)

pcpair <- pc %>%
  setNames(paste0(names(.), '_2')) %>%
  crossing(pc)
pcpair <- rename(pcpair,
                 orig = "posti_alue_2",
                 orig_long = "long_2",
                 orig_lat = "lat_2",
                 dest = "posti_alue",
                 dest_long = "long",
                 dest_lat = "lat")

pcpair <- pcpair[,c(1,4,2,3,5,6)]
haven::write_dta(pcpair, "postcodes/pcpairmat.dta")

# Map centroids

map_postcode <- ggplot() +
  geom_sf(data = zip) +
  geom_sf(data = zip_centroids, color = "#002F6C", size = 0.5, fill = "transparent") +
  annotation_scale()
map_postcode

ggsave("graphs/Fig_S1.svg", bg = "transparent", width = 2000, height = 3000, unit = "px")

# Calculating geodesic distance

d_list <- list()
ziplabels <- sf::st_drop_geometry(posti) %>%
  select(namn, posti_alue)
for (i in 1:nrow(posti)) {
  dist_tmp <- sf::st_distance(x = posti[i,], y = posti)
  tibble(origin_name = posti[i,]$namn,
         origin_code = posti[i,]$posti_alue) %>%
    bind_cols(ziplabels %>% rename(destination_name = namn,
                                   destination_code = posti_alue)) %>%
    mutate(dist = dist_tmp[1,]) -> d_list[[i]]
}
zip_dist <- do.call("bind_rows", d_list) %>%
  mutate(dist = as.numeric(dist))
head(zip_dist)

write.dta(zip_dist,"postcodes/zip_dist.dta")

# Calculate postcode area in Helsinki

zip$area <- sf::st_area(zip)

ziparea <- zip %>% mutate(km2 = area/1000000)
median(ziparea$km2)
mean(ziparea$km2)
hist(ziparea$km2, breaks = 50)

helsinki <- ziparea %>% subset(kunta == "091")
median(helsinki$km2)
hist(helsinki$km2, breaks = 10)
