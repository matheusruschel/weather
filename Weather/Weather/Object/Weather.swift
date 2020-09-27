//
//  Weather.swift
//  Weather
//
//  Created by Matheus Ruschel on 2020-09-27.
//  Copyright © 2020 Matheus Ruschel. All rights reserved.
//

import Foundation
import CoreLocation

class Weather: Mappable {
    
    var visibility: Int?
    var coord: CLLocationCoordinate2D?
    var currentTemperature: Double?
    var locationName: String?
    var iconName: String?
    
    required init(dictionary: [AnyHashable : Any]) {
        if let visibility = dictionary["visibility"] as? Int {
            self.visibility = visibility
        }
        
        let coord = dictionary["coord"] as? [AnyHashable : Any]
        let main = dictionary["main"] as? [AnyHashable : Any]
        let weatherList = dictionary["weather"] as? [[AnyHashable : Any]]
        
        if let iconName = weatherList?.first?["icon"] as? String {
            self.iconName = iconName
        }
        
        if let locationName = dictionary["name"] as? String {
            self.locationName = locationName
        }
        
        if let lat = coord?["lat"] as? String,
            let lon = coord?["lon"] as? String,
            let latDegrees = CLLocationDegrees(lat),
            let lonDegrees = CLLocationDegrees(lon) {
            
            self.coord = CLLocationCoordinate2D(latitude: latDegrees, longitude: lonDegrees)
        }
        
        if let temp = main?["temp"] as? Double {
            self.currentTemperature = temp
        }
        
    }
    
}
