//
//  WeatherModel.swift
//  OpenWeatherMap
//
//  Created by Ratinagiri Rhamachandran on 6/10/23.
//

///WeatherModel structure with object of the decoded data
struct WeatherModel {
    let conditionID: Int
    let cityName: String
    let temperature: Double
    
    var conditionName: String {
        switch conditionID {
        case 200...232:
            return "cloud.bolt"
        case 300...321:
            return "cloud.drizzle"
        case 500...531:
            return "cloud.rain"
        case 600...622:
            return "snowflake"
        case 700...781:
            return "tornado"
        case 801...804:
            return "cloud"
        default:
            return "sun.min"
        }
    }

    var temperatureString: String {
        return String(format: "%.1f", temperature)
    }
}
