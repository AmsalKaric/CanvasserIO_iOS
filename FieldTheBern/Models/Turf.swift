//
//  Turf.swift
//  FieldTheBern
//
//  Created by Amsal Karic on 7/4/16.
//  Copyright © 2016 Josh Smith. All rights reserved.
//

import UIKit
import SwiftyJSON

class Turf: NSObject {
    var turf_id: Int
    var turf_campaignId: Int
    var turf_geoJson: String
    var turf_title: String
    var turf_description: String
    var turf_points: Int
    var turf_active: Int
    var turf_bounds: [[String: Double]] = [[:]]
    var turf_addresses: [Address]
    
    override init() {
        self.turf_id = -1
        self.turf_campaignId = -1
        self.turf_geoJson = ""
        self.turf_title = ""
        self.turf_description = ""
        self.turf_points = 0
        self.turf_active = 0
        self.turf_bounds = [[:]]
        self.turf_addresses = []
        
        super.init()
    }
    
    init(turfJSON: JSON) {
        
        self.turf_id = Int(turfJSON["id"].number!)
        self.turf_campaignId = Int(turfJSON["campaign_id"].number!)
        self.turf_geoJson = turfJSON["geo_json"].string!
        self.turf_title = turfJSON["title"].string!
        self.turf_description = turfJSON["description"].string!
        self.turf_points = Int(turfJSON["points"].number!)
        self.turf_active = Int(turfJSON["active"].number!)
        
        
        self.turf_bounds = [[:]]
        /*for (_, included) in turfJSON["turf_bounds"] {
            var bound: [String:Double] = [:]
            bound["latitude"] = Double(included["latitude"].number!)
            bound["longitude"] = Double(included["longitude"].number!)
            self.turf_bounds.append(bound)
        }*/
        
        self.turf_addresses = []
    }
    
    /*
     * Grabs addresses for turf.
     */
    /*func addressesForTurf() {
    
        if (self.turf_addresses.count == 0) {
            TurfService().addressesForTurf { (addresses, success, error) -> Void in
                if success {
                    if let addresses = addresses {
                        dispatch_async(dispatch_get_main_queue(), { () -> Void in
                            self.campaigns = campaigns
                        })
                    }
                } else {
                    if let error = error {
                        print("Error!!!!!!!! \(error)")
                    }
                }
            }
        }
        
    }*/
}