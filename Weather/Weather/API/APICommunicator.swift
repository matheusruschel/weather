//
//  APICommunicator.swift
//  Weather
//
//  Created by Matheus Ruschel on 2020-09-27.
//  Copyright © 2020 Matheus Ruschel. All rights reserved.
//

import Foundation

enum CompletionStatus<T> {
    case success(T)
    case error(String)
}

typealias WeatherFetchCompletionBlock<T> = (CompletionStatus<T>) -> Void

protocol WeatherAPICommunicator {
    
    func fetchWeatherInformation(unit: String,
                                 latitude: Double,
                                 longitude: Double,
                                 completion: @escaping WeatherFetchCompletionBlock<Weather>)
    
    func loadWeatherIcon(name: String, completion: @escaping WeatherFetchCompletionBlock<Data>)
}
