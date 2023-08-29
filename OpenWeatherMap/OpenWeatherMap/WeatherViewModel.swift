//
//  WeatherViewModel.swift
//  OpenWeatherMap
//
//  Created by Ratinagiri Rhamachandran on 6/10/23.
//

import UIKit

/// Constructs the URL for networking and to fetch the weather data
struct Constants {
    static let baseURLString = "https://api.openweathermap.org/data/2.5/weather"
    static let appid = "74bb56bdcffbfd56a5ac8df1241d9931"
    static let units = "metric"
}

protocol WeatherManagerDelegate {
    func didUpdateWeather(_ weatherManager: WeatherViewModel, weather: WeatherModel)
    func didFailWithError(error: OpenWeatherError)
}

/// Networking is performed here
struct WeatherViewModel {

    var delegate: WeatherManagerDelegate?
 /// Method to construct the url string based on the city name given by the user
    /// - Parameter - Name of the city
    func fetchWeather(cityName: String) {
        let urlString = "\(Constants.baseURLString)?appid=\(Constants.appid)&units=\(Constants.units)&q=\(cityName)"
        performRequest(with: urlString)
    }
/// Method to construct the url string based on the latitude and longitude value
    /// -Parameter - Latitude and Longitude of the location of the user
    func fetchWeather(latitude:Double, longitude:Double) {
        let urlString = "\(Constants.baseURLString)?appid=\(Constants.appid)&units=\(Constants.units)&lat=\(latitude)&lon=\(longitude)"
        performRequest(with: urlString)
    }
    
///To create an URL, Session, Task and to perform networking to fetch the weather data from the OpenWeatherAPI in JSON format
    ///-Parameter - URL string constructed from the above functions are passed here
    private func performRequest(with urlString: String) {
        ///URL is created
        if let url = URL(string: urlString) {
            /// URL Session is created
            let session = URLSession(configuration: .default)
            /// task is created
            let task = session.dataTask(with: url) { (data, response, error) in
                    if let error = error {
                        delegate?.didFailWithError(error: .networkError(error))
                        return
                    }
                    
                    guard let data = data else {
                        delegate?.didFailWithError(error: .nilData)
                        return
                    }
                    
                    let decoder = JSONDecoder()
                    do {
                        let decodedData = try decoder.decode(WeatherData.self, from: data)
                        let weather = WeatherModel(
                                conditionID: decodedData.weather.first?.id ?? 0,
                                cityName: decodedData.name,
                                temperature: decodedData.main.temp
                            )
                        delegate?.didUpdateWeather(self, weather: weather)
                    } catch {
                        delegate?.didFailWithError(error: .parsingError)
                    }
                    
            }
            /// task is triggerred.
            task.resume()
        } else {
            delegate?.didFailWithError(error: .invalidURL)
        }
    }
    
}

/// Enum for error is created where each case represents a specific type of error that can occur while working with OpenWeather API.
enum OpenWeatherError: Error {
    case invalidURL
    case nilData
    case parsingError
    case networkError(Error)
    
    var localizedDescription: String {
        switch self {
        case .invalidURL:
            return "Invalid URL"
        case .nilData:
            return "No data received"
        case .parsingError:
            return "Error parsing data"
        case .networkError(let error):
            return error.localizedDescription
        }
    }
}
