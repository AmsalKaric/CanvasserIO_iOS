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
    
    var turfs: [Turf]
    
    override init() {
        self.selectedCampaignId = -1
        self.selectedCampaignTitle = ""
        self.jwtToken = ""
        self.turfs = []
        super.init()
    }
    
    func initTurfs() {
        TurfService().campaignTurfs { (turfs, success, error) -> Void in
            if success {
                if let turfs = turfs {
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        self.turfs = turfs
                    })
                }
            } else {
                if let error = error {
                    print("Error!!!!!!!! \(error)")
                }
            }
            
        }
    }
}