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
        performRequest(urlString: urlString)
    }
    
    func performRequest(urlString: String) {
        //1. Create URL
        
        if let url = URL(string: urlString)  {
            // 2. Url session
            let session = URLSession(configuration: .default)
            
            //3. give the session a task
            let task = session.dataTask(with: url, completionHandler: handle(data: response: error:))
            
            //4. start the task
            task.resume()
        }
        
  
        
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
}