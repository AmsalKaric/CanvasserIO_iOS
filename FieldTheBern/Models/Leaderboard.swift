//
//  Leaderboard.swift
//  FieldTheBern
//
//  Created by Josh Smith on 10/22/15.
//  Copyright © 2015 Josh Smith. All rights reserved.
//

import Foundation
import SwiftyJSON

struct Leaderboard {
    
    let rankings: [Ranking]
    
    init(json: JSON) {
        let rankings = json
        
        var rankingsTemp: [Ranking] = []
        for(_, ranking) in rankings {  //Go through each ranking
            var newRanking = Ranking(json: ranking)  //Make ranking object from index
            let newUser = User(userJSON: ranking)  //Make new user
            newRanking.user = newUser  //Set ranking user to user
            rankingsTemp.append(newRanking)  //ranking to rankings Temp
        }
        self.rankings = rankingsTemp
        
        
        
        
        /*var obj: NSData? = nil
        let jsonObject: [[String:AnyObject]] = [
            ["id": 6,
                "first_name": "Patricia",
                "last_name": "Martinazzisky",
                "email": "rickyt@triads.com",
                "total_points": 1337,
                "visits_count": 69],
            ["id": 323649,
                "first_name": "Ricky",
                "last_name": "Tan",
                "email": "rickyt@triads.com",
                "total_points": 15,
                "visits_count": 1]
        ]
        
        do {
            obj = try NSJSONSerialization.dataWithJSONObject(jsonObject, options: .PrettyPrinted)
        } catch let error {
            print(error)
        }
        
        let users = JSON(data: obj!)
        
        var rankingsTemp: [Ranking] = []

        for(_, ranking) in rankings {  //Go through each ranking
            var newRanking = Ranking(json: ranking)  //Make ranking object from index
            //print("on Ranking: \(ranking)")

            for(_, user) in users {  //Go through all users for the ranking
                //print("on User: \(user)")
                //print("\(newRanking.userId), \(user["id"].string)")
                if let rankingUserId = newRanking.userId {  //If we have a valid rankingId for the ranking
                    if let userId = user["id"].int {  //If we have a valid userID for the user
                        
                        //print("rankingUserId: \(rankingUserId), userId: \(userId)")
                        
                        if rankingUserId == userId {  //If rankingID matches userID
                            let newUser = User(userJSON: user)  //Make new user
                            newRanking.user = newUser  //Set ranking user to user
                            rankingsTemp.append(newRanking)  //ranking to rankings Temp
                        }
                    }
                }
            }
        }
        
        //print(rankingsTemp)
        self.rankings = rankingsTemp*/
    }
}