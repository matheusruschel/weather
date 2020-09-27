//
//  URLSessionCommunicator.swift
//  Weather
//
//  Created by Matheus Ruschel on 2020-09-27.
//  Copyright © 2020 Matheus Ruschel. All rights reserved.
//

import Foundation

class URLSessionWeatherCommunicator: WeatherAPICommunicator {
    
    var baseUrl: String
    let appId = "d7a12a132bf363c1c0ae7b8df6f2d42c"
    
    init(baseUrl: String) {
        self.baseUrl = baseUrl
    }
    
    func buildWeatherFetchURL(unit: String, latitude: Double, longitude: Double) -> URL? {
        let urlString = baseUrl + "/data/2.5/weather?lat=\(latitude)&lon=\(longitude)&units=\(unit)&appid=\(appId)"
        return URL(string: urlString)
    }
    
    func fetchWeatherInformation(unit: String,
                                 latitude: Double,
                                 longitude: Double,
                                 completion: @escaping WeatherFetchCompletionBlock<Weather>) {
        
        guard let url = buildWeatherFetchURL(unit: unit, latitude: latitude, longitude: longitude) else {
            completion(.error("An unexpected occurred"))
            return
        }

        let task = URLSession.shared.dataTask(with: url, completionHandler: { (data, response, error) in
            
            guard let httpResponse = response as? HTTPURLResponse,
                  (200...299).contains(httpResponse.statusCode) else {
                completion(.error("Error with the response, unexpected status code"))
              return
            }

            do {
                if let data = data, let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                    completion(.success(Weather(dictionary: json)))
                }
            } catch let error as NSError {
                completion(.error(error.localizedDescription))
            }
        })

        task.resume()
    }
    
    func loadWeatherIcon(name: String, completion: @escaping WeatherFetchCompletionBlock<Data>) {
        
        let urlString = baseUrl + "/img/wn/\(name)@2x.png"
        
        guard let url = URL(string: urlString) else {
            completion(.error("An unexpected occurred"))
            return
        }
        
        let task = URLSession.shared.dataTask(with: url, completionHandler: { (data, response, error) in
            
            guard let httpResponse = response as? HTTPURLResponse,
                  (200...299).contains(httpResponse.statusCode) else {
                completion(.error("Error with the response, unexpected status code"))
              return
            }
            if let data = data {
                completion(.success(data))
            } else {
                completion(.error("An unexpected occurred"))
            }
        })

        task.resume()
    }
    
    
    
    
}
