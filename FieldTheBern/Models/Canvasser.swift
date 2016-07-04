//
//  Canvasser.swift
//  FieldTheBern
//
//  Created by Amsal Karic on 7/3/16.
//  Copyright © 2016 Josh Smith. All rights reserved.
//

import UIKit

class Canvasser: NSObject {
    static let sharedCanvasser = Canvasser()
    var selectedCampaignId: Int
    var selectedCampaignTitle: String
    var jwtToken: String
    
    override init() {
        self.selectedCampaignId = -1
        self.selectedCampaignTitle = ""
        self.jwtToken = ""
        super.init()
    }
}