//
//  WeatherManager.swift
//  Clima
//
//  Created by Deepak Kumar Rout on 6/19/20.
//  Copyright © 2020 App Brewery. All rights reserved.
//

import Foundation

protocol WeatherManagerDelegate {
    func didUpdateWeather(_ weatherManager: WeatherManager, weather: WeatherModel)
    func didFailWithError(error: Error)
}

struct WeatherManager {
    let weatherURL = "https://api.openweathermap.org/data/2.5/weather?appid=280bbe4efdf3d2ae9a510b56ed9bdcf3&units=metric"
    var delegate: WeatherManagerDelegate?
    
    func fetchWeather(cityName: String) {
        let urlString = "\(weatherURL)&q=\(cityName)"
        //componentUrl = createUrlComponents(city: cityName)
        performRequest(with: cityName)
    }
    
    func performRequest(with urlString: String) {
        //1. Create URL
        print(urlString)
        
        let componentUrl = createUrlComponents(city: urlString)
        
        // 2. Url session
        let session = URLSession(configuration: .default)
        guard let validUrl = componentUrl.url else {
            print("URL creation failed")
            return
        }
        
        //3. give the session a task
        let task = session.dataTask(with: validUrl, completionHandler: { (data, response, error) in
            
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
            //print(weather.conditionName)
            return weather
            
        } catch {
            // print(error)
            self.delegate?.didFailWithError(error: error)
            return nil
        }
        
    }
    
    
    
    func createUrlComponents(city: String) -> URLComponents {
        var componentURL = URLComponents()
        
        componentURL.scheme = "https"
        componentURL.host = "api.openweathermap.org"
        componentURL.path = "/data/2.5/weather"
        componentURL.query = "appid=280bbe4efdf3d2ae9a510b56ed9bdcf3&units=metric&q=\(city)"
        //componentURL.queryItems =  [URLQueryItem(name: "appid", value: "280bbe4efdf3d2ae9a510b56ed9bdcf3"),URLQueryItem(name: "units", value: "metric"),URLQueryItem(name: "q", value: city)] //"appid=280bbe4efdf3d2ae9a510b56ed9bdcf3&units=metric&q=\(city)"
        
        return componentURL
    }
    
    
}
