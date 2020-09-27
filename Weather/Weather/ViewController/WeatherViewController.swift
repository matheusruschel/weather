//
//  WeatherViewController.swift
//  Weather
//
//  Created by Matheus Ruschel on 2020-09-27.
//  Copyright © 2020 Matheus Ruschel. All rights reserved.
//

import UIKit
import CoreLocation

class WeatherViewController: UIViewController {
    
    @IBOutlet weak var imageViewIcon: UIImageView!
    @IBOutlet weak var labelTemperature: UILabel!
    @IBOutlet weak var labelLocation: UILabel!
    
    var controller: WeatherPresentationController!

    override func viewDidLoad() {
        super.viewDidLoad()
        labelTemperature.text = ""
        labelLocation.text = ""
    
        let communicator = URLSessionWeatherCommunicator(baseUrl: "https://api.openweathermap.org")
        controller = WeatherPresentationController(communicator: communicator)
        controller.delegate = self
        controller.accessLocation()
    }

}
extension WeatherViewController: WeatherPresentationControllerDelegate {
    func didFinishLoadingWeatherIcon(icon: UIImage?) {
        DispatchQueue.main.async {
            self.imageViewIcon.image = icon
        }
    }
    
    func didFinishLoadingWeather(formattedTemperature: String, locationName: String) {
        DispatchQueue.main.async {
            self.labelTemperature.text = formattedTemperature
            self.labelLocation.text = locationName
        }
    }
    
    func didFinishLoadingWeather(errorMsg: String) {
        DispatchQueue.main.async {
            let alertController = UIAlertController(title: "Error", message: errorMsg, preferredStyle: .alert)
            let okAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
            alertController.addAction(okAction)
            self.present(alertController, animated: true, completion: nil)
        }
    }
    
}
