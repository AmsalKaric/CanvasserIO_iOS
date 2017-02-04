//
//  TurfService.swift
//  FieldTheBern
//
//  Created by Amsal Karic on 7/4/16.
//  Copyright © 2016 Josh Smith. All rights reserved.
//

import Foundation
//import SwiftyJSON

struct TurfService {
    
    typealias TurfResponse = ([Turf]?, Bool, APIError?) -> Void
    
    let api = API()
    
    func campaignTurfs(callback: TurfResponse) {
        let campaignId = Canvasser.sharedCanvasser.selectedCampaignId
        api.get("turfs/forcampaign/"+String(campaignId), parameters: nil) { (data, success, error) -> Void in
            self.handleTurfResponse(data, true, error, callback: callback)
        }
    }
    
    func handleTurfResponse(data: NSData?, _ success: Bool, _ error: APIError?, callback: TurfResponse) {
        
        if success {
            // Extract turfs into models
            if let data = data {
                
                let json = JSON(data: data)
                //print("printing turf: ")
                //print(json)
                var turfs: [Turf] = []
                
                for (_, result) in json {
                    let newTurf = Turf(turfJSON: result)
                    turfs.append(newTurf)
                }
                callback(turfs, success, nil)
            }
        } else {
            print(error)
            callback(nil, success, error)
        }
    }
}
