# EALIDAR_VegetationObjects
This code uses an EA LIDAR data scraper developed by H Graham combined with the 
ForestTools library to model the surface of the UK 100 sq km at a time

You'll need an area shapefile to get started, and the 10 sq km shapefile to name the tiles. 
You will also need to navigate the installation of Selenium, the chrome drivers, and also forest tools toolbox.

Details for the installation are held here: https://github.com/h-a-graham/EAlidaR

This script will download Environment Agency DSM and DTM
Tiles based on a polygon of your choice. The data will be converted to a canopy height model
as 10 km cells (11 sq km) and then analysed on a 5 x 5 grid for canopy height and vegetation objects
finally the data is merged back to a 100 sq km polygon and point dataset (shapefiles)

If you want to get started I'm processing Dorset. Shouldn;t take too long to model the surface of the UK.
Thanks to the packaged developers of Foresttools and H Graham for the EA LIDAR scraper scripts.

Good luck!
