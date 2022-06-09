
##R Code Paul Scholefield 2022. This script will download Environment Agency DSM and DTM
##Tiles based on a polygon of your choice. The data will be converted to a canopy height model
##as 10 km cells (11 sq km) and then analysed on a 5 x 5 grid for canopy height and vegetation objects
##finally the data is merged back to a 100 sq km polygon and point dataset (shapefiles)
##If you want to get started I'm processing Dorset today. Shouldn;t take too long!
## thanks to the packaged developers of Foresttools and H Graham for the EA LIDAR scraper scripts.

rm(list=ls())

#install.packages("remotes")
#devtools::install_github('h-a-graham/EAlidaR')
#devtools::install_github('cran/SDMtools')
#install.packages(Ashop_sf)

library(EAlidaR)
library(RSelenium)
library(sf)
library(SDMTools)
library(rgdal)
library(maptools)
library(rgdal)
library(raster)
library(ForestTools)
library(SpaDES)
library(httr)
library(stringr)

#library(Ashop_sf)

#LIDAR_DATA_EXTENT <- st_read(
#  "N:/R/EA/EA_SurveyIndexFiles_SHP_Full/data/National_LIDAR_Programme_Index_Catalogue.shp")

LIDAR_DATA_EXTENT <- st_read(
  "N:/R/EA/OSGB_Grid_10km.shp")

LOCAL_AOI <- st_read("N:/Dorset/Dorset_dissolve.shp")


intersect <- st_intersection(LIDAR_DATA_EXTENT, LOCAL_AOI)
TILES <- intersect$TILE_NAME

ptm <- proc.time()

path=("N:/R/ea/temp/")

setwd("N:/R/ea/EAlidaR-master/data")


for (val in 1:length(TILES)) {

  TILENAME <- TILES[val]

  #TILENAME <- TILES[1]
  #NY20nw <- get_OS_tile_5km(OS_5km_tile = c('NY20nw','NY10ne)', resolution = 1, model_type = 'DTM',chrome_version = "102.0.5005.61",merge_tiles=TRUE, crop=TRUE, dest_folder = path,  out_name = "NY20NW"))
  DTM <- get_OS_tile_10km(OS_10km_tile = TILENAME , resolution = 1, model_type = 'DTM', chrome_version = "102.0.5005.61", dest_folder = path,  out_name = "TEMP_DTM.tif")
  DSM <- get_OS_tile_10km(OS_10km_tile = TILENAME , resolution = 1, model_type = 'DSM', chrome_version = "102.0.5005.61", dest_folder = path,  out_name = "TEMP_DSM.tif")

  setwd('N:/R/EA/temp')

  DSM <- raster("TEMP_DSM.tif")
  DTM <- raster("TEMP_DTM.tif")
  CHMlarge <- DSM - DTM


  CHMsplit <- splitRaster(CHMlarge,5,5)

  #rm(CHMlarge,DSM,DTM,x0,x1)

  for (num in 1:25) {

    CHM <- CHMsplit[[num]]
    lin <- function(x){x * 0.1 + 1
    #lin <- function(x){x * 0.06 + 0.8}
      }
    chm_sum <- summary(CHM)

    if (is.na(chm_sum[[5]]) | chm_sum[[5]]<1) {
      print("Null Data in Tile")
    }

    else {

      print(paste("Processing Tile:", TILENAME, ",", num))

      # Add dominant treetops
      ttops <- vwf(CHM = CHM, winFun = lin, minHeight = 1, maxWinDiameter = NULL)
      # Use 'mcws' to outline tree crowns
      crowns <- mcws(treetops = ttops, CHM = CHM, minHeight = 1, verbose = FALSE)
      # Create polygon crown map
      crownsPoly <- mcws(treetops = ttops, CHM = CHM, format = "polygons", minHeight = 1, verbose = FALSE)
      # Compute average crown diameter

      crownsPoly[["crownDiameter"]] <- sqrt(crownsPoly[["crownArea"]]/ pi) * 2

      # Plot crowns
      #plot(crowns, col = sample(rainbow(50), length(unique(crowns[])), replace = TRUE), legend = FALSE, xlab = "", ylab = "", xaxt='n', yaxt = 'n')


      filename1 <-  paste("CROWN",TILENAME)
      filename2 <-  paste("TREETOP",TILENAME)


      if (num<=1) {
        crownData <- crownsPoly
        treetops <- ttops
      } else {
        crownData <- bind(crownData,crownsPoly)
        treetops <- bind(treetops,ttops)
      }

      gc()

      rm(crownspoly,ttops)
    }
    gc()
  }
  gc()


  filename1 <-  paste("CROWN",TILENAME)
  filename2 <-  paste("TTOPS",TILENAME)

  writeOGR(crownData, layer = filename1, 'C:/temp', driver="ESRI Shapefile",overwrite_layer=T)
  writeOGR(treetops, layer = filename2, 'C:/temp', driver="ESRI Shapefile",overwrite_layer=T)

  rm(crownData)
  rm(treetops)


  proc.time() - ptm

}


