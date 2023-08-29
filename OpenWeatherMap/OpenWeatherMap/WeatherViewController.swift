//
//  ViewController.swift
//  OpenWeatherMap
//
//  Created by Ratinagiri Rhamachandran on 6/10/23.
//

import UIKit
import CoreLocation

class WeatherViewController: UIViewController {
    
    private var weatherManager = WeatherViewModel()
    private var locationManager = CLLocationManager()
    
    @IBOutlet weak private var conditionImageView: UIImageView!
    @IBOutlet weak private var temperatureLabel: UILabel!
    @IBOutlet weak private var cityLabel: UILabel!
    @IBOutlet weak private var searchTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.delegate = self
        ///Triggering permission request seeking access to user's current location.
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
        weatherManager.delegate = self
        searchTextField.delegate = self
    }
    /// Method to fetch the current location of the user
    @IBAction private func locationButtonPressed(_ sender: UIButton) {
        locationManager.requestLocation()
    }
}

//MARK: - UITextFieldDelegate

extension WeatherViewController: UITextFieldDelegate {
     
    @IBAction func searchPressed(_ sender: UIButton) {
        searchTextField.endEditing(true)
    }
    /// Text field delegate method, the keyboard is hidden here
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.endEditing(true)
        return true
    }
    /// Text field delegate method, user entered city name is cleared after search or to display the placeholder text
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if searchTextField.text != "" {
            return true
        }else{
            searchTextField.placeholder = "Type Something"
            return false
        }
    }
    ///Text field delegate method, fetchWeather method in the WeatherViewModel is called here.
    func textFieldDidEndEditing(_ textField: UITextField) {
        if let city = searchTextField.text {
            //If the user enters a city with two words (ex. New York), the API does not fetches the weather data, hence formatted the city name in the below format.
            let formattedName = city.replacingOccurrences(of: " ", with: "%20")
            weatherManager.fetchWeather(cityName: formattedName)
        }
        searchTextField.text = ""
    }
}

//MARK: - WeatherManagerDelegate

extension WeatherViewController: WeatherManagerDelegate {
    
    ///Delegate method, WeatherModel data is passed to the UI Elements of the screen
    func didUpdateWeather(_ weatherManager: WeatherViewModel, weather: WeatherModel) {
        
        DispatchQueue.main.async {
            self.temperatureLabel.text = weather.temperatureString
            self.conditionImageView.image = UIImage(systemName: weather.conditionName)
            self.cityLabel.text = weather.cityName
        }
    }
    ///Delegate method, in case of error, error message will be printed
    func didFailWithError(error: OpenWeatherError) {
        print(error)
        DispatchQueue.main.async {
            let alert = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Okay", style: .cancel))
            self.present(alert, animated: true, completion: nil)
        }
    }
}

//MARK: - CLLocationManagerDelegate
extension WeatherViewController: CLLocationManagerDelegate {
    /// Delegate Method, User's location coordinats are retrieved and passed to the fetchWeather method in the WeatherViewModel
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {

        if let location = locations.last {
            locationManager.stopUpdatingLocation()
            let lat = location.coordinate.latitude
            let lon = location.coordinate.longitude
            weatherManager.fetchWeather(latitude: lat, longitude: lon)
        }
    }
    ///Delegate method, in case of error, error message will be printed
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
}


