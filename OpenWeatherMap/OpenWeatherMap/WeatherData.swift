//
//  WeatherData.swift
//  OpenWeatherMap
//
//  Created by Ratinagiri Rhamachandran on 6/10/23.
//

/// Data Model to decode the JSON data from the OpenWeather API to Swift structure.
struct WeatherData: Decodable {
    let name: String
    let main: Main
    let weather: [Weather]
}

struct Main: Decodable {
    let temp: Double
}

struct Weather: Decodable {
    let description: String
    let id: Int
}
