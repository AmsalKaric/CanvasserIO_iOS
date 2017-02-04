//
//  Ranking.swift
//  FieldTheBern
//
//  Created by Josh Smith on 10/22/15.
//  Copyright © 2015 Josh Smith. All rights reserved.
//

import Foundation
//import SwiftyJSON

struct Ranking {
    
    let userId: Int?
    let rank: Int?
    let score: Int?

    var user: User?
    
    var scoreString: String? {
        get {
            if let score = self.score {
                let numberFormatter = NSNumberFormatter()
                numberFormatter.numberStyle = NSNumberFormatterStyle.DecimalStyle
                return numberFormatter.stringFromNumber(score)
            } else {
                return nil
            }
        }
    }
    
    init(json: JSON) {
        self.userId = json["id"].int

        if let rankNumber = json["rank"].number {
            self.rank = Int(rankNumber)
        } else {
            self.rank = nil
        }
        
        if let scoreNumber = json["total_points"].number {
            self.score = Int(scoreNumber)
        } else {
            self.score = 0
        }
    }
}
