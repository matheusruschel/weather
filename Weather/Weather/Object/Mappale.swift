//
//  Mappale.swift
//  Weather
//
//  Created by Matheus Ruschel on 2020-09-27.
//  Copyright © 2020 Matheus Ruschel. All rights reserved.
//

import Foundation

protocol Mappable {
    init(dictionary: [AnyHashable: Any])
}
