//
//  WeatherData.swift
//  Clima
//
//  Created by Deepak Kumar Rout on 6/21/20.
//  Copyright © 2020 App Brewery. All rights reserved.
//

import Foundation

struct WeatherData: Codable {
    let name: String
    let main:  Main
    let weather: [Wheather]
}

struct Main: Codable {
    let temp: Double

}

struct Wheather: Codable {
    let description: String
    let id: Int
}
