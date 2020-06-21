//
//  WeatherManager.swift
//  Clima
//
//  Created by Deepak Kumar Rout on 6/19/20.
//  Copyright © 2020 App Brewery. All rights reserved.
//

import Foundation

struct WeatherManager {
    let weatherURL = "https://api.openweathermap.org/data/2.5/weather?appid=280bbe4efdf3d2ae9a510b56ed9bdcf3&units=metric"
    
    
    func fetchWeather(cityName: String) {
        let urlString = "\(weatherURL)&q=\(cityName)"
        //componentUrl = createUrlComponents(city: cityName)
        performRequest(urlString: cityName)
    }
    
    func performRequest(urlString: String) {
        //1. Create URL
        print(urlString)
        //if let url = URL(string: urlString)  {
        
           
           //let url = URL(string: urlString)!
        let componentUrl = createUrlComponents(city: urlString)
            //print("url \(url)")
            // 2. Url session
            let session = URLSession(configuration: .default)
            guard let validUrl = componentUrl.url else {
                print("URL creation failed")
                return
            }
            
            //3. give the session a task
            let task = session.dataTask(with: validUrl, completionHandler: handle(data: response: error:))
            
            //4. start the task
            task.resume()
        //} else {
           // print("Error parsing URL")
       // }
        
  
        
    }
    
    func handle(data: Data?, response: URLResponse?, error: Error?) -> Void {
        
        if error != nil {
            print(error!)
            return
        }
        
        if let safeData = data {
            let dataString = String(data: safeData, encoding: .utf8)
            print(dataString!)
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
