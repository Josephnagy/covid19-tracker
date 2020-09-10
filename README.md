# Mobile App Development (COMPSCI 290) Final Project

## Project Overview 

### Project Goal

- Create a resource for people to get updated and accurate information about COVID-19
- Make it easy for users to find information about COVID-19 in any part of the world 
- Update users about the changes in COVID-19 cases in their local area

### Features

- [ ] Daily Alert
  - [ ] Click daily update button to launch an alert with updated stats in your county or country based on your current location 
  - [ ] The alert displays curent location, population, current cases and deaths, daily change in cases and deaths, as well as weekly change in cases and deaths
- [ ] Daily Notification
  - [ ] Reminds you to track the coronavirus daily. Local notification. (Currently set to 5PM, can change in AppDelegate)
- [ ] Global Map
  - [ ] Tracks & Zooms to Current Location
  - [ ] Pins for US counties + Provinces/Regions in Canada, China, and Australia + Rest of Countries Worldwide
  - [ ] Search Bar: locate over 3000 pins and zoom in to specific pins

  
### Project Architecture

#### Frontend

- This project uses the UIKit, MapKit, CoreLocation, and UserNotification frameworks.

- MapKit framework - for COVID-19 heat map | Core Location - for updated location and daily update | Local Notification - for daily reminder notification

#### Backend

- This project uses a Flask server. 

- We update the data daily (after 8PM EST) and host it in JSON format here: [JSON](https://nash-273721.df.r.appspot.com/map)

#### Data
- We use the [2019 Novel Coronavirus COVID-19 (2019-nCoV) Data Repository by Johns Hopkins CSSE](https://github.com/CSSEGISandData/COVID-19). 
- We combine all of the time series data, which be found in 5 separate CSV files [here](https://github.com/CSSEGISandData/COVID-19/tree/master/csse_covid_19_data/csse_covid_19_time_series), and clean the data so that the map pins work more smoothly. 
- See online/updates.py for the data collection and data cleaning code, which is a python script that uses Pandas DF. 


## Demo

### Demo Video 
[Video](https://drive.google.com/file/d/1G-e2B-u51MD9_V_EXvgqa8-2tQYzi17l/view?usp=sharing)
### Demo Slides 
[Slides](https://docs.google.com/presentation/d/1k_aOUrA9rAgZsCnhqjPoiRdui3HZZuxMIgBJ8S3GMj4/edit?usp=sharing)
### Build and Error Handling Details
- Portrait Mode only
- Constaints allow for build with iPhone 11, iPhone 8, and iPad models
- Handles cases with No Internet and Location Services Diasbled smoothly
- Works with most simulated locations (anywhere in USA, London, Sydney, Moscow, ...)
- GPX files included for some locations as well, including VeniceItaly.gpx
- Note that the app simulator is buggy, so it may not recognize the default location (which is set to San Fran on iPhone 11 Pro Max) during the first attempt to build. If this happens, just try again please. It is better to simulate on a phone if possible. 

## Team 

### Team Members 
Jake Derry,  Ava LeWinter, Jahaan Mukhi, Joseph Nagy, David Rothblatt, Sam Snedeker

### Team Contributions 

David
- Data Collection & Cleaning 
- Daily Alert Feature 
- App Integration & Task Delegation

Jake
- Server 
- Location Services

Joe 
- MapViewController
- Map Search Bar

Jahaan 
- MapViewController
- Map Pins and Gradient 

Sam 
- Location Services
- Reminder Notification 
- UI/UX (homepage & constraints)

Ava 
- Reminder Notification / Daily Alert 
- UI/UX (homepage & constraints)
