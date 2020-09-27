//
//  WeatherPresentationController.swift
//  Weather
//
//  Created by Matheus Ruschel on 2020-09-27.
//  Copyright © 2020 Matheus Ruschel. All rights reserved.
//

import Foundation
import CoreLocation
import UIKit

protocol WeatherPresentationControllerDelegate: class {
    func didFinishLoadingWeather(formattedTemperature: String, locationName: String)
    func didFinishLoadingWeatherIcon(icon: UIImage?)
    func didFinishLoadingWeather(errorMsg: String)
}
 
class WeatherPresentationController: NSObject {
    
    var communicator: WeatherAPICommunicator
    var locationManager: CLLocationManager = CLLocationManager()
    weak var delegate: WeatherPresentationControllerDelegate?
    var locationManagerRetrievedLocation = false
    
    init(communicator: WeatherAPICommunicator) {
        self.communicator = communicator
    }
    
    func accessLocation() {
        self.locationManager.requestAlwaysAuthorization()
        self.locationManager.requestWhenInUseAuthorization()

        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
        }
    }
    
    func fetchWeatherInformation(isMetric: Bool,
                                 latitude: Double,
                                 longitude: Double) {
        
        let unit = isMetric ? "metric" : "imperial"
        
        communicator.fetchWeatherInformation(unit: unit,
                                             latitude: latitude,
                                             longitude: longitude,
                                             completion: { [weak self] status in
            
            switch status {
            case .success(let weather):
                if let temperature = weather.currentTemperature, let name = weather.locationName {
                    let temperatureInt = Int(temperature)
                    var tempMeasure: String
                    if isMetric {
                        tempMeasure = "celcius"
                    } else {
                        tempMeasure = "farenheit"
                    }
                    
                    self?.delegate?.didFinishLoadingWeather(
                        formattedTemperature: "\(temperatureInt) " + tempMeasure,
                        locationName: name)
                    if let iconName = weather.iconName {
                        self?.loadWeatherIcon(iconName: iconName)
                    }
                }
                
            case .error(let errorMsg):
                self?.delegate?.didFinishLoadingWeather(errorMsg: errorMsg)
            }
        })
    }
    
    func loadWeatherIcon(iconName: String) {
        communicator.loadWeatherIcon(name: iconName, completion: { [weak self] status in
                       
                       switch status {
                       case .success(let data):
                        self?.delegate?.didFinishLoadingWeatherIcon(icon: UIImage(data: data))
                       case .error(let errorMsg):
                           self?.delegate?.didFinishLoadingWeather(errorMsg: errorMsg)
                       }
        })
    }
}
extension WeatherPresentationController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let locValue: CLLocationCoordinate2D = manager.location?.coordinate else { return }
        let locale = Locale.current
        if !locationManagerRetrievedLocation {
            locationManagerRetrievedLocation = true
            fetchWeatherInformation(isMetric: locale.usesMetricSystem, latitude: locValue.latitude, longitude: locValue.longitude)
        }
        
    }
}
