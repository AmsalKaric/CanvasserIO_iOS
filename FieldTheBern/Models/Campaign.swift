//
//  Campaign.swift
//  FieldTheBern
//
//  Created by Amsal Karic on 7/3/16.
//  Copyright © 2016 Josh Smith. All rights reserved.
//

import UIKit
//import SwiftyJSON

class Campaign: NSObject {
    var campaign_id: Int
    var campaign_candidateFname: String
    var campaign_candidateLname: String
    var campaign_title: String
    var campaign_description: String
    
    override init() {
        self.campaign_id = -1
        self.campaign_candidateFname = ""
        self.campaign_candidateLname = ""
        self.campaign_title = ""
        self.campaign_description = ""
        
        super.init()
    }
    
    init(campaignJSON: JSON) {
        
        if let num = campaignJSON["id"].number {
            self.campaign_id = Int(num)
        } else {
            self.campaign_id = -1
        }
        
        self.campaign_candidateFname = campaignJSON["candidate_fname"].string!
        self.campaign_candidateLname = campaignJSON["candidate_lname"].string!
        self.campaign_title = campaignJSON["title"].string!
        self.campaign_description = campaignJSON["description"].string!
    }
}
