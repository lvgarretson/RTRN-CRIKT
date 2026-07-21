# RTRN-CRIKT
<b> By Team 9  &#129431;<br><b>

## Quick App Overview:


<b>Project Description:</b> An app that monitors gym air quality (AQI) and provides gym users and managers with actionable steps to improve the quality of the gym to improve workout performance and healthiness at the benefit of the gym. 

<br><b>Features:</b> Simple UI that visually plots and graphs data, then gives users informaton and actionable steps to improve workout performance or gym experience. 

<br><b>Intended Audience:</b> Gym managers and gym users

<br><b>Data/Metrics:</b> <li>AQI (Air Quality Index)</li><li>Temperature</li><li>Humidity</li><li>CO2</li><li>TVOC (Total Volatile Organic Compounds)</li>

<br><b>Limitations:</b> Currently only uses sample data. The sensors assume the data is collected in 1 minute intervals. The data displayed for the AQI is the last data collected, so all of them fall on the same range.

---

## How to start the App:

<b> To  start the app, access InitialApp.mlapp on Matlab and press run. After clicking the screen and selecting a role, the information for that user type should be displayed. To change the type of graph and the area for the AQI use the dropdowns.</b>

<b> <ins>App Tutorial:</ins> [Video](https://www.youtube.com/watch?v=3AtxF_1PoH8)</b>

---

## How the App Works:

<b>The app first processes the data from the sensors. It does this by first deleting the NAN values and then smoothering data by using the mean of all of the values in the same timespan. Then this values are presented as graph where each different color represents a different area inside of the gym. </b>

<b>The app also gets the lasted data from the sensors and using the deviation from the average values provided by air_quality_reference.mat and the formula for AQI provided by the US EPA. This value is both displayed in the gauge and in a status bar at the bottom that changes color according to a range of values. </b>

<b>The app is also able to share information between the different matlab apps (each of the different screens) using app input arguments. The information shared is both the dataset and the roles selected. </b>

---
