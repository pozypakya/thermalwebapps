#Problem Statement

Electric power utilities are faced with an aging infrastructure, increasing risk of blackouts and brownouts. 
A brownout is a drop in voltage in an electrical power supply, so named because it typically causes lights to dim. Utilities also face costly unplanned maintenance and rising costs.Utilities are looking for ways to address these issues in order to improve the reliability of electric power delivery while at the same time reducing costs. By using thermal imaging cameras and automation software, future equipment failures can be detected anytime, day or night, at a remote monitoring location. The net effect is increased reliability and reduced cost.


#Proposed Solution

*	Development of a mobile application to capture thermal images.
*	Taking images from various TM Utilities ( MSAN, DSLAM, CABINETS, etc. )  
*	Obtaining GPS location of the selected equipment.
*	Thermal image processing extraction using standard FLIR images via Exif.
*	Quantitative way detection of the outlier of thermal images.
*	Clustering the temperature matrix and getting the temperature reading (min, max, average).
*	Thermal image gallery display via OpenShift (PHP Application Hosting)

#Software Development

## 1) Thermal WebApps with PHP 
### Thermal Image Browser & Location

This is a collection of functions for assisting in converting extracted raw data from infrared thermal images and converting them to estimate temperatures using standard equations in thermography. Provides an open source proxy tool for assisting with infrared thermographic analysis. The version here on github is the current, development version. 

*	Development Tools : PHP , NotePad++
*	Database : MySQL 

## 2) Thermal Android Apps with JAVA 
### Thermal Image Capture & Uploader

*	Development Tools : JAVA 1.7 & NetBeans 8.1 
*	SDK : FlirSDK , Gradle Plugins , Android SDK 25.2.5

This is a collection of functions for assisting in converting extracted raw data from infrared thermal images and converting them to estimate temperatures using standard equations in thermography. Provides an open source proxy tool for assisting with infrared thermographic analysis. The version here on github is the current, development version. 

## 3) Thermal Analysis with R Language
### Thermal Image Converter and Analytics

*	Development Tools : RStudio 0.99 
*	SDK : ThermImage R package , ExifTools   

This is a collection of functions for assisting in converting extracted raw data from infrared thermal images and converting them to estimate temperatures using standard equations in thermography. Provides an open source proxy tool for assisting with infrared thermographic analysis. The version here on github is the current, development version. 
