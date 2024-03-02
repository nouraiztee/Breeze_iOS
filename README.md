Breeze - Weather App
  A simple weather app that show weather based on user's current location and provide a way to search for any location.


Architecture -  

  Breeze app is implemented using Model View ViewModel (MVVM) architecture pattern in two ways. (Delgates and Observors)

Structure - 

  "ViewController" contains all files for view and view logic.
  "ViewModel" conatisn all files responsible for getting remote data and making it presentable for view.
  "APIService" contains all logic for API calling and passing the response to Viewmodels
  "Model" conatains data model struct to map api response.

Design - 

  A very simple design is followed in Breeze.
  Top section show current weather condition through an image and current tempurate underneath the image.
  Bottom section shows forecats temp fpr next 3 days (Day, weather condition, temp)

Functionality - 

  Breeze allows user to see see current location weather (location shown on top on nav bar)
  User can refresh his weather status
  User can search for a new location using the search button on nav bar

API - 

  WeatherAPI (http://api.weatherapi.com/v1) is used to fecth location weather and location data.






