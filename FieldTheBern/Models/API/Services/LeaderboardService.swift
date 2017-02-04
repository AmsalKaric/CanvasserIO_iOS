//
//  LeaderboardService.swift
//  FieldTheBern
//
//  Created by Josh Smith on 10/22/15.
//  Copyright © 2015 Josh Smith. All rights reserved.
//

import Foundation
import MapKit
//import SwiftyJSON

struct LeaderboardService {
    
    let api = API()
    
    func get(type: String, callback: (Leaderboard? -> Void)) {
        
        /*var obj: NSData? = nil
        let jsonObject: [[String:AnyObject]] = [
                ["id": "abcd",
                    "rank": 9,
                    "score": 59],
                ["id": "abcde",
                    "rank": 9,
                    "score": 59],
                ["id": "abc",
                    "rank": 9,
                    "score": 1337],
                ["id": "abcdef",
                    "rank": 9,
                    "score": 59]
        ]
        
        do {
            obj = try NSJSONSerialization.dataWithJSONObject(jsonObject, options: .PrettyPrinted)
        } catch let error {
            print(error)
        }*/
        
        // type is one of "everyone", "state", "friends"
        api.get("leaderboard/\(type)", parameters: [:]) { (data, success, error) in
            /*let success2 = true
            let data2 = obj*/
            
            if success {
                // Extract our addresses into models
                if let data = data {
                    
                    let json = JSON(data: data)

                    let leaderboard = Leaderboard(json: json)
                    
                    callback(leaderboard)
                }
                
            } else {
                // API call failed with no rankings
                print(error)
                callback(nil)
            }
        }
    }
    
}
