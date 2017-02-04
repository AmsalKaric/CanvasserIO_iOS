//
//  CampaignService.swift
//  FieldTheBern
//
//  Created by Amsal Karic on 7/3/16.
//  Copyright © 2016 Josh Smith. All rights reserved.
//

import Foundation
//import SwiftyJSON

struct CampaignService {
    
    typealias CampaignResponse = ([Campaign]?, Bool, APIError?) -> Void
    
    let api = API()
    
    func activeCampaigns(callback: CampaignResponse) {
        api.get("campaignsActive", parameters: nil) { (data, success, error) -> Void in
            self.handleCampaignResponse(data, true, error, callback: callback)
        }
    }
    
    func handleCampaignResponse(data: NSData?, _ success: Bool, _ error: APIError?, callback: CampaignResponse) {
        
        if success {
            // Extract campaigns into models
            if let data = data {
                
                let json = JSON(data: data)
                var campaigns: [Campaign] = []
                
                for (_, result) in json {
                    let newCampaign = Campaign(campaignJSON: result)
                    campaigns.append(newCampaign)
                }
                callback(campaigns, success, nil)
            }
        } else {
            print(error)
            callback(nil, success, error)
        }
    }
}
