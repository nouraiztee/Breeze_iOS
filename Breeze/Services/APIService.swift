//
//  APIService.swift
//  Breeze
//
//  Created by Nouraiz Taimour on 01/03/2024.
//

import Foundation

class APIService {
    
    let baseURL = "https://api.weatherapi.com/v1/"
    let weatherPath = "forecast.json?key="
    let searchPath = "search.json?key="
    let APIKey = "c75b0b98eb2f4cfeb0981014240103"
    var daysOfForecast = "3"
    var location = ""
    
    func callCurrentWeatherAPI(forLocation location: String, responseHandler: @escaping (Result<WeatherResponseModel, Error>) -> Void) {
        var finalURL = baseURL + weatherPath + APIKey + "&q=" + location
        finalURL = finalURL +  "&days=" + daysOfForecast
        if let url = URL(string: finalURL) {
            
            URLSession.shared.dataTask(with: url) { data, response, error in
                if error != nil {
                    responseHandler(.failure(error!))
                }else {
                    do {
                        if let data = data {
                            let responseModel = try JSONDecoder().decode(WeatherResponseModel.self, from: data)
                            responseHandler(.success(responseModel))
                        }
                    }catch(let error) {
                        responseHandler(.failure(error))
                    }
                }
            }.resume()
        }
    }
    
    func callSearchAPI(forLocation location: String, responseHandler: @escaping (Result<[SearchResponseModel], Error>) -> Void) {
        let finalURL = baseURL + searchPath + APIKey + "&q=" + location
        if let url = URL(string: finalURL) {
            
            URLSession.shared.dataTask(with: url) { data, response, error in
                if error != nil {
                    responseHandler(.failure(error!))
                }else {
                    do {
                        if let data = data {
                            let responseModel = try JSONDecoder().decode([SearchResponseModel].self, from: data)
                            responseHandler(.success(responseModel))
                        }
                    }catch(let error) {
                        responseHandler(.failure(error))
                    }
                }
            }.resume()
        }
    }
    
}
