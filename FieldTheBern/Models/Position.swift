//
//  Position.swift
//  FieldTheBern
//
//  Created by Amsal Karic on 7/10/16.
//  Copyright © 2016 Josh Smith. All rights reserved.
//

import UIKit
//import SwiftyJSON

class Position: NSObject {
    var position_id: Int
    var position_campaignId: Int
    var position_title: String
    var position_content: String
    
    override init() {
        self.position_id = -1
        self.position_campaignId = -1
        self.position_title = ""
        self.position_content = ""
        
        super.init()
    }
    
    init(positionJSON: JSON) {
        
        self.position_id = Int(positionJSON["id"].number!)
        self.position_campaignId = Int(positionJSON["campaign_id"].number!)
        self.position_title = positionJSON["title"].string!
        self.position_content = positionJSON["content"].string!
    }
}
