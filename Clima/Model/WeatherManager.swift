//
//  WeatherManager.swift
//  Clima
//
//  Created by Deepak Kumar Rout on 6/19/20.
//  Copyright © 2020 App Brewery. All rights reserved.
//

import Foundation
import CoreLocation

protocol WeatherManagerDelegate {
    func didUpdateWeather(_ weatherManager: WeatherManager, weather: WeatherModel)
    func didFailWithError(error: Error)
}

struct WeatherManager {
    
    var delegate: WeatherManagerDelegate?
    
    func fetchWeather(with cityName: String) {
        
        let componentUrl = createUrlComponents(with: [URLQueryItem(name: "q", value: cityName)])
        performRequest(with: componentUrl)
    }
    
    func fetchWeather(withLatLong latitude: CLLocationDegrees, longitude: CLLocationDegrees) {
        let queryItems = [URLQueryItem(name: "lat", value: String(format:"%f", latitude)),URLQueryItem(name: "lon", value: String(format:"%f", longitude))]
        let componentUrl = createUrlComponents(with: queryItems)
        performRequest(with: componentUrl)
    }
    
    func performRequest(with componentUrl: URLComponents) {
        
        // 2. Url session
        let session = URLSession(configuration: .default)
        guard let validUrl = componentUrl.url else {
            print("URL creation failed")
            return
        }
        
        //3. give the session a task
        _ = session.dataTask(with: validUrl, completionHandler: { (data, response, error) in
            
            if error != nil {
                // print(error!)
                self.delegate?.didFailWithError(error: error!)
                return
            }
            
            if let safeData = data {
                if let weather = self.parseJSON(safeData) {
                    self.delegate?.didUpdateWeather(self,weather: weather)
                }
            }
            
        }).resume()
        
    }
    
    func parseJSON(_ weatherData: Data) -> WeatherModel? {
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(WeatherData.self, from: weatherData)
            let id = decodedData.weather[0].id
            let temp = decodedData.main.temp
            let name = decodedData.name
            let weather = WeatherModel(conditionId: id, citiName: name, temprature: temp)
            return weather
            
        } catch {
            self.delegate?.didFailWithError(error: error)
            return nil
        }
        
    }
    
    
    
    func createUrlComponents(with queryItems: [URLQueryItem]) -> URLComponents {
        var componentURL = URLComponents()
        
        componentURL.scheme = "https"
        componentURL.host = "api.openweathermap.org"
        componentURL.path = "/data/2.5/weather"
        componentURL.queryItems =  [URLQueryItem(name: "appid", value: "280bbe4efdf3d2ae9a510b56ed9bdcf3"),URLQueryItem(name: "units", value: "metric")] + queryItems
        return componentURL
    }
    
    
}
