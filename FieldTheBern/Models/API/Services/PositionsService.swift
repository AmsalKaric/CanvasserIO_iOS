//
//  PositionsService.swift
//  FieldTheBern
//
//  Created by Amsal Karic on 7/10/16.
//  Copyright © 2016 Josh Smith. All rights reserved.
//

import Foundation
import SwiftyJSON

struct PositionService {
    
    typealias PositionResponse = ([Position]?, Bool, APIError?) -> Void
    
    let api = API()
    
    func campaignPositions(callback: PositionResponse) {
        let campaignId = Canvasser.sharedCanvasser.selectedCampaignId
        api.get("positionsforcampaign/"+String(campaignId), parameters: nil) { (data, success, error) -> Void in
            self.handlePositionResponse(data, true, error, callback: callback)
        }
    }
    
    func handlePositionResponse(data: NSData?, _ success: Bool, _ error: APIError?, callback: PositionResponse) {
        
        if success {
            // Extract positions into models
            if let data = data {
                
                let json = JSON(data: data)
                //print("printing positions: ")
                //print(json)
                var positions: [Position] = []
                
                for (_, result) in json {
                    let newPosition = Position(positionJSON: result)
                    positions.append(newPosition)
                }
                callback(positions, success, nil)
            }
        } else {
            print(error)
            callback(nil, success, error)
        }
    }
}
