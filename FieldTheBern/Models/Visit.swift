//
//  Visit.swift
//  FieldTheBern
//
//  Created by Josh Smith on 10/13/15.
//  Copyright © 2015 Josh Smith. All rights reserved.
//

import Foundation
import SwiftyJSON

struct Visit {
    let id: String?
    let totalPoints: Int
    
    init(json: JSON) {
        self.id = json["id"].string
        self.totalPoints = json["total_points"].intValue
        
        print("Made visit with id: \(self.id) and points: \(self.totalPoints)")
    }
}