# EALIDAR_VegetationObjects
This code uses an EA LIDAR data scraper developed by H Graham combined with the 
ForestTools library to model the surface of the UK 100 sq km at a time

You'll need an area shapefile to get started, and the 10 sq km shapefile to name the tiles. 
You will also need to navigate the installation of Selenium, the chrome drivers, and also forest tools toolbox.

Details for the installation are held here: https://github.com/h-a-graham/EAlidaR

This script will download Environment Agency DSM and DTM
Tiles based on a polygon of your choice. The data will be converted to a canopy height model
as 10 km cells (100 sq km) and then analysed on a 5 x 5 grid for canopy height and vegetation objects
finally the data is merged back to a 100 sq km polygon and point dataset (shapefiles)

This code will model the surface of England if you feed it a coastal shapefile.
Thanks to the package developers of Foresttools and H Graham for the EA LIDAR scraper scripts.

This code would be best running with parallel processing, as the processing should be distributed across a
cluster ideally.

Good luck!
