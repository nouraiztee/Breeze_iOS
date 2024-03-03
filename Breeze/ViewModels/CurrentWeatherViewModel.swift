//
//  CurrentWeatherViewModel.swift
//  Breeze
//
//  Created by Nouraiz Taimour on 01/03/2024.
//

import Foundation

protocol LandingViewControllerDelegate: AnyObject {
    func didGetWeather(data: WeatherResponseModel)
    func didFailToGetWeather(withError error: Error)
}

protocol CurrentWeatherViewModelDelegate {
    func getWeatherInfo(forLocation location: String)
}

class CurrentWeatherViewModel {
    var apiServices: APIService
    weak var viewDelegate: LandingViewControllerDelegate?
    var weatherResponse: WeatherResponseModel?
    
    init(apiServices: APIService) {
        self.apiServices = apiServices
    }
    
    func getCurrentWeatherData(forLocation location: String = "") {
        let currentLoaction = location
        if currentLoaction.isEmpty {
            getUserLocation()
            return
        }
        
        apiServices.callCurrentWeatherAPI(forLocation: currentLoaction) { response in
            switch response {
            case .success(let responseModel):
                self.weatherResponse = responseModel
                self.viewDelegate?.didGetWeather(data: responseModel)
            case .failure(let error):
                self.viewDelegate?.didFailToGetWeather(withError: error)
            }
        }
    }
    
    private func getUserLocation() {
        LocationManager.shared.getLocation { location, error in
            if error != nil {
                
            }else {
                let currentLoaction = "\(location?.coordinate.latitude ?? 0.0), \(location?.coordinate.longitude ?? 0.0)"
                self.getCurrentWeatherData(forLocation: currentLoaction)
            }
        }
    }
    
    func getCurrentWeather() -> (temp: String, icon: String) {
        let temp = "\(weatherResponse?.current.tempC ?? 0)°C"
        let icon = getIconFromName(name: weatherResponse?.current.condition.text ?? "")
        
        return (temp, icon)
    }
    
    func getForeCastWeather() -> [(temp: String, icon: String)] {
        var forecastWeather: [(temp: String, icon: String)] = []
        
        if let forecastDay = weatherResponse?.forecast.forecastday {
            for forecast in forecastDay {
                let temp = "\(forecast.day.mintempC)°C"
                let icon = getIconFromName(name: forecast.day.condition.text)
                forecastWeather.append((temp, icon))
            }
        }
        return forecastWeather
    }
    
    func getCurrentLocationName() -> String {
        return "\(weatherResponse?.location.name ?? "Cuppertino"), \(weatherResponse?.location.region ?? "CA")"
    }
    
    func getCurrentLocationLatLong() -> String {
        return "\(weatherResponse?.location.lat ?? 0.0), \(weatherResponse?.location.lon ?? 0.0)"
    }
    
    private func getIconFromName(name: String) -> String {
        if name.lowercased().contains("clear") || name.lowercased().contains("sun") {
            return "sun.max.fill"
        }else if name.lowercased().contains("rain") {
            return "cloud.rain.fill"
        }else if name.lowercased().contains("cloudy"){
            return "cloud.sun.fill"
        }else if name.lowercased().contains("mist") {
            return "cloud.fog.fill"
        }else if name.lowercased().contains("overcast") {
            return "cloud.fill"
        }else if name.lowercased().contains("drizzle") {
            return "cloud.drizzle.fill"
        }else {
            return ""
        }
    }
    
    func getDays() -> [String] {
        var daysOfWeek: [String] = []
        for i in 1..<4 {
            let date = Date().addOrSubtractDay(day: i)
            let dayOfWeek = date.getDayOfWeek()
            daysOfWeek.append(dayOfWeek)
        }
        
        return daysOfWeek
    }
    
}

extension CurrentWeatherViewModel: CurrentWeatherViewModelDelegate {
    func getWeatherInfo(forLocation location: String) {
        getCurrentWeatherData(forLocation: location)
    }
}
